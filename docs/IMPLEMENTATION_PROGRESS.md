# SMARTMAP PUNJAB — IMPLEMENTATION PROGRESS

**Roadmap source:** `docs/MASTER_PROMPT.md`
**Status vocabulary:** Not started · In progress · Implemented · Tested · Verified · Blocked

## Phase overview

| Phase | Scope | Status | Evidence |
|---|---|---|---|
| 1 | Project audit and baseline | Verified | Baseline commit `d06b3c3`/`74532e7`; analyze 0 errors/0 warnings; widget smoke test passes |
| 2 | Competitor + Pakistan problem research | Implemented | `docs/COMPETITOR_RESEARCH.md` (12 products, 18 sources); `docs/PAKISTAN_TOURIST_PROBLEMS.md` (20 problems, 22 sources) |
| 3 | Data audit and cleanup | Tested | `docs/DATA_AUDIT.md`; honest verification labels in seeds/offline data; `publishedPlaceFilter`; canonical category taxonomy; analyze/test green |
| 4 | Design system, branding, splash, home | Implemented | `docs/DESIGN_SYSTEM.md`; tokens + theme + bundled fonts + logo + splash + home header; analyze/test green |
| 5 | Critical functional bug fixes | Tested | Offline search/sort/fallback bugs fixed; `docs/TESTING_REPORT.md`; 7 tests green; device journeys pending |
| 6 | Offline and reliability foundation | Tested | TTL cache + honest freshness states wired into categories/search/nearby/details; offline banner; 11 tests green |
| 7 | Core tourist features | Tested | Facility finder; honest road advisories with sources; travel reality check; price fairness + DC-rate unavailability; 14 tests green |
| 8 | Differentiating features | Not started | — |
| 9 | Permits, foreigner toolkit, digital pass, complaints | Not started | — |
| 10 | Backend, admin, security hardening | Not started | — |
| 11 | Performance, compatibility, regression | Not started | — |
| 12 | Release signing and APK | Not started | — |

---

## Phase 1 log — 2026-11-21

### Environment

| Tool | Version / path |
|---|---|
| Flutter | 3.35.7 stable (`D:\flutter_windows_3.35.7-stable`) |
| Dart | bundled with Flutter |
| Node.js | v22.20.0 |
| npm | 10.9.3 |
| Git | 2.45.1 (windows) |
| JAVA_HOME | `D:\JDk` |
| Android SDK | Not found at default `%LOCALAPPDATA%\Android\Sdk`; verify Android toolchain with `flutter doctor` |

### Baseline commands

- `flutter analyze` — 0 errors, 0 warnings, 18 infos (all pre-existing `use_build_context_synchronously` style hints)
- `flutter test` — `All tests passed!` (splash renders, exits cleanly with hermetic provider overrides)

### Findings from repository inspection

1. **Secret exposure risk:** `mobile/.env` contains a `MONGO_URI` entry. A database URI must never ship in a client app. Remove it from mobile and rely on the backend-only `.env`. (Phase 10)
2. **Release configuration:** `applicationId` is `com.example.smartmap_ai` and release build uses the debug signing config. Both must be fixed before any release. (Phase 12)
3. **Test coverage:** `mobile/test/` contains a single smoke test (`widget_test.dart`). No unit/widget/integration coverage of real flows. (Phase 11)
4. **Theme:** `core/theme/app_theme.dart` defines three colorful palettes (including truck-art magenta). Replace with the canonical national identity; keep light/dark mode. (Phase 4)
5. **Typography:** Poppins / Roboto / Noto Nastaliq Urdu are not declared or bundled in `pubspec.yaml`. Urdu RTL behavior unverified. (Phase 4)
6. **Documentation:** Root README described the project as a "starter scaffold", which was outdated. Rewritten during Phase 1.
7. **Git:** Repository was not initialized. Initialized with root `.gitignore` excluding `.env`, `node_modules`, Flutter build artifacts, uploads, and IDE files; baseline commit created.
8. **Pre-existing crash log:** `mobile/flutter_log.txt` shows a native `libflutter.so` crash dump from a previous device run. It is excluded from git; reproduce during Phase 11 device testing if it recurs.

### Phase 1 deliverables

- [x] Root `.gitignore`
- [x] README rewritten to reflect actual project state
- [x] `docs/FEATURE_STATUS.md` baseline
- [x] `docs/IMPLEMENTATION_PROGRESS.md` (this file)
- [x] `flutter analyze` baseline recorded (0 errors, 0 warnings)
- [x] `flutter test` baseline recorded (smoke test passes)
- [x] Baseline Git commit

