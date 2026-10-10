# Practical 9: Connect Flutter UI with Firebase Realtime Database

This project targets **Flutter Web** for browser previews in GitHub Codespaces.
Its Web UI uses Firebase Core, Firebase Authentication (anonymous sign-in),
and Firebase Realtime Database. Firebase credentials are intentionally not
included in this repository.

## Configure Firebase once

1. In the [Firebase Console](https://console.firebase.google.com/), create a
   Firebase project.
2. In **Project settings → Your apps**, add a **Web app** (`</>`). The app name
   can be `practical-9-web`; hosting setup is not required.
3. In **Build → Realtime Database**, create a database and choose its location.
   Do this before FlutterFire configuration so its database URL can be included
   in the generated platform options.
4. In **Build → Authentication → Sign-in method**, enable **Anonymous**.
   This app signs users in anonymously so database access can be limited to
   that user's own records.
5. Install and sign in to the Firebase CLI and install FlutterFire CLI if you
   have not already:

   ```sh
   npm install -g firebase-tools
   firebase login
   dart pub global activate flutterfire_cli
   ```

6. From this project directory, connect the Web app and generate its real
   Firebase options:

   ```sh
   cd practical_9
   flutter pub get
   flutterfire configure --platforms=web
   ```

   Select the Firebase project and Web app created above. FlutterFire
   generates/replaces `lib/firebase_options.dart`; do not enter fabricated
   project IDs or API keys. The app initializes Firebase with
   `DefaultFirebaseOptions.currentPlatform`.

## Database rules

In **Realtime Database → Rules**, use rules that restrict access to the
currently authenticated user's own `users/{uid}` branch and validate record
fields. For example:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "auth != null && auth.uid === $uid",
        ".write": "auth != null && auth.uid === $uid",
        "$recordId": {
          ".validate": "newData.hasChildren(['name', 'email'])",
          "name": {
            ".validate": "newData.isString() && newData.val().length > 0"
          },
          "email": {
            ".validate": "newData.isString() && newData.val().matches(/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\\\.[A-Za-z]{2,}$/)"
          }
        }
      }
    }
  }
}
```

Publish the rules in the Firebase Console. Do not deploy permanent
unrestricted public read/write rules. Rules or Authentication misconfiguration
will be shown as a connection/write error by the app.

## Run in Codespaces

From the repository root:

```sh
cd practical_9
flutter pub get
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

Open the **Ports** tab in VS Code/Codespaces, forward port **8080** if needed,
and choose **Open in Browser**. Firebase web options must be generated for the
Web app; Android configuration alone will not configure this browser build.

## Practical checklist

- The configured browser build starts with Firebase initialized and anonymous
  authentication enabled.
- Enter a name and valid email, then submit. The success SnackBar appears only
  after Realtime Database confirms the write.
- The form clears and the saved record appears under the current user's
  `users/{uid}` branch.
- Adding or changing data in that branch updates **Saved Records** through the
  live `onValue` stream. Invalid forms, empty data, malformed records, and
  Firebase errors each have explicit UI states.

Before Firebase is configured, the app intentionally displays a setup screen
and the Firebase error; it does not use fake records or claim a successful
connection.
