# Android Google Maps API key setup

The Android manifest intentionally contains a Gradle manifest placeholder instead of a committed API key.

## Configure a developer machine

Add this property to the user's global Gradle properties file (outside this repository):

- Windows: `%USERPROFILE%\.gradle\gradle.properties`
- macOS/Linux: `~/.gradle/gradle.properties`

Add:

```properties
GOOGLE_MAPS_API_KEY=your_restricted_android_maps_key
```

Alternatively, provide `GOOGLE_MAPS_API_KEY` as an environment variable to the Gradle build process.

Do not add the real key to this repository, `mobile/android/gradle.properties`, source code, screenshots, issue reports or build logs. A missing key does not prevent the Android package from compiling, but Google Maps tiles will not load until a valid key is configured.

## Restrict the key in Google Cloud

Create or rotate the key in the Google Cloud project, then apply all of these restrictions:

1. Application restriction: Android apps.
2. Package name: `com.smartmappunjab.app`.
3. Add the SHA-1 certificate fingerprints for each signing identity (debug and release).
4. API restriction: enable only the Maps SDK for Android and any additional Google APIs that the app demonstrably uses.
5. Set billing alerts and review usage for unexpected traffic.

A key that has appeared in a public repository must be treated as exposed. Restricting the old key is not a substitute for rotating it. Revoke the exposed key after the replacement is working.

## CI

The web build does not require the Android Maps key. If Android builds are later added to CI, store the restricted key as a GitHub Actions secret and expose it only to the Android build step as `GOOGLE_MAPS_API_KEY`. Never print it.
