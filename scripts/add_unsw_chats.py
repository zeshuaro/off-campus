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
    courses = []
    session = HTMLSession()

    for course_subject in course_subjects[:1]:
        url = f"{base_url}/{course_subject}_T3.html"
        r = session.get(url)
        trs = r.html.find("table")[2].find("tr")
        course_code = course_name = None
        is_checked = False

        for tr in trs[1:]:
            tds = tr.find("td")
            if len(tds) == 2:
                is_checked = False
                course_code, course_name = [x.text for x in tds]
            elif len(tds) == 8 and not is_checked:
                percent = re.search(r"\d+", tds[6].text)
                if percent is not None and int(percent[0]) > 0:
                    is_checked = True
                    courses.append(f"{course_code} {course_name}")

    return courses


def add_course_chats(courses):
    cred = credentials.Certificate("keyfile.json")
    firebase_admin.initialize_app(cred)
    db = firestore.client()

    for course in courses:
        doc_ref = db.collection("chats").document()
        doc_ref.set(
            {
                "title": course,
                "type": "group",
                "university": "University of New South Wales",
                "lastMessage": "Chat created",
                "lastMessageUser": "OffCampus",
                "updatedAt": dt.datetime.now(),
            }
        )


if __name__ == "__main__":
    main()
