import datetime as dt
import firebase_admin
import requests

from bs4 import BeautifulSoup
from firebase_admin import credentials, firestore


def main():
    url = "https://www.timetable.usyd.edu.au/uostimetables/2020/"
    courses = get_courses(url)
    add_course_chats(courses)


def get_courses(url):
    print("Scraping courses")
    courses = []
    r = requests.get(url)
    soup = BeautifulSoup(r.text, features="html.parser")
    trs = soup.find("table").find_all("tr")

    for tr in trs[1:]:
        tds = tr.find_all("td")
        if tds[2].text.lower() == "semester 2":
            courses.append((tds[0].text, tds[3].text))

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
                "university": "University of Sydney",
                "lastMessage": "Chat created",
                "lastMessageUser": "OffCampus",
                "updatedAt": dt.datetime.utcnow(),
                "numMembers": 0,
            }
        )


if __name__ == "__main__":
    main()
