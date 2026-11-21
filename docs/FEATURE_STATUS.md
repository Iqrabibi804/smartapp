# SMARTMAP PUNJAB — FEATURE STATUS MATRIX

**Last updated:** 2026-11-21
**Status vocabulary:** Not started · In progress · Implemented · Tested · Verified · Blocked

> "Implemented" means code exists but has not passed automated tests and manual journey verification.
> "Tested" means automated tests pass. "Verified" means the full user journey was checked with evidence
> recorded in `docs/TESTING_REPORT.md`.

## 1. Core platform

| Feature | Location | Status | Notes |
|---|---|---|---|
| Flutter app shell (Riverpod, theme modes) | `mobile/lib/main.dart` | Implemented | Single smoke test only |
| Splash screen | `features/splash/` | Implemented | Brand redesign done: national identity, logo, EN/UR, honest footer |
| Onboarding | `features/onboarding/` | Implemented | Not yet reviewed for brand/accessibility |
| Auth (register/login, JWT, RBAC) | `features/auth/`, `backend/` | Implemented | No automated auth tests |
| English/Urdu localization | `core/localization/app_language.dart` | In progress | Nastaliq font bundled; interface-wide switching and RTL mirroring still incomplete |
| Bottom navigation | `features/home/screens/home_screen.dart` | Implemented | Home/Explore/Helpline/Pass structure to be consolidated |
| Dark mode | `core/theme/` | Implemented | Being folded into new design system |

## 2. Directory and discovery

| Feature | Location | Status | Notes |
|---|---|---|---|
| 81-city Punjab dataset | `core/data/punjab_81_cities_data.dart` | Verified | Structural audit passed: 81 cities, 0 duplicates, all fields complete, HTTPS images (see `docs/DATA_AUDIT.md`) |
| All Cities screen | `features/places/screens/city_explorer_screen.dart` | Implemented | Journey test pending |
| City guide / city-specific attractions | `features/places/screens/city_guide_screen.dart` | Implemented | Compiles cleanly; dishonest verification copy removed; device journey pending |
| Place details | `features/places/screens/place_details_screen.dart` | Implemented | No silent wrong-place fallback; device journey pending |
| Search and filters | `features/search/` | Tested (offline path) | Offline filter/sort unit-tested; live API journey pending |
| Saved places / favorites | `features/favorites/` | Implemented | Test pending |
| Reviews and media submissions | `features/reviews/` | Implemented | Moderation/back-end path to review |
| Events | `features/events/` | Implemented | Test pending |
| Business registration / my businesses | `features/business/` | Implemented | Approval/revoke now writes `verificationStatus` + `lastVerifiedAt` |
| Map screen | `features/map/` | Implemented | API key + permission handling unverified |
| Directions | `features/directions/` | Implemented | Depends on external API; document dependency |
| AI assistant | `features/ai/`, `/api/ai` | Implemented | Grounding and honest-failure handling in progress |

## 3. Trips and money tools

| Feature | Location | Status | Notes |
|---|---|---|---|
| Trip planner / my trips / details | `features/trips/` | Implemented | Test pending |
| Budget calculator | `features/trips/screens/budget_calculator_screen.dart` | Implemented | Test pending |
| Group bill splitter | `features/trips/screens/group_bill_splitter_screen.dart` | Implemented | Test pending |
| Taxi fare estimator | place/trips screens (verify exact location) | Implemented | Must be labeled "estimate"; budget output now labelled planning estimates |
| Price fairness guide / DC rates | `features/places/screens/local_vs_tourist_price_screen.dart` | Tested | All fabricated rupee figures removed; DC rate lists report "information unavailable"; on-device report form |
| Offline payment guide | `features/places/screens/offline_payment_guide_screen.dart` | Implemented | Content audit pending |
| Offline city packs | `features/places/screens/offline_city_packs_screen.dart` | Implemented | Data cache has TTL rules; dedicated city-pack download UI still pending |

