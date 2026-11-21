# SMARTMAP PUNJAB — RELEASE NOTES

## v1.0.0 (build 1) — 2026-11-22

**Tagline:** Explore Punjab. Travel with Confidence.

### Build artifacts

| Artifact | Value |
|---|---|
| APK | `mobile/build/app/outputs/flutter-apk/app-release.apk` (57.9 MB / 60,671,930 bytes) |
| Package | `com.smartmappunjab.app` |
| Version | `1.0.0` (versionCode 1) |
| minSdk / targetSdk | 24 / 36 |
| Signing | APK Signature Scheme v2, single signer |
| Certificate | `CN=SmartMap Punjab, OU=Mobile, O=SmartMap Punjab, L=Lahore, ST=Punjab, C=PK` |
| Cert SHA-256 | `d5b6aa966a8c8f198d8348899e604c2061ed0e5f76e46811413bf7802a8590ca` |
| APK SHA-256 | `82c54bf49424e656cc2eda94192d6a0b9807d7e32df680513dd581e2daa3ee85` |

Web release build (`flutter build web --release`) also completes successfully.

### What is included

- 81-city Punjab directory and 27-place offline fallback with categories, search,
  filters and map/detail surfaces.
- Offline TTL cache with explicit Live / Cached / Expired / Unavailable labelling.
- Facility finder (hospitals, pharmacies, fuel, ATMs, police, parking, food,
  washrooms, water) with verification dates where known.
- Road advisories for seven corridors with official source links; status is
  **not** claimed live.
- Travel reality check, price fairness guidance, journey readiness checklist,
  local culture companion.
- Permits/NOC guidance, foreign visitor toolkit (PTA steps, manual-rate
  converter, embassy directory link), on-device digital tourist pass, on-device
  complaint records.
- Direct-dial emergency contacts; no SOS transmission is offered.
- Backend with JWT/RBAC, moderation, audit logging, rate limits and upload
  hardening.

### Honesty changes in this release

- Bundled star ratings and review counts were removed; places show
  "No reviews yet" until real reviews exist.
- Fabricated live road/price/verification data was replaced with sourced
  guidance and explicit unavailability.
- Digital pass and complaints are clearly labelled app-generated/on-device, not
  government systems.
- The backend SOS endpoint now returns 503 (no gateway connected) instead of
  implying help was dispatched.

### Build changes

- Removed the unused `telephony` plugin, which blocked the Android release build
  (missing namespace under AGP 9).
- Release signing is enforced: the build fails if `android/key.properties` is
  missing. Application ID and Kotlin package changed to `com.smartmappunjab.app`.

### Known limitations

- No on-device journey verification was possible in this environment (no Android
  device attached); widget tests and static analysis cover the code paths.
- Urdu switching and RTL are partial, not interface-wide.
- Ratings/reviews depend on the backend; without it the app runs on bundled data.
- Road status, official rates, exchange rates and embassy details are not live.
- No push notifications, payments, permit submission, complaint delivery or SMS.
- The Google Maps key is still declared in `AndroidManifest.xml`; restrict and
  rotate it before store publication.
- The MongoDB credential exposed in earlier Git history must be rotated.

### Keystore handover (critical)

`mobile/android/app/smartmap-release.jks` and `mobile/android/key.properties`
are intentionally **not** committed. Back both files up securely now. Losing the
keystore means future updates cannot be published under the same application ID.
The passwords exist only in `key.properties`; store them in your password manager.

### Store checklist still open

1. Rotate the exposed Atlas credential and restrict the Maps key.
2. Privacy policy URL + data safety declaration (location, photos, account data).
3. Screenshots, feature graphic and store copy.
4. On-device smoke test on a physical Android build.
