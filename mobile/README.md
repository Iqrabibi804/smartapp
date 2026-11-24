# SmartMap Punjab — Flutter mobile app

The Flutter application for SmartMap Punjab.

## Requirements

- Flutter SDK (use the version pinned by the repository CI workflow)
- Android SDK / Android Studio for Android builds
- Node.js and the backend service only when testing API-backed functionality

## Run locally

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Run commands from this `mobile/` directory.

## Backend connection

The default API base URL is configured for the Android emulator. For a physical
device or deployed backend, provide the appropriate API base URL using the
project's supported `--dart-define=API_BASE_URL=...` setting.

Never put MongoDB credentials, JWT signing secrets, or other server credentials
in the Flutter app.

## Android Google Maps key

The Android manifest reads the key from the Gradle placeholder
`GOOGLE_MAPS_API_KEY`. Supply it locally through either:

- `~/.gradle/gradle.properties`: `GOOGLE_MAPS_API_KEY=your_restricted_key`
- The `GOOGLE_MAPS_API_KEY` environment variable.

Do not commit the key. Restrict it in Google Cloud to the Android application
ID `com.smartmappunjab.app`, the relevant signing certificate SHA-1
fingerprints, and only the APIs the app needs. A missing key does not prevent
the debug APK from compiling, but map functionality requiring Google Maps
authentication will not work.

## Android release signing

Release signing is configured locally with the ignored
`android/key.properties` file and a private keystore. Never commit either
file. Back up the keystore securely; losing it can prevent publishing updates
to an existing Play Store application.
