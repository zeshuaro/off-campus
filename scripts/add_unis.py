import firebase_admin

from firebase_admin import credentials, firestore

cred = credentials.Certificate("keyfile.json")
firebase_admin.initialize_app(cred)
db = firestore.client()


def main():
    doc_ref = db.collection("unis").document()
    doc_ref.set(
        {
            "name": "University of New South Wales",
            "faculties": [
                "Art & Design",
                "Arts & Social Sciences",
                "Built Environment",
                "Business School",
                "Engineering",
                "Law",
                "Medicine",
                "Science",
            ],
        }
    )

    doc_ref = db.collection("unis").document()
    doc_ref.set(
        {
            "name": "University of Sydney",
            "faculties": [
                "Arts and Social Sciences",
                "Business",
                "Engineering",
                "Medicine and Health",
                "Science",
                "Architecture, Design and Planning",
                "Conservatorium of Music",
                "Law",
            ],
        }
    )


if __name__ == "__main__":
    main()
