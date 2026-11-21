# SMARTMAP PUNJAB — API & EXTERNAL DEPENDENCIES

## 1. Mobile → backend

- **Base URL:** compile-time `--dart-define=API_BASE_URL`; default
  `http://10.0.2.2:5000/api` (Android emulator → host).
- **Client:** Dio with 3 s connect/receive timeouts, JWT bearer from
  `flutter_secure_storage`.
- **Auth:** `POST /auth/register`, `POST /auth/login`, `GET /auth/me`.
- **Places:** `GET /places` (+ filters, featured, nearby, by id),
  `POST/PUT/DELETE /places` (admin/moderator).
- **Categories:** `GET /categories`.
- **Reviews:** list/create/update/delete + helpfulness endpoints.
- **Favorites:** list/add/remove.
- **Custom lists:** list/create/add/remove/delete.
- **Trips:** create and manage.
- **Events:** list/featured/create.
- **Business:** submit listing; moderator approval queue
  (`GET`/`PUT /business/...`).
- **Emergency:** `GET /emergency/:city`.
- **Directions:** `GET /directions` (backend proxy).
- **AI:** `POST /ai` (rule-based; no external model).
- **Uploads:** image upload endpoint backed by local disk (`uploads/`).
- **Admin:** users, places, reviews, business, audit logs.

## 2. Backend → external services

| Dependency | Used for | Failure behaviour |
|---|---|---|
| MongoDB Atlas (`MONGO_URI`) | All persisted data | Server refuses to start without it |
| Public OSRM `router.project-osrm.org` | Driving/walking/cycling routes | Request fails; client reports routing unavailable |
| Local filesystem (`uploads/`) | User images | Upload error surfaced to client |

- No SMS gateway is connected: `POST /emergency/sos` returns **503** with a message to
  call emergency numbers directly.
- No exchange-rate API, weather API, road-status API or payments provider.
- `/api/ai` is deterministic keyword parsing over the project database — it needs no key
  and discloses no user data to third parties.

## 3. Mobile → external services

| Dependency | Used for | Notes |
|---|---|---|
| Google Maps SDK | Map display | API key currently declared in `AndroidManifest.xml`; restrict + rotate before store release |
| Unsplash image URLs | Illustrative place/city photos | Remote images; cached by Flutter's image cache, not by OfflineCache |
| Nothing else | — | Road status, rates, permits, embassies are not fetched |

## 4. Failure and honesty rules

- 3-second timeouts mean a missing backend degrades quickly to cached/bundled data.
- Any endpoint that would imply an external action (SOS, permit submission, complaint
  sending, exchange rates) either refuses or is absent; the UI states this.
- Road advisories never call an API; their status is `unavailable` by design.

## 5. Configuration for real devices

```
flutter build apk --release \
  --dart-define=API_BASE_URL=https://your-api.example.com/api
```

Backend environment (minimum):

```
PORT=5000
MONGO_URI=mongodb://...
JWT_SECRET=<32+ random characters>
CLIENT_ORIGIN=https://app-origin.example.com   # required when NODE_ENV=production
```
