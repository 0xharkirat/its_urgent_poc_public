# It's Urgent POC
![Static Badge](https://img.shields.io/badge/GSoC'24-8A2BE2) ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?s&logo=Flutter&logoColor=white) ![Firebase](https://img.shields.io/badge/firebase-a08021?&logo=firebase&logoColor=ffcd34)

##### Note: Use CTRL+click (on Windows and Linux) or CMD+click (on MacOS) for opening all the links in new tab. 
Please open issues if anything goes wrong, I am happy to assist & resolve.
<br>

This is a Proof of Concept (POC) for  [It's Urgent Project](https://ccextractor.org/public/gsoc/2024/itsurgent) for GSoC'24. 
- Watch the working Demo Video here: https://youtu.be/__nhs4On2zI (1.5x speed recommended).
- Download this Android [.apk](https://github.com/0xharkirat/its_urgent_poc_public/releases/download/beta-v1/its-urgent-poc.apk) for testing.
- This public repo is clone of my private repo which contains all the firebase files, secrets & apis.
- This is a public repo, it does not contain any firebase functionlity. 
- You need to add firebase project by following [these](#prerequisites) simple instructions which only requires some clicks, copy & paste.
- For more important notes regarding this poc, see this [section](#some-important-notes).
- You can also learn from these codelabs
   - [Firebase FCM Flutter](https://firebase.google.com/codelabs/firebase-fcm-flutter#0)
   - [Get to know Firebase for Flutter](https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0)


## Steps to add your Firebase project in this project.
### Prerequisites:
1. Check your Flutter installation using: `flutter doctor -v`.
2. Fork & clone this repo.
3. `cd <this repo>`.
4. Open in the Terminal/Android Studio/VS Code.
5. Install all plugins using: `flutter pub get` in the root folder of the project.
6. For iOS only (Important for getting firebase notifications):
   - Right click on iOS folder -> Open in Xcode -> Runner -> Signing & Capabilities -> Enter some unique Bundle Identifier (like com.<your_unique_name>.<unique_appName> & press enter to check availability.
   - Then again in VSCode or your editor go to ios/Runner/Info.plist.
   - Change the CFBundleIdentifier to your own unique identifier like I did:
   - <img width="463" alt="Screenshot 2024-03-18 at 4 55 53 am" src="https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/b8a2db93-ee05-41aa-aa75-8df2111b83e6">

   
7. Go to https://console.firebase.google.com/ to create a Firebase account.
8. If you haven't already, install the [Firebase CLI](https://firebase.google.com/docs/cli#setup_update_cli) (Use npm: recommended).
9. Also remove these lines from .gitignore file at the root folder of your project. Thesse lines were added by me to prevent git to track my firebase files:
```
/android/app/google-services.json
/ios/firebase_app_id_file.json
/ios/Runner/GoogleService-Info.plist
lib/firebase_options.dart
```
10. Now move to Firebase section to add Firebase in your project.

### Add Firebase:
- Follow [these steps](https://firebase.google.com/docs/flutter/setup?platform=web) to add Firebase to this project.
- or, watch this [YouTube Video](https://www.youtube.com/watch?v=FkFvQ0SaT1I&t).

### Setup Firebase Authentication:
- Go to Firebase [console](https://console.firebase.google.com/) -> Click on your Project which you added to this flutter app.
- On the left side menu, click `Build` -> `Authentication` -> `Get Started` -> `Sign-in method` tab -> `Anonymous` -> `Enable` (switch on) -> `Save`.

### Setup Firebase Cloud Firestore:
- On the left side menu, click `Build` -> `Firestore Database` -> `Create Database` -> `Next` & `Create` (With default options).
- Once created, Select `Rules tab` -> Paste these rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // auth
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
- `Publish`.


### Setup Firebase Cloud Messaging (FCM):
- Click on Settings Icons next to `Project Overview` in the left side menu.
- Click on `Project Settings` -> `Cloud Messaging tab`.
- Click on `⋮` (three dots) next to `Cloud Messaging API (Legacy) Disabled`.
- Click on `Manage Api in Google Cloud Console`. It will redirect to Google cloud console page.
- Check your project name at the top and then click `enable`.
- Once enabled, come back to the Firebase console to see whether it is enabled.
- Now copy the `Server key`. 
- Paste it in lib/secret.dart at `<paste your own key from firebase cloud messaging>`.
- All done.

### Set up Cloud Messaging for iOS (Important) - needs Apple developer account:
- Navigate to the Apple [developer](https://developer.apple.com/account/resources/authkeys/list) page, and click Create a key on the Keys tab.
![image](https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/7f5ae39d-a18e-4a26-a49e-40c73351e778)


- Enter the name for the key and check Apple Push Notifications services (APNs).
  ![image](https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/ea076b26-5e3c-4c4c-ade9-0dd87ce4979e)

- Download the key file, which has a .p8 file extension. Take note of Key Id & Team ID (At the top rigth corner):
  ![image](https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/9ce9f7f6-33f0-4f85-afab-cd179502198a)
  <img width="463" alt="Screenshot 2024-03-18 at 5 09 29 am" src="https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/692d9e18-5eb2-43e6-8eeb-92646589120a">

  

- In the Firebase console, navigate to the project's Project Settings and choose the Cloud Messaging tab.
![image](https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/b4aa3680-b4cf-4264-a38a-936fbbd8a881)

![image](https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/a4111f52-3dc6-4aa4-859f-9f1e94e936ce)


- Upload the APNs key file for the iOS app in the Cloud Messaging tab.
- Enter the `APNs key ID` from the Cloud Messaging tab and the `team ID`, which can be found at the top right corner in the Apple membership center.
  ![image](https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/3086390e-a049-4527-98ac-7d197e2f08b9)

### iOS Signing & Capabilites:
- Again open the project in Xcode.
- Click on `Runner` -> `Signing & Capabilites` -> `+ Capability` <img width="788" alt="Screenshot 2024-03-18 at 5 18 16 am" src="https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/0c36e067-298e-466d-804d-58dfcf5b79d9">
- Click on Push Notifications.


- Enter Push Notifications inside the Capabilties search:<img alt="" src="https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/d97544a5-b142-4b73-89c4-0dc588c1a240">
- Now Search for "Background Modes":
  ![image](https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/99312095-6070-48ca-a8f8-1945eb7cd8aa)
- Click on Background modes.
- Now ensure that both the "Background fetch" and the "Remote notifications" sub-modes are enabled:



![ezgif com-avif-to-gif-converter](https://github.com/0xharkirat/its_urgent_poc_public/assets/65155920/9e8809b2-324d-46f9-84ae-011e5d409ac8)

- All Done.



### Run App
- Now you can connect physical device or simulator to run using `flutter run`.
- If you have multiple devices connected, it will ask you to select one device.
- iOS simulators have problem showing notifications from Firebase, use physical iOS devices instead.

#### Some Important notes:
- This project uses Kotlin 1.8.0, which is required for app_settings plugin.
`id "org.jetbrains.kotlin.android" version "1.8.0" apply false` in your android/settings.gradle 
- In this poc, Notifications only shows when app is in the background mode.
- For the foreground mode, it requires extra functionality which I will implement using the [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) or [awesome_notifications](https://pub.dev/packages/awesome_notifications) package during my GSoC period.
- It also does not check for device's DND mode. Full functionality during GSoC period.
- It is currently using Cloud Messaging API (Legacy) for sending notifications, which is deprecated, I will use Firebase Cloud Messaging API (V1) which is recommended in the full project during my GSoC period.
- It does not uses any other backend server, cloud functions to handle complex logics such as checking for dnd mode, notifying the sender about challenges etc. as required & mentioned in project page. All functionality will be implemented using Firebase cloud functions, which will also act as security layer for cloud firestore db.
- Currently Phone numbers are stored as plain numbers, I will implement functionality to store phone number data in encrypted mode using cloud functions.
