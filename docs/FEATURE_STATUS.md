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
| Splash screen | `features/splash/` | Implemented | Not yet redesigned to brand identity |
| Onboarding | `features/onboarding/` | Implemented | Not yet reviewed for brand/accessibility |
| Auth (register/login, JWT, RBAC) | `features/auth/`, `backend/` | Implemented | No automated auth tests |
| English/Urdu localization | `core/localization/app_language.dart` | In progress | Interface-wide switching incomplete; RTL unverified |
| Bottom navigation | `features/home/screens/home_screen.dart` | Implemented | Home/Explore/Helpline/Pass structure to be consolidated |
| Dark mode | `core/theme/` | Implemented | Being folded into new design system |

## 2. Directory and discovery

| Feature | Location | Status | Notes |
|---|---|---|---|
| 81-city Punjab dataset | `core/data/punjab_81_cities_data.dart` | Implemented | Data integrity audit pending (Phase 3) |
| All Cities screen | `features/places/screens/city_explorer_screen.dart` | Implemented | Journey test pending |
| City guide / city-specific attractions | `features/places/screens/city_guide_screen.dart` | Implemented | Category mapping audit pending |
| Place details | `features/places/screens/place_details_screen.dart` | Implemented | Journey test pending |
| Search and filters | `features/search/` | Implemented | Journey test pending |
| Saved places / favorites | `features/favorites/` | Implemented | Test pending |
| Reviews and media submissions | `features/reviews/` | Implemented | Moderation/back-end path to review |
| Events | `features/events/` | Implemented | Test pending |
| Business registration / my businesses | `features/business/` | Implemented | Verification status workflow to audit |
| Map screen | `features/map/` | Implemented | API key + permission handling unverified |
| Directions | `features/directions/` | Implemented | Depends on external API; document dependency |
| AI assistant | `features/ai/`, `/api/ai` | Implemented | Grounding and honest-failure handling in progress |

## 3. Trips and money tools

| Feature | Location | Status | Notes |
|---|---|---|---|
| Trip planner / my trips / details | `features/trips/` | Implemented | Test pending |
| Budget calculator | `features/trips/screens/budget_calculator_screen.dart` | Implemented | Test pending |
| Group bill splitter | `features/trips/screens/group_bill_splitter_screen.dart` | Implemented | Test pending |
| Taxi fare estimator | place/trips screens (verify exact location) | Implemented | Must be labeled "estimate" |
| Local vs tourist price (anti-scam) | `features/places/screens/local_vs_tourist_price_screen.dart` | Implemented | Must carry source/verification status |
| Offline payment guide | `features/places/screens/offline_payment_guide_screen.dart` | Implemented | Content audit pending |
| Offline city packs | `features/places/screens/offline_city_packs_screen.dart` | Implemented | Cache expiry rules pending (Phase 6) |

## 4. Trust, safety, and honesty

| Feature | Location | Status | Notes |
|---|---|---|---|
| Road infrastructure alerts | `features/places/screens/road_infrastructure_alerts_screen.dart` | Implemented | Confirm data source honesty; no fake live data |
| CNIC verification screen | `features/places/screens/cnic_verification_screen.dart` | In progress | Privacy audit required: data minimization, consent, secure storage |
| Emergency contacts | backend `emergency` model/routes | Implemented | Numbers must be verified before display |
| SOS with SMS fallback | — | Not started | Phase 7 |
| Facility finder | — | Not started | Phase 7 |
| Travel reality check | — | Not started | Phase 7 |
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
| Facility Freshness Score | Not started |
| Tourist Truth Reports | Not started |
| Journey Readiness Score | Not started |
| Smart Stop Finder | Not started |
| Crowd Intelligence | Not started |
| Local Culture Companion | Not started |
| Lost and Found | Not started |
| Accessibility Explorer | Not started |
| Smart Trip Optimizer | Not started |
| Destination Change Alerts | Not started |

## 7. Engineering quality

| Item | Status | Notes |
|---|---|---|
| Design system (national identity, fonts) | In progress | Canonical tokens defined; implementation pending |
| Automated tests | In progress | Only smoke test exists; expansion is a roadmap requirement |
| Static analysis | In progress | Baseline run in Phase 1 |
| Offline cache honesty (live/cached/expired labels) | Not started | Phase 6 |
| Release signing / production applicationId | Not started | Currently debug signing + `com.example.smartmap_ai` |
| Security review (secrets, identity data) | In progress | `MONGO_URI` found in `mobile/.env` — must be removed |
| Accessibility audit | Not started | Phase 11 |
| Signed release APK | Not started | Phase 12 |
