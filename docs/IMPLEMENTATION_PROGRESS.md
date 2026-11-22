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
| 8 | Differentiating features | Tested | Journey Readiness checklist (persisted, honest score), Local Culture Companion, facility freshness dates; 16 tests green |
| 9 | Permits, foreigner toolkit, digital pass, complaints | Tested | Guidance-only permits; on-device pass; PTA/currency/embassy toolkit; local complaint records; 20 tests green |
| 10 | Backend, admin, security hardening | Tested | Secrets removed/fail-fast guards; RBAC retained; audit log + TTL; upload/CORS hardening; `docs/SECURITY_REVIEW.md` |
| 11 | Performance, compatibility, regression | Tested | Bounded image decoding; branding fixed on all platforms; analyze/tests/web release build green; device checks pending |
| 12 | Release signing and APK | Tested | `com.smartmappunjab.app` 1.0.0+1; v2-signed APK 57.9 MB; SHA-256 recorded; `docs/RELEASE_NOTES.md`; device install pending |

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
2. **Release configuration:** `applicationId` is `com.example.smartmap_ai` and release build uses the debug signing config. Both must be fixed before any release. (Phase 12 — resolved: `com.smartmappunjab.app`, keystore-backed release signing enforced at build time.)
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

1. Phase 12: release signing, APK, final documentation.

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

---

## Phase 8 log — 2026-11-21

Prioritised two differentiators with real, verifiable behaviour and deferred the rest:

- **Journey Readiness Score** (`features/trips/screens/journey_readiness_screen.dart`): six-section preparation checklist (documents, vehicle, health, connectivity, route/weather, money) persisted through `OfflineCache`. The score is computed only from the user's own ticks and the screen says SmartMap does not verify weather, road, vehicle or document conditions. Reset control included.
- **Local Culture Companion** (`features/places/screens/culture_companion_screen.dart`): general etiquette guidance and useful Urdu phrases, with a plain statement that customs vary and the content is compiled from widely published traveller guidance.
- **Facility freshness**: facility cards now show the recorded last-verification date, or state "verification date not recorded" instead of implying freshness.
- Home gains two honest entries ("Journey Readiness / Checklist", "Local Culture / General tips").

Deferred with reasons: **Facility Freshness Score** (needs a verified facility-verification feed, not just labels), **Tourist Truth Reports** and **Lost and Found** (need a moderated backend — planned with complaints in Phase 9), **Smart Stop Finder / Smart Trip Optimizer / Crowd Intelligence / Destination Change Alerts** (need live or geospatial data and notification infrastructure that does not exist yet), **Accessibility Explorer** (dataset lacks reliable accessibility attributes).

Verification: `flutter test` 16/16 pass; `flutter analyze` 0 errors / 0 warnings.

---

## Phase 9 log — 2026-11-21

All four workflows are guidance-first and clearly non-official:

- **Permits & NOC** (`permits_screen.dart`): destination and nationality selection, preparation steps, explicit statement that no permit office is connected, no submission/approval/tracking, and "Fee and processing time: information unavailable". Status tracking is described but not faked.
- **Foreign visitor toolkit** (`foreigner_toolkit_screen.dart`): PTA temporary-registration steps with no hardcoded duration (links to `pta.gov.pk`); an offline currency converter that only uses a rate the traveller enters, labelled as not live; embassy section reports contact information unavailable and links to `mofa.gov.pk` rather than inventing addresses or numbers.
- **Digital tourist pass** (`digital_tourist_pass_screen.dart`): consent-gated, app-generated ID stored on-device via `OfflineCache`, prominent "not a government credential" labelling, optional blood group, display validity, delete control. No QR code is claimed; the screen states it is not included in this build.
- **Complaints** (`complaints_screen.dart`): eight categories, location and description, saved on-device with a reference number and status "Saved on device — not submitted"; photo attachments disclosed as unavailable; link to the official Pakistan Citizen Portal. Home tile now opens this screen instead of directly leaving the app.

Verification: `flutter test` 20/20 pass (added permit/toolkit/complaint content tests, including checks that no unverified 120-day PTA limit is hardcoded). `flutter analyze`: 0 errors / 0 warnings.

Open items: no official submission, tracking or QR integration exists; documents/attachments need secure storage before they can be accepted; SOS SMS fallback remains Phase 10+ (requires platform permission testing).

---

## Phase 10 log — 2026-11-21

Full findings in `docs/SECURITY_REVIEW.md`.

