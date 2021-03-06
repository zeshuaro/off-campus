# OffCampus

OffCampus is an essential app for university life, meeting new friends and discussing about courses and interests.

![OffCampus screenshots](images/screenshots.png)

## Background

With all the university courses shifted into an online teaching and learning environment, students have barely been going onto the campus, making it almost impossible to meet new friends and very hard to discuss about your courses informally.

OffCampus is a platform for university students to:

- Meet new friends from the same degree or across different universities and faculties
- Find and join from the list of pre-loaded course chats to discuss about your coursework (No need to ask for group chats for courses on CSESoc Facebook group anymore!)
- Chat and send messages with your friends and colleagues

### Built With

- [Flutter](https://flutter.dev/) for building the mobile app
- [flutter_bloc](https://bloclibrary.dev/) for state management
- [Firebase](https://firebase.google.com/) for authentication, database and storage

### Folder Structure

```
.
├── lib/                  # App source code
│   ├── blocs/            # Blocs for state management
│   ├── common/           # Constants and app theme
│   ├── repos/            # Repositories for making API calls
│   ├── screens/          # Screens for the app
│   └── widgets/          # Widgets shared across multiple screens
└── scripts/              # Helper scripts for adding data into the database
```

## Getting Started

### Setup Flutter

To install and setup Flutter, follow the instructions [here](https://flutter.dev/docs/get-started/install).

### Setup Firebase

Create a new project on Firebase.

- For iOS, create an iOS app and download the config file `GoogleService-info.plist`, and place it under `ios/Runner/`. 
- For Android, create and Android app and download the config file `google-services.json`, and place it under `android/app/`.

#### Authentication

Enable authentication by going into Authentication > Sign-In method > Email/Password > Enable > save.

![Firebase authentication setup](images/firebase_auth.png)

#### Cloud Firestore and Storage

Enable Cloud Firestore and Storage by going into the corresponding tabs and select a region.

#### Service Account

Create a service account by going into Settings > Project settings > Service accounts > Firebase Admin SDK > Generate new private key. Rename the file to `keyfile.json` and place it under scripts/.

### Setup Database

We provide some Python scripts to initialise and add data into Cloud Firestore. The scripts require Python 3.6+. 

Install the required packages with the command below:

    cd scripts/
    pip3 install -r requirements.txt

#### Add University Data

Currently we have data for University of New South Wales (UNSW) and University of Sydney (USYD). Run the following command to insert the data:

    python3 add_unis.py

#### Add Course Chat Data

The script defaults to scrape all available courses in Term 3 for UNSW and Semester 2 for USYD. For testing purposes, we recommend __NOT__ to scrape and insert all the courses. The `-c` option can be used to filter courses by subject and `-l` to limit the number of courses to be inserted for __each__ university. Below is an example of running the script with the options:

    python3 add_chats.py -c COMP -l 5

#### (Optional) Add User Data

We also included a script to insert some dummy user data and included a set of user profile pictures under `scripts/images/`. You can create more users by adding more pictures under that folder.

__Note that__ this script runs a machine learning model to classify the gender of the profile pictures. It requires some extra packages and to download the model (~500 MB) in order to prcess the pictures.

To get started, install the extra packages:

    pip3 install -r requirements_extra.txt

Run the script to insert the user data:

    python3 add_users.py

### Setup and Running the App

Navigate back to the root of the project and run the command below to install the Flutter packages:

    flutter pub get

Run the code generator to generate files for the model classes:

    flutter pub run build_runner build

Run the app:

    flutter run

## To-Do

- [ ] Email verification of university students
- [ ] Unread status of new messages
- [ ] Notifications for new messages
- [ ] Profile page for updating user details
- [ ] Add widgets tests

## Credits

- App icon made by [Freepik](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](https://www.flaticon.com/)
- Onboarding images designed by [pch.vector / Freepik](http://www.freepik.com)
