import argparse
import datetime as dt
import firebase_admin

from firebase_admin import credentials, firestore

import scrapers

cred = credentials.Certificate("keyfile.json")
firebase_admin.initialize_app(cred)
db = firestore.client()


def main(course_subject, limit, **kwargs):
    unis = {
        "University of New South Wales": lambda: scrapers.get_unsw_courses(
            course_subject, limit
        ),
        "University of Sydney": lambda: scrapers.get_usyd_courses(
            course_subject, limit
        ),
    }

    for uni in unis:
        print(f"Adding chats for {uni}")
        courses = unis[uni]()
        add_course_chats(uni, courses)


def add_course_chats(university, courses):
    print("Creating course chats")
    total = len(courses)

    for i, (course_code, course_name) in enumerate(courses):
        if (i + 1) % 50 == 0:
            print(f"Created {i + 1}/{total} chats")

        doc_ref = db.collection("chats").document()
        doc_ref.set(
            {
                "title": f"{course_code} {course_name}",
                "type": "course",
                "university": university,
                "lastMessage": "Chat created",
                "lastMessageUser": "OffCampus",
                "updatedAt": dt.datetime.utcnow(),
                "numMembers": 0,
            }
        )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-c",
        "--course_subject",
        help="Limit to only scrape for a specific course subject",
    )
    parser.add_argument(
        "-l",
        "--limit",
        type=int,
        help="Limit the number of courses to be scraped for each university",
    )
    parser.set_defaults(method=main)

    args = parser.parse_args()
    args.method(**vars(args))