- **Secrets:** cleared server credentials from `mobile/.env`; replaced the live Atlas URI in `backend/.env.example` with a local placeholder. The exposed Atlas credential remains in Git history and must be rotated. JWT secret now required to be at least 32 characters at startup.
- **Startup guards:** server refuses to start without `MONGO_URI`, without a strong `JWT_SECRET`, or in production without `CLIENT_ORIGIN`.
- **Audit trail:** new `AuditLog` model (365-day TTL) and `recordAudit` helper; user status changes, review moderation, place update/delete and business verification now write audit entries. Admins can read the latest 200 entries at `GET /api/admin/audit-logs`.
- **Transport/upload hardening:** `x-powered-by` disabled; static uploads deny dotfiles and directory indexes; upload endpoint remains authenticated with MIME/extension allow-list and a 5 MB limit.
- **RBAC:** unchanged and verified — admin router applies `protect, authorize('admin')`; business status changes require admin; registration cannot assign roles.
- **Privacy:** local-only features continue to stay on-device; no identity document upload exists (safe default until encryption/retention is implemented).

Verification: `node --check` passes on every changed backend file; `flutter analyze` 0 errors / 0 warnings; `flutter test` 20/20.

Open items: rotate the exposed Atlas credential; restrict/rotate the Maps API key; email verification and admin MFA; upload scanning/quota; CNIC privacy audit.

---

## Phase 11 log — 2026-11-21

- **Performance:** bounded `cacheWidth` on the three home image surfaces and the place-details hero, avoiding full-resolution decodes of remote photos. Existing list virtualization and TTL cache retained.
- **Branding compatibility:** Android `android:label`, iOS `CFBundleDisplayName`/`CFBundleName`, the web `<title>`/meta title and `manifest.json` now say **SmartMap Punjab** (all previously `smartmap_ai`).
- **Regression:** `flutter analyze` 0 errors / 0 warnings; `flutter test` 20/20; `flutter build web --release` completed successfully; `node --check` clean on changed backend files.
- **Environment:** Flutter 3.47.0, Android SDK 36.1.0 present but licences not accepted; no Android device attached, so on-device journey verification is still outstanding.

Full results are recorded in `docs/TESTING_REPORT.md` section 5.

---

## Phase 12 log — 2026-11-22

- **Application identity:** Kotlin `MainActivity` moved to `com/smartmappunjab/app`, package `com.smartmappunjab.app`; `namespace` and `applicationId` updated; version `1.0.0+1`.
- **Signing:** keystore generated (`android/app/smartmap-release.jks`, alias `smartmap`), `android/key.properties` wired into Kotlin DSL signing config. Release builds fail with a clear Gradle error when `key.properties` is missing. Both files are gitignored — they must be backed up by the owner.
- **Build blockers resolved:** removed the unused `telephony` plugin (AGP 9 namespace failure); fixed the keystore `storeFile` path (module-relative `smartmap-release.jks`); moved Gradle home/temp to `D:\gradle-home` and `D:\build-tmp` because `C:` was full.
- **APK:** `app-release.apk` 57.9 MB, package `com.smartmappunjab.app`, version `1.0.0 (1)`, minSdk 24 / targetSdk 36, verified by `apksigner` with APK Signature Scheme v2. Certificate `CN=SmartMap Punjab ...`; APK SHA-256 `82c54bf49424e656cc2eda94192d6a0b9807d7e32df680513dd581e2daa3ee85`.
- **Honesty hardening:** all seeded ratings/review counts zeroed (UI shows "No reviews yet"); `/api/emergency/sos` now returns 503 instead of pretending an SOS was received.
- **Docs:** `docs/RELEASE_NOTES.md`, `docs/PRODUCT_REQUIREMENTS.md`, `docs/ARCHITECTURE.md`, `docs/DATA_SOURCES.md`, `docs/API_DEPENDENCIES.md`.

Verification: `flutter analyze` — no errors or warnings; `flutter test` 20/20; `apksigner verify` passes; `aapt dump badging` confirms package/version. No Android device was attached, so in-place APK installation is still pending.

Open items for store release: rotate the exposed Atlas credential; restrict/rotate the Maps key in `AndroidManifest.xml`; on-device smoke test; privacy policy URL; Urdu/RTL completion.

---

## Dashboard redesign log — 2026-11-22

