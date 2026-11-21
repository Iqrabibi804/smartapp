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

- Test coverage is currently a single smoke test.
- Urdu localization exists in code but interface switching is incomplete.
- Bundled fonts (Poppins / Roboto / Noto Nastaliq Urdu) are not yet declared.
- Legacy multi-palette theme is being replaced by the canonical national identity.
- `applicationId` is still `com.example.smartmap_ai`; release signing is not configured.
- A `MONGO_URI` entry exists in `mobile/.env` and must never ship with the app.
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

- Never commit `.env` files or API keys. Root `.gitignore` excludes them.
- The mobile app must never contain database credentials or server secrets.
- Location is shared only after explicit user action.
- Identity data (CNIC/passport) requires consent, encryption, and a retention policy.
