import datetime as dt
import firebase_admin
import re

from firebase_admin import credentials, firestore
from requests_html import HTMLSession


def main():
    base_url = "http://classutil.unsw.edu.au"
    course_subjects = get_course_subjects(base_url)
    courses = get_courses(base_url, course_subjects)
    add_course_chats(courses)


def get_course_subjects(base_url):
    print("Scraping course subjects")
    session = HTMLSession()
    r = session.get(base_url)
    trs = r.html.find("table")[1].find("tr")

    course_subjects = []
    for tr in trs:
        tds = tr.find("td")
        if len(tds) == 6 and tds[3].text:
            course_subjects.append(tds[4].text)

    return course_subjects


def get_courses(base_url, course_subjects):
    print("Scraping courses")
    courses = []
    session = HTMLSession()

    for course_subject in course_subjects:
        url = f"{base_url}/{course_subject}_T3.html"
        r = session.get(url)
        trs = r.html.find("table")[2].find("tr")

        course_code = course_name = None
        has_enrolls = has_pgrd = False
        added_course_codes = set()

        for tr in trs[1:]:
            tds = tr.find("td")

            # Check if it is course header row
            if len(tds) == 2:
                has_enrolls = has_pgrd = False
                course_code, course_name = [x.text for x in tds]

            # Check if it is course body row
            elif len(tds) == 8:
                if not has_enrolls:
                    percent = re.search(r"\d+", tds[6].text)

                    # Check if there are students enrolled in the course
                    if percent is not None and int(percent[0]) > 0:
                        has_enrolls = True
                        added_course_codes.add(course_code)
                        courses.append((course_code, course_name))
                elif not has_pgrd:
                    # Lookup potential postgraduate course code
                    pgrd_course_code = re.search(r"[A-Z]{4}\d{4}", tds[7].text)
                    if pgrd_course_code is not None:
                        pgrd_course_code = pgrd_course_code[0]
                        if pgrd_course_code not in added_course_codes:
                            added_course_codes.add(pgrd_course_code)
                            ugrd_course_code, course_name = courses.pop()

                            # Only update course code if the codes of the
                            # undergraduate and postgraduate courses are different
                            if ugrd_course_code != pgrd_course_code:
                                has_pgrd = True
                                pgrd_code = re.search(r"\d{4}", pgrd_course_code)[0]
                                course_code = f"{ugrd_course_code}/{pgrd_code}"
                                courses.append((course_code, course_name))
                            else:
                                courses.append((ugrd_course_code, course_name))

    return courses


def add_course_chats(courses):
    print("Creating course chats")
    cred = credentials.Certificate("keyfile.json")
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    total = len(courses)

    for i, (course_code, course_name) in enumerate(courses):
        if (i + 1) % 50 == 0:
            print(f"Created {i + 1}/{total} chats")

        doc_ref = db.collection("chats").document()
        doc_ref.set(
            {
                "title": f"{course_code} {course_name}",
                "type": "course",
                "university": "University of New South Wales",
                "lastMessage": "Chat created",
                "lastMessageUser": "OffCampus",
                "updatedAt": dt.datetime.utcnow(),
                "numMembers": 0,
            }
        )


if __name__ == "__main__":
    main()