- **Header:** glossy 3D emerald/gold crescent-star pin (`AppLogoMark3D`, custom painter with gradient fill, specular highlight and cast shadow) beside the SmartMap Punjab wordmark; EN / اردو pill toggle bound to `languageProvider`; compact red SOS pill opening an emergency modal (Rescue 1122, Police 15, Motorway 130, Tourist Help 1421 — dialer only, no dispatch).
- **Palette:** dashboard surface `#FAF8F5`, Royal Emerald `#0E5A36`, mustard gold `#D97706`, Multani blue `#1D4ED8`, warm card border, five pastel badge tints. Tokens added to `AppTokens`.
- **Search + categories + hero:** rounded search pill ("Search Lahore, Taxila, food, hotels...") routing to Search Results; five pastel circular categories (Cities, Heritage, Food, Stays, Medical); two-slide hero carousel (Taxila Gandhara UNESCO Site, Lahore Royal Heritage) with dark-to-emerald gradient, gold tag, gold `Explore →` button, 5-second auto-advance.
- **Traveler Essentials:** former "Smart Travel Assistant" and "Pakistan-First Tools" merged into one 2×3 grid of white bordered cards with flat 2D pastel icon tiles (Route Planner, Anti-Scam Rates, Offline City Packs, Budget Calculator, Bill Splitter, Road & Landslide Alerts), plus a "More tools" sheet. Urdu subtitles render only when the header toggle is set to اردو (English-only default).
- **Authentic imagery:** Popular Cities (Lahore Fort, Shah Rukn-e-Alam, Raja Bazaar, Noor Mahal) and Must-Visit Destinations (Badshahi Mosque, Derawar Fort, Shalimar Gardens, Dharmarajika Stupa, Murree Hills) now use nine bundled Wikimedia Commons photographs under `assets/images/landmarks/`; provenance recorded in `docs/DATA_SOURCES.md` §9.
- **Clean finish:** removed the long "How this app helps" text list; compact floating `AI Guide` pill bottom-right with 120 px list padding so it never covers card text.
- **Honesty:** SOS modal states calls open the dialer and the app does not dispatch help; Road & Landslide Alerts remain sourced advisories, not a live feed; footer keeps "Independent guide · Not affiliated with any government body."

Verification: `dart format` clean; `flutter analyze` 0 errors / 0 warnings (18 pre-existing infos); `flutter test` 20/20; headless-browser screenshots at 430 px width checked for header, hero, grid, photo cards and FAB (no overflow stripes).

---

## Master prompt port — 2026-11-22

Port of the "Airbnb + Google Maps + Rome2Rio" master brief into the Flutter app (not a new web build).

- **Tokens and type:** unified light canvas `#F8F9FA`, white cards, `#F1F5F9` input fill, `#E2E8F0` borders; Royal Emerald `#0E5A36` primary, amber `#D97706` secondary, crimson `#DC2626` limited to SOS/emergency; slate text ramp. Plus Jakarta Sans bundled (Regular/SemiBold/Bold) and set as heading + body; Noto Nastaliq Urdu retained.
- **Responsive shell:** one `HomeScreen` now owns a 64 px sticky header (offline dot, EN / اردو toggle, red SOS pill), a 250 px white sidebar at ≥1024 px (Explore, Routes, Budget, Hospitals, Bakeries, Saved/Offline, offline packs card) and a 4-tab bottom bar below that (Explore, Routes, Budget, Essentials). A 52 px emerald AI FAB opens a slide-over concierge sheet with suggested questions.
- **Home dashboard:** hero search pill, three compact Quick Travel Tools cards (route / budget / medical), destination filter pills (All, Historical, Hills, Spiritual, Family) and a 4:3 photo grid with heart bookmark, place line, LTR-isolated distance and season chip. No ratings or visitor counts are shown because none are verified.
- **Route planner:** rebuilt inside the shell. Three corridor presets carry approximate distance/drive time/highway; fuel, toll and public-fare rows say information unavailable with local-verification guidance; live road status is explicitly "No live feed" with NHA/NHMP references and the 2026-11-22 reference date. Only M-2 rest stops are listed and marked "verify on arrival".
- **Budget planner:** rebuilt inside the shell with destination, PKR slider, days/travellers steppers, travel-style tabs, transparent per-room/per-person-per-day assumptions, remaining-buffer bar, day-by-day highlights, softened money tips and a WhatsApp share text that labels everything as an estimate.
- **SOS + AI:** SOS dialog is centred, capped at 85 % viewport height, scroll-safe, with five helpline rows (1122, 1421, 15, 130, 1787) and an explicit dialer-only disclaimer. The AI sheet never claims live answers and tells users to verify official sources.
- **Directory touch-ups:** facility finder accents moved to the emerald token; the directory already used a light surface and keeps its "no live availability" warning.

Verification: `dart format` clean; `flutter analyze` 0 errors / 0 warnings (44 infos, all pre-existing style/deprecation notes); headless screenshots at 512 px and 1258 px checked for header, sidebar, quick tools, destination grid, route planner, budget planner, essentials, SOS dialog, AI sheet and Urdu RTL (font boxes appeared once during a cold load and disappeared on reload, confirming a transient asset-load delay rather than missing glyphs).