## 4. Trust, safety, and honesty

| Feature | Location | Status | Notes |
|---|---|---|---|
| Road advisories | `features/places/screens/road_infrastructure_alerts_screen.dart` | Tested | Sourced reference guidance; statuses report "information unavailable"; no fake live timestamps |
| CNIC verification screen | `features/places/screens/cnic_verification_screen.dart` | In progress | Privacy audit required: data minimization, consent, secure storage |
| Emergency contacts | backend `emergency` model/routes | Implemented | Numbers must be verified before display |
| SOS with SMS fallback | — | Not started | Phase 9 |
| Facility finder | `features/places/screens/facility_finder_screen.dart` | Implemented | Directory filters with verification labels and honest empty states |
| Travel reality check | place details card | Implemented | Explicit "not live" disclosure with authority guidance |
| DC official rate lists | — | Not started | Phase 7 (verified documents only) |
| Overcharging / misleading listing reports | partial (local-vs-tourist screen) | In progress | Structured reporting flow pending |

## 5. Planned service modules

| Feature | Status | Notes |
|---|---|---|
| Permit / NOC guidance workflow | Not started | Guidance-only unless official API exists |
| Digital tourist pass | Not started | Must be clearly labeled app-generated |
| Foreign tourist toolkit (PTA, currency, embassies) | Not started | Verify PTA rules before content |
| Complaints tracking | Not started | Local workflow, labeled non-official |
| Highway essential stops finder | Not started | Includes mosques/prayer times/Qibla |
| Women & family travel mode | Not started | No absolute safety claims |
| Admin web dashboard | Not started | In-app admin screens exist and are preferred for now |

## 6. Differentiators (Section 5.O)

| Feature | Status |
|---|---|
| Facility Freshness Score | Implemented (dates) | Last-verification date shown; score needs a real verification feed |
| Tourist Truth Reports | Not started | Needs moderated backend (Phase 9) |
| Journey Readiness Score | Tested | Persisted 6-section checklist; honest score disclaimer |
| Smart Stop Finder | Not started | Deferred: needs geospatial corridor data |
| Crowd Intelligence | Not started | Deferred: no reliable crowd data source |
| Local Culture Companion | Tested | General etiquette + phrases with variation disclaimer |
| Lost and Found | Not started | Needs moderated backend (Phase 9) |
| Accessibility Explorer | Not started | Deferred: dataset lacks accessibility attributes |
| Smart Trip Optimizer | Not started | Deferred: depends on live route/facility data |
| Destination Change Alerts | Not started | Deferred: needs verified change feed + notifications |

## 7. Engineering quality

| Item | Status | Notes |
|---|---|---|
| Design system (national identity, fonts) | Implemented | Tokens, single light/dark theme, bundled Poppins/Roboto/Nastaliq, original logo — see `docs/DESIGN_SYSTEM.md` |
| Automated tests | In progress | 16 tests pass (splash smoke + 6 offline filter + 4 cache + 3 advisory + 2 content tests); broad coverage still required |
| Static analysis | Verified | 0 errors, 0 warnings (18 pre-existing info hints) |
| Data verification model | Implemented | `verificationStatus`/`source`/`lastVerifiedAt` in schema, API filter, seeds, and Flutter model |
| Category taxonomy | Implemented | 11 canonical categories from `backend/config/categories.js`; content gaps for Fast Food / Adventure / Family Attractions |
| Offline cache honesty (live/cached/expired labels) | Tested | Hive TTL cache + freshness states + offline banner; unit-tested; connectivity auto-refresh pending |
| Release signing / production applicationId | Not started | Currently debug signing + `com.example.smartmap_ai` |
| Security review (secrets, identity data) | In progress | `MONGO_URI` found in `mobile/.env` — must be removed |
| Accessibility audit | Not started | Phase 11 |
| Signed release APK | Not started | Phase 12 |
