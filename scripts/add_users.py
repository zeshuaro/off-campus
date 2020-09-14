import firebase_admin
import os
import random

from deepface import DeepFace
from faker import Faker
from firebase_admin import credentials, firestore, storage

cred = credentials.Certificate("keyfile.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
storage = storage.bucket(f"{cred.project_id}.appspot.com")

UNIS = ["University of New South Wales", "University of Sydney"]
LEVELS = ["Bachelor", "Master"]
DEGREES = [
    ("Engineering", "Computer Science"),
    ("Engineering", "Software Engineering"),
    ("Business School", "Commerce"),
    ("Art & Design", "Design"),
    ("Arts & Social Sciences", "Education"),
    ("Built Environment", "Landscape Architecture"),
    ("Law", "Science/Law"),
    ("Medicine", "Exercise Physiology"),
    ("Science", "Psychology"),
]
YEARS = ["1st", "2nd", "3rd", "4th"]


def main():
    fake = Faker()
    image_dir = "images"
    filenames = os.listdir(image_dir)
    total = len(filenames)

    for i, filename in enumerate(filenames):
        print(f"Adding {i + 1}/{total} user ({filename})")
        file_path = os.path.join(image_dir, filename)

        blob_name = f"users/{filename}"
        blob = storage.blob(blob_name)
        blob.upload_from_filename(file_path)

        demography = DeepFace.analyze(
            file_path, actions=["gender"], enforce_detection=False
        )
        if demography["gender"] == "Man":
            first_name = fake.first_name_male()
            last_name = fake.last_name_male()
        else:
            first_name = fake.first_name_female()
            last_name = fake.last_name_female()

        uni = random.choice(UNIS)
        level = random.choice(LEVELS)
        faculty, degree = random.choice(DEGREES)
        years = YEARS if level == "Bachelor" else YEARS[:2]
        year = random.choice(years)

        doc_ref = db.collection("users").document()
        doc_ref.set(
            {
                "name": f"{first_name} {last_name}",
                "image": blob_name,
                "summary": fake.paragraph(5),
                "university": uni,
                "faculty": faculty,
                "degree": f"{level} of {degree} {year} Year",
            }
        )


if __name__ == "__main__":
    main()
