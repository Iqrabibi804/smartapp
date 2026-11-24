# SmartMap Punjab

**Explore Punjab. Travel with Confidence.**

An independent, Punjab-first tourism platform: Flutter mobile app + Node/Express/MongoDB API.
Built to combine destination discovery, honest travel information, price transparency, and
emergency support in one place — with offline-first behavior for low-connectivity areas.

> This project is not affiliated with, approved by, or endorsed by any government body.
> It does not use official state emblems. Government integrations (permits, official rates,
> complaints) are represented as clearly labeled guidance workflows unless an authorized API exists.

The implementation roadmap and working rules live in [docs/MASTER_PROMPT.md](docs/MASTER_PROMPT.md).
Phase-by-phase status is tracked in [docs/IMPLEMENTATION_PROGRESS.md](docs/IMPLEMENTATION_PROGRESS.md)
and the feature matrix in [docs/FEATURE_STATUS.md](docs/FEATURE_STATUS.md).

Release and reference documents: [docs/RELEASE_NOTES.md](docs/RELEASE_NOTES.md),
[docs/PRODUCT_REQUIREMENTS.md](docs/PRODUCT_REQUIREMENTS.md),
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md),
[docs/DATA_SOURCES.md](docs/DATA_SOURCES.md),
[docs/API_DEPENDENCIES.md](docs/API_DEPENDENCIES.md),
[docs/SECURITY_REVIEW.md](docs/SECURITY_REVIEW.md).

## Android build configuration

The Google Maps Android key is injected at build time; it is not stored in the
manifest or source control. Set `GOOGLE_MAPS_API_KEY` in your environment or in
`~/.gradle/gradle.properties` before building. Restrict the key in Google Cloud
to Android package `com.smartmappunjab.app`, the release/debug signing
certificate SHA-1 fingerprints you use, and only the required Maps SDK APIs.
A build without this value can compile, but Google Maps tiles/features that
require the key will not work.

Release signing reads `mobile/android/key.properties` (gitignored) and
`mobile/android/app/smartmap-release.jks` (gitignored). Back both files up; losing the
keystore blocks future updates. Build with a reachable API:

```bash
cd mobile
flutter build apk --release --dart-define=API_BASE_URL=https://your-api.example.com/api
```

The default `API_BASE_URL` is `http://10.0.2.2:5000/api` (Android emulator).

---

## Repository layout

```
smartapp/
├── mobile/                Flutter app (Android-first, iOS-ready)
│   ├── lib/core/          constants, theme, localization, services,
│   │                      offline data (81 Punjab cities)
│   ├── lib/features/      admin, ai, auth, business, categories, directions,
│   │                      events, favorites, home, map, onboarding, places,
│   │                      reviews, search, splash, trips
│   ├── test/              widget/unit tests
│   └── android/           Android platform project
├── backend/               Node.js + Express + MongoDB API
│   ├── models/            User, Place, Business, Category, Event, Review,
│   │                      SavedPlace, Trip, CustomList, emergency
│   ├── routes/            auth, places, categories, reviews, favorites, ai,
│   │                      trips, events, businesses, admin, emergency,
│   │                      upload, directions, lists
│   ├── scripts/           Punjab seed scripts
│   └── server.js          Express entry point (helmet, CORS, rate limiting)
├── admin-dashboard/       Reserved for a future web admin (placeholder)
└── docs/                  Master prompt, progress, feature status, research
```

## Implemented modules (code exists — verification ongoing)

- Auth (register/login, JWT, RBAC), light/dark theme
- 81-city Punjab guide, city explorer, city guide, place details
- Search and filters, saved places (favorites)
- Reviews with media submissions
- Trip planner, my trips, trip details
- Budget calculator, group bill splitter
- Taxi fare estimation, local-vs-tourist price guidance (anti-scam)
- Offline city packs, offline payment guide
- Road infrastructure alerts (data honesty under review)
- Events, business registration and management
- AI assistant screen + backend `/api/ai` (grounding/hardening in progress)
- In-app admin screens (users, places, businesses, reviews)

Status details, including what is unverified or missing, are in `docs/FEATURE_STATUS.md`.

## Known gaps (tracked in the roadmap)

- Automated backend and Flutter tests run in CI; see the latest [Quality checks](https://github.com/Iqrabibi804/smartapp/actions/workflows/quality-checks.yml) run for the exact status.
- Urdu localization exists in code but interface switching is incomplete.
- Bundled fonts (Poppins / Roboto / Noto Nastaliq Urdu) are not yet declared.
- Legacy multi-palette theme is being replaced by the canonical national identity.
- Android release signing is optional and must be configured locally using the ignored `mobile/android/key.properties` and keystore files.
- MongoDB credentials belong only in the backend environment; never put them in the Flutter app.
- Facility finder, DC rate lists, permits, foreigner toolkit, digital pass, complaints,
  and differentiator features are planned, not yet implemented.

## Running the backend

```bash
cd backend
cp .env.example .env      # fill in MONGO_URI and JWT_SECRET (never commit .env)
npm install
npm run dev
```

Health check: `GET /api/health`

Seeding Punjab data (run against your dev database only):

```bash
node scripts/seedPunjabCitiesData.js
node scripts/seedAllPunjabPlacesAndEvents.js
```

## Running the mobile app

```bash
cd mobile
flutter pub get
flutter run
```

Static analysis and tests:

```bash
flutter analyze
flutter test
```

## Security notes

- Rotate any credentials that were ever committed; removing them from the latest source does not erase Git history.
- Never commit `.env` files or API keys. Root `.gitignore` excludes them.
- The mobile app must never contain database credentials or server secrets.
- Location is shared only after explicit user action.
- Identity data (CNIC/passport) requires consent, encryption, and a retention policy.