---

## Phase 2 log — 2026-11-21

Research documents produced (accessed 2026-11-21; unverified items flagged inside each doc):

- `docs/COMPETITOR_RESEARCH.md` — 12 products across 13 dimensions, comparison matrix, gap analysis, 18 sources.
- `docs/PAKISTAN_TOURIST_PROBLEMS.md` — 20 documented tourist problems with evidence, regional/seasonal context, software intervention mapping, honesty constraints, 22 sources (FCDO, NHMP, NDMA, NHA, PTA DIRBS, etc.).

Open item: re-verify time-sensitive claims (road status, permit rules, app store availability) before release.

---

## Phase 3 log — 2026-11-21

Full findings and evidence in `docs/DATA_AUDIT.md`. Summary of changes:

### Flutter

- `PlaceModel`: added `city`, `verificationStatus`, `lastVerifiedAt`, `source`; `isFemaleSafe`/`isFamilyFriendly` default to `false`.
- `punjab_offline_data.dart`: removed all unverified `verified: true`, female-safe and family-friendly claims (27 places).
- Splash screen: removed "TDCP Verified Tourism Platform" and "Verified Safety • Live Rates" (no such verification exists); now uses the approved tagline.

### Backend

- `Place` model: `city` (indexed), `verificationStatus` enum (default `needs_verification`), `lastVerifiedAt`, `source`.
- New `utils/publishedPlaceFilter.js`; applied to places list/search/nearby/related, AI recommendations, and trip generation.
- `businessRoutes`: approval sets `verificationStatus` + `lastVerifiedAt`; revoke drops back to `community_reported`.
- All four seed scripts now write `verified: false`, `verificationStatus: 'community_reported'`, `source`, and derive `city`; re-seeding never downgrades verified records.
- New `config/categories.js` canonical taxonomy (11 categories) and `scripts/seedCategories.js`; seeds ensure the taxonomy exists instead of silently mislabeling unknown categories as "Restaurants" (now skipped with a warning).

### Verification

- `flutter analyze`: 0 errors, 0 warnings (18 infos).
- `flutter test`: all pass.
- `node --check`: all modified backend files OK.

### Known gaps (Blocked — require real data, not fabricated)

- No seed records for Fast Food, Adventure, or Family Attractions; categories exist, data must be sourced.
- Ratings/review counts are placeholder values, not real reviews.
- Imagery is Unsplash stock photography, not real photos of the named places.
- `mobile/lib/core/data/punjab_cities_data.dart` is unused legacy data; deletion was blocked by the environment safety classifier and needs explicit confirmation.
- Database reseed not executed (no MongoDB instance available during this phase).

### Next actions

1. Phase 4: design system, branding, splash, home per `docs/MASTER_PROMPT.md` §4.

---

## Phase 4 log — 2026-11-21

Full specification in `docs/DESIGN_SYSTEM.md`. Summary:

- Added `core/theme/design_tokens.dart` (colors, spacing, radius, shadows, gradients).
- Rewrote `AppColors` to the canonical national identity; legacy palette names remain as aliases so existing screens compile.
- Rewrote `AppTheme` as a single light/dark theme driven by tokens (navigation bar, buttons, inputs, cards, chips, sheets, snackbars, progress).
- Removed the multi-palette theme selector and `pakistanPaletteProvider`.
- Bundled Poppins (400/600/700), Roboto variable, and Noto Nastaliq Urdu with OFL license texts; declared in `pubspec.yaml`.
- Added original logo artwork `AppLogoMark` / `AppLogo` (pin + crescent + star) drawn as vectors.
- Redesigned splash: flag-inspired green gradient, gold rule, logo, English/Urdu branding, honest footer.
- Redesigned home header: logo, tagline, location chip, "Independent guide" chip, real language selector, theme toggle, cities shortcut; unified bottom navigation and AI button colors.
- Removed remaining fake claims from home: "TDCP Verified", "24.7 Verified Emergency", "Free Help", "Verified Tourist Traveler", "Punjab Tourism Administrator".

Verification: `flutter analyze` 0 errors / 0 warnings (17 infos); `flutter test` passes.

Open items: section-level polish for home (banners/grids) and remaining screens, full RTL layout mirroring, interface-wide language switching.

