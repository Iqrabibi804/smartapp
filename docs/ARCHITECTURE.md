# SMARTMAP PUNJAB — ARCHITECTURE (v1.0)

## 1. Shape

```
Flutter app (Android / iOS / Web)
  lib/
    main.dart, app.dart            MaterialApp, theme, language state
    core/
      constants/                   tokens, API constants
      theme/                       AppTokens, AppRadius, typography
      localization/                EN/UR strings, language controller
      data/                        bundled datasets (81 cities, 27 places,
                                   categories, road advisories)
      offline/                     Hive TTL cache, freshness states, banner
      services/                    ApiClient (Dio + secure token),
                                   connectivity, location
      widgets/                     shared UI (empty/error/loading states)
    features/                      feature-first screens and providers
      splash, onboarding, home, places, categories, search, map,
      directions, trips, reviews, favorites, events, business, auth,
      ai, admin

Node/Express API (backend/)
  server.js                        startup guards, CORS, static uploads
  routes/                          auth, places, categories, reviews,
                                   business, favorites, trips, events,
                                   directions, ai, uploads, admin, emergency
  models/                          Mongoose schemas + AuditLog
  middleware/                      JWT auth, RBAC, uploads
  utils/audit.js                   recordAudit()

MongoDB Atlas (place/review/user/business/trip data)
```

## 2. Mobile layers

- **Presentation** — screens under `lib/features/*/screens`; state via Riverpod
  (`StateNotifierProvider`, `FutureProvider.family`, `Provider`).
- **Domain/data** — feature services call `ApiClient` (Dio) for remote data or
  read bundled constants under `lib/core/data`.
- **Persistence** — `OfflineCache` (Hive, TTL) for list/detail caching; JWT in
  `flutter_secure_storage`; user-generated on-device records (readiness,
  digital pass, complaints, road reports) in Hive only.
- **Cross-cutting** — `AppTokens` design tokens; `connectivity_plus` for
  online/offline transitions; `OfflineStatusBanner` for freshness.

## 3. Data honesty model

- Every place has `verificationStatus` ∈ {verified, community_reported,
  needs_verification, unavailable}; UI only shows a verified badge when the
  record says `verified`.
- Road advisories are compiled guidance with source agency URLs and a reference
  date; status defaults to `RoadStatus.unavailable` until a live feed exists.
- Official rates, embassy contacts and processing times render "Information
  unavailable" instead of invented values.
- Completing a journey checklist, generating a digital pass or saving a
  complaint never leaves the device; each screen states this.

## 4. Offline strategy

1. Read from `OfflineCache` keyed by request; serve fresh entries directly.
2. On miss/expiry, fetch from API with short timeouts (3 s connect/receive).
3. On failure, serve the stale entry and mark it stale, or fall back to bundled
   `punjab_offline_data.dart`; otherwise show an explicit error state.
4. Banner communicates Live/Cached/Expired/Unavailable — never silently pretends.

## 5. Backend

- Auth: bcrypt-hashed passwords, JWT bearer, role claims (`user`, `moderator`,
  `admin`).
- RBAC middleware guards admin/moderation endpoints.
- Audit: mutating admin/business actions append to `AuditLog` (1-year TTL).
- Hardening: helmet, rate limits, mongo-sanitize, JSON body caps, upload type
  allow-list and size cap, `x-powered-by` disabled, production CORS allow-list,
  startup refusal without `MONGO_URI` or a 32+ char `JWT_SECRET`.
- AI: `/api/ai` performs rule-based intent/keyword parsing over project data —
  no external AI provider, no key required.
- Directions: proxy to public OSRM; if unreachable the client reports that
  routing is unavailable rather than estimating.

## 6. Build and configuration

- API base URL: compile-time `--dart-define=API_BASE_URL=...`; default
  `http://10.0.2.2:5000/api` (Android emulator).
- Brand fonts bundled: Poppins, Roboto, Noto Nastaliq Urdu.
- Release signing: `android/key.properties` + keystore (both gitignored);
  release build fails loudly if the properties file is missing.
- Application ID: `com.smartmappunjab.app`; version `1.0.0+1`.

## 7. Known architectural gaps

- Urdu switching currently covers splash/onboarding/home/navigation labels; not
  every screen is localized, and RTL mirroring is not complete.
- Ratings/review counts in bundled data are placeholders until real reviews
  exist; this is documented in `docs/DATA_SOURCES.md`.
- No push notifications, payments or live government integrations.
