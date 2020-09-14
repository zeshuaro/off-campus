import requests

from bs4 import BeautifulSoup


def get_usyd_courses(course_subject, limit):
    print("Scraping courses")
    courses = []
    r = requests.get("https://www.timetable.usyd.edu.au/uostimetables/2020/")
    soup = BeautifulSoup(r.text, features="html.parser")
    trs = soup.find("table").find_all("tr")

    for tr in trs[1:]:
        if limit is not None and len(courses) == limit:
            break

        tds = tr.find_all("td")
        if course_subject is not None and not tds[0].text.lower().startswith(
            course_subject.lower()
        ):
            continue

        if tds[2].text.lower() == "semester 2":
            courses.append((tds[0].text, tds[3].text))

    return courses