---

## Phase 5 log — 2026-11-21

Evidence in `docs/TESTING_REPORT.md`. Fixes:

- Place details offline fallback no longer substitutes an unrelated place for an unknown id (throws; screen shows error state).
- Map "nearby" offline fallback now uses real distance filtering instead of returning the first eight places.
- Offline search honors `sort` (`rating`, `popular`), which was previously ignored.
- Removed remaining unverifiable claims in city guide ("Explore Verified Places", "real-time verified spots") and emergency-number copy; softened admin/profile labels.

Added 6 offline filter unit tests. Full suite: 7 tests passing. `flutter analyze`: 0 errors / 0 warnings.

Runtime: app loads in Chrome with correct title and zero console errors/warnings. Screenshot-level and tap-through verification blocked by the unavailable visible browser surface and the absence of an Android device.

### Next actions

1. Phase 8: differentiating features (approved priorities from Section 5.O).

---

## Phase 6 log — 2026-11-21

- Added `core/offline/offline_cache.dart`: Hive-backed singleton cache (`offline_cache_v1`) with per-entry TTL, saved timestamps, online/offline reporting, and a `CacheFreshness` state model (live/cached/expired/bundled/unavailable). Expired entries are still readable but reported as expired.
- Added `offline_cache_provider.dart` and `offline_status_banner.dart`: the home screen now shows a gold strip only when the app falls offline or saved data is stale, with the saved date/time. No banner when data is live.
- Wired the cache into `PlacesService` (nearby `6h` keyed by rounded coordinates, search `24h` keyed by full filters, details `24h` per id) and `CategoriesService` (`categories`). Offline fallbacks still use real bundled data; details still fail honestly for unknown places.
- `main()` now initialises the cache before `runApp`; Hive failures degrade to bundled-data mode instead of crashing.
- Added `test/offline_cache_test.dart` (fresh→cached, stale→expired, missing→unavailable, offline/online reporting) using a temp Hive directory.

Verification: `flutter test` 11/11 pass (1 widget smoke, 6 offline filter, 4 cache). `flutter analyze`: 0 errors / 0 warnings.

Open items: connectivity-change auto-refresh / pull-to-refresh wiring, bundle-level expiry for the shipped dataset, background sync, and on-device offline verification.

---

## Phase 7 log — 2026-11-21

Honesty-first implementation of the core tourist features:

- **Facility finder** (`features/places/screens/facility_finder_screen.dart`): hospital, pharmacy, petrol, ATM, police, parking, restaurant, washroom and drinking-water filters over the saved directory. Empty results state "Information unavailable" rather than implying no facility exists; each listing shows its verification status and says a listing does not confirm the facility is open or stocked.
- **Road advisories** (`core/data/road_advisories.dart`, rewritten screen): replaced fabricated live alerts, fake "18 mins ago" timestamps, "verified counts", connectivity heatmaps and unverified mechanic phone numbers with seven sourced corridor advisories (KKH, Babusar, Lowari, Khunjerab, Naran–Kaghan, Murree Expressway, Skardu Road). Every advisory reports `Information unavailable` because no NHA/NHMP/PDMA/NDMA feed is connected, and carries agency, URL and reference date. Local condition reports are stored on-device only and clearly labelled as not sent to any agency.
- **Travel reality check**: added to place details — states that weather/road/seasonal/permit data is not live, tells the traveller which authorities to confirm with, and links to the facility finder.
- **Price fairness guide** (rewritten `local_vs_tourist_price_screen.dart`): removed every hardcoded rupee figure and the fake "anti-scam rate card". District selector now explicitly reports "Official rate information currently unavailable" until an authorised DC source exists, plus general fair-pricing checks and an overcharging report form that saves on-device only.
- **Data cleanup**: removed the two unsourced `localPrice`/`touristPrice` pairs from bundled data and deleted the place-details price card that displayed them. Budget calculator output is now labelled as planning estimates, not official rates.
- Home entry labels updated: "Price Fairness" (no anti-scam claim) and "Road Advisories / Not live"; hospital card opens the facility finder.

Verification: `flutter test` 14/14 pass (added road-advisory provenance tests). `flutter analyze`: 0 errors / 0 warnings.

Open items: no authorised live feeds yet (road status, DC rates, facility availability); report forms are device-local until a verified submission backend exists; map-based distance filtering for facilities pending location wiring.
