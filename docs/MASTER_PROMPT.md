# SMARTMAP PUNJAB — MASTER TRANSFORMATION PROMPT (v1.0)

> **What this document is:** One consolidated, non-conflicting implementation directive for the SmartMap Punjab project at `D:\smartapp`. It merges two earlier prompt drafts ("SmartMap Punjab — Master Product Transformation & Implementation Directive" and "Salam Pakistan — Complete Production-Ready Flutter Application") into a single authoritative brief, rewritten against the **actual state of the repository** as audited on 2026-11-21.
>
> **How to use it:** Give this entire document to a coding agent (Qoder, Antigravity, Claude Code, etc.) and tell it to begin at **Phase 1**. Work phase by phase. Do not skip research and audits. Do not claim completion without evidence.

---

## 0. RESOLVED DECISIONS (conflicts between the two source prompts)

| Conflict | Decision |
|---|---|
| App name | **SmartMap Punjab** (not "Salam Pakistan") |
| Tagline | **"Explore Punjab. Travel with Confidence."** |
| Gold accent | **#C5A66A** (muted heritage gold) |
| Scaffold background | **#F4F6F2** (soft neutral green-tinted background) |
| Brand posture | Independent tourism platform. **Never** claim government ownership, approval, or affiliation. **Never** copy official emblems, seals, or ministry logos. |
| Permits / NOC | Guidance + application-preparation workflow only, unless an authorized official API is integrated. Locally generated references must **never** look like official permits. |
| DC official rates | Only from verified, published source documents. Otherwise show "Official rate information currently unavailable." **Never fabricate rates.** |
| Complaints | Local in-app tracking workflow, clearly labeled as **not** an official government submission unless an approved integration exists. |
| Scope | Punjab-first (the repository's 81-city Punjab dataset and brand), designed so other provinces can be added later without rework. |
| Platform | Keep Flutter + Riverpod + Node/Express + MongoDB. Do not migrate frameworks. |
| Skills location | Project skills under `.agents/skills/` if the agent environment supports them; otherwise document them in `docs/`. |

---

## 1. ROLE

Act as a multidisciplinary senior team responsible for shipping a commercially usable tourism product:

1. Senior Flutter & Dart Architect
2. Senior Mobile UI/UX Designer
3. Tourism Product Researcher
4. Travel Technology Specialist
5. MongoDB & Backend Engineer
6. GIS and Geospatial Engineer
7. AI Integration Engineer
8. QA Automation Engineer
9. Android Release Engineer
10. Security and Privacy Engineer
11. Accessibility Specialist

Do not behave like a code generator. Think like a product team delivering a trustworthy tourism application.

---

## 2. CURRENT PROJECT STATE (grounded — verify before trusting)

Repository root: `D:\smartapp`

```
smartapp/
├── mobile/               Flutter app (Android-first). Riverpod, Dio, Hive,
│                         flutter_secure_storage, google_maps_flutter, geolocator,
│                         connectivity_plus, image_picker, url_launcher.
│   ├── lib/core/         constants, theme (+ theme_provider with 3 palettes),
│   │                     localization (app_language), services (api_client,
│   │                     connectivity, location), data (punjab_81_cities_data,
│   │                     punjab_cities_data, punjab_offline_data)
│   ├── lib/features/     admin, ai, auth, business, categories, directions,
│   │                     events, favorites, home, map, onboarding, places,
│   │                     reviews, search, splash, trips
│   ├── test/             single smoke test (widget_test.dart) — effectively no coverage
│   └── android/          applicationId = com.example.smartmap_ai (MUST change before release)
├── backend/              Node/Express/MongoDB API
│   ├── models/           User, Place, Business, Category, CustomList, Event,
│   │                     Review, SavedPlace, Trip, emergency
│   ├── routes/           auth, places, categories, reviews, favorites, ai, trips,
│   │                     events, businesses, admin, emergency, upload, directions, lists
│   ├── scripts/          seed scripts for Punjab cities/places/events
│   └── server.js         helmet, cors, rate limit, mongo-sanitize wired
└── admin-dashboard/      placeholder only (README, no app)
```

**Features that already exist and must be preserved (inspect each before touching):**

- 81-city Punjab guide and city data (`core/data/punjab_81_cities_data.dart`)
- City explorer / city guide screens; place details
- Trip planner, my trips, trip details
- Budget calculator
- Group bill splitter
- Taxi fare estimation and local-vs-tourist price screen (anti-scam)
- Offline payment guide
- Offline city packs screen
- Saved places / favorites
- Search and filters
- Reviews and media submissions
- Events
- Business registration / my businesses
- AI screen (`features/ai/`, backend `/api/ai`)
- Directions screen
- Road infrastructure alerts screen (static/community — verify data honesty)
- CNIC verification screen — **privacy audit required** (data minimization, consent, secure storage, or removal)
- Admin screens inside the mobile app (users, places, businesses, reviews)
- Auth (register/login, JWT, RBAC), theme with light/dark mode
- Backend seed scripts for Punjab data

**Known gaps / issues to confirm during Phase 1:**

- README claims the repo is only a "starter scaffold" — outdated; rewrite it to reflect reality.
- Test suite is a single smoke test; no unit/widget/integration coverage of real flows.
- Fonts (Poppins / Roboto / Noto Nastaliq Urdu) are not bundled in `pubspec.yaml`.
- Theme includes three colorful palettes (including "truck art" magenta) — replace with the single national identity in Section 6; keep dark mode.
- `applicationId` is `com.example.smartmap_ai` — placeholder, must be replaced and signed properly.
- No `docs/` directory yet; this file starts it.
- Verify category mappings, city associations, coordinates, image URLs, and duplicates in seeded data (Phase 3).
- Verify emergency phone numbers (1422, 1122, 130, 1700) are current, regionally valid, and correctly described.

---

## 3. NON-NEGOTIABLE RULES

1. **Honesty over polish.** Never fake live APIs, government approvals, permits, official rates, identity verification, complaint delivery, or SMS delivery. If a dependency is unavailable: implement a clearly labeled functional alternative and document the dependency.
2. **No fabricated data.** Missing data is shown as "Information unavailable" — never invented.
3. **Preserve working features.** Do not replace working functionality with dummy screens. Do not delete features to simplify implementation. Inspect first, then change.
4. **Data provenance.** Every dynamic fact (rate, alert, weather, facility status) carries a source, timestamp, and verification status. Estimated prices are labeled as estimates, cached data as cached, expired data as expired.
5. **Security and privacy.** No secrets in client code. CNIC/passport data encrypted in transit and at rest, collected only with explicit consent and only when genuinely necessary. Location is never transmitted silently.
6. **Accessibility.** Accessible touch targets, screen-reader labels, dynamic text size, RTL support.
7. **Evidence-based completion.** A feature is "Verified" only after static analysis, tests, and manual user-journey checks. No success claims without evidence.
8. **Controlled change.** Separate Git commits per logical milestone. Maintain `docs/IMPLEMENTATION_PROGRESS.md` and `docs/FEATURE_STATUS.md` with statuses: Not started / In progress / Implemented / Tested / Verified / Blocked.
9. **Coordination.** Parallel subagents may research or work on independent modules, but never allow two agents to modify the same files concurrently. Review subagent output before merging.

---

## 4. PHASE 1 — RESEARCH (two documents, with sources and dates)

### 4.1 Competitor research → `docs/COMPETITOR_RESEARCH.md`

Research at least: Google Maps, Tripadvisor, Wanderlog, Rome2Rio, Visit A City, Sygic Travel, Punjab Tourism Pakistan (official portals), Pakrism, other Pakistan tourism apps, relevant official tourism websites.

For each: features, destination discovery, maps/navigation, trip planning, hotels/restaurants, reviews/UGC, offline mode, transport, safety/emergency, AI capabilities, accessibility, UX, limitations.

Produce a comparison matrix separating:
- Features present in many apps
- Features present in only some apps
- Features missing from SmartMap Punjab
- Features solving Pakistan-specific problems
- Candidate differentiators

Do not invent competitor capabilities. Cite source URLs and research dates.

### 4.2 Pakistan tourist problems → `docs/PAKISTAN_TOURIST_PROBLEMS.md`

Research real challenges: unreliable road information, landslides/closures, road conditions, network coverage gaps, hotel availability/pricing reliability, taxi overcharging, missing tourist information, washrooms, drinking water, medical facilities, fuel availability, women's travel safety, family facilities, seasonal accessibility, foreign-tourist NOC/permits, language barriers, emergency assistance, local transport info, misleading business info, untrustworthy reviews.

Use official portals, government initiatives, travel advisories, credible reports. Map each problem to a software-solvable intervention, with feasibility notes.

---

## 5. PRODUCT SCOPE (consolidated feature set)

### A. Core tourism directory
All Cities, city selection, and every category must work with correct filtering and relevant results: historical attractions, religious attractions, natural attractions, adventure, family attractions, restaurants, bakeries/cakes, fast food, hotels/accommodation, shopping/local markets. Every city and destination opens a functional detail page.

### B. Smart facility finder (location-based)
Public washrooms, clean drinking water, hospitals, pharmacies, petrol pumps, parking, ATMs, restaurants, family-friendly facilities, accessible facilities, police stations, emergency services. Filters by distance/type. Show location, contact, availability (only when verified), last verification date. Never mark unverified facilities as verified.

### C. Travel reality check + road intelligence
Per destination: weather, road status, closures, landslide warnings, seasonal accessibility, travel restrictions, permit/NOC guidance, estimated journey time, fuel stops, alternative routes — with source and timestamp.

Road alert module for KKH, Babusar Top, Lowari Tunnel, Khunjerab Pass and other tourist roads. Statuses: Open / Closed / Restricted / Landslide reported / Weather warning / Information unavailable. Each alert: description, affected route, source agency, publication time, last updated, validity if supplied, verified alternative routes. Integrate official sources (NHA, NHMP, PDMA, NDMA) only where legally accessible and authorized. If live data is unavailable, show latest verified cached information clearly labeled with its age. Push notifications where supported.

### D. Trust and price transparency
- Taxi fare estimates (labeled as estimates)
- Overcharging reports
- Hotel price comparison only where real data exists
- Business verification status
- Ratings and recent reviews
- Price discrepancy reporting
- Misleading-listing reporting

### E. DC official rate lists
District-wise rates: 4x4 jeep rentals, hotels, guest houses, entry tickets, chairlift tickets, local transport, other officially published tourist services (e.g., Saif-ul-Mulook, Fairy Meadows, Deosai). Each entry: district, category, official rate, unit, effective date, publishing authority, source document, last updated. Filters by district/service. REPORT OVERCHARGING form (vendor, location, category, official rate, charged rate, date, photo/receipt, description, review-before-submit). Admins can upload/update verified rate documents. If no verified list exists: "Official rate information currently unavailable."

### F. Women and family travel mode (optional toggle)
Family-friendly attractions, women-friendly facilities, emergency contacts, nearby hospitals, accessible washrooms, accommodation info, safety information from trustworthy sources. Never claim a location is "completely safe."

### G. Smart SOS and emergency assistance
- One-tap calling; verify every number's current availability/coverage before displaying it as nationwide.
- Share location with trusted contacts (explicit user action only).
- Emergency contact directory, nearby hospitals, police/rescue contacts.
- Offline emergency instructions.
- SMS fallback: check permission → get coordinates → show coordinates → prepare message → show recipient → require explicit confirmation → hand off to native SMS. Report handoff honestly; never claim delivery without confirmation.
- Test permission denial, GPS failure, and no-internet paths.

### H. AI travel companion
Help with discovery, trip planning, budget estimation, nearby facilities, historical context, destination comparison, local customs, alternatives, preparation advice. Ground answers in project data and trustworthy sources; handle unavailable information honestly. No expensive API dependency unless explicitly justified and approved. Existing `/api/ai` is a starting point — audit and harden it.

### I. NOC and restricted-area permit workflow (guidance-first)
Multi-step: select destination → nationality → check requirements → official eligibility instructions → collect info → secure document upload if required → review → submit **only if an authorized integration exists** → status tracking (Draft / Submitted / Under Review / Additional Info Required / Approved / Rejected / Expired) → digital permit display only for genuinely issued permits. Otherwise: preparation + official application guidance workflow. Protect uploaded documents (encryption, retention policy).

### J. Foreign tourist toolkit
- **PTA temporary mobile registration:** information guide (eligibility, documents, steps, device/SIM conditions, time limits, official portal, restrictions). Independently verify any claimed time period (e.g., "120 days") against current PTA rules — do not hardcode.
- **Currency converter:** USD/EUR/GBP/AED/SAR to PKR, from an authorized reliable source, showing rate, last updated, source, cached rate, offline conversion, manual refresh, and a clear caveat that cached rates may be stale.
- **Embassy/consulate directory** (Islamabad, Lahore, Karachi): country, name, address, phone, emergency contact if published, website, hours if verified, map link, one-tap call/navigate. Verified official contact information only.

### K. Digital tourist pass
Profile, clearly labeled app-generated tourist ID (never presented as government credential), QR code, emergency contacts, optional emergency info (blood group only if voluntarily provided), saved permits, validity, privacy controls to hide sensitive details.

### L. Complaints
Categories: overcharging, misleading hotel info, poor facilities, road problems, safety concerns, damaged infrastructure, incorrect destination info, other. Description, location, photo, date/time, documents, tracking. Local workflow clearly labeled non-official unless an approved integration exists.

### M. Highway essential stops finder
Along tourist corridors: fuel, ATMs, hospitals, BHUs, pharmacies, mosques (prayer times with configurable method; Qibla via device sensors with proper permission handling), rest areas, restaurants, parking. GPS position, route planning, upcoming stops, distance, navigation handoff, saved/offline stops, verification status. Do not label facilities operational without current verification.

### N. Admin and data management
Authorized roles can manage destinations, attraction details, official rate documents, verified road alerts, emergency contacts, tourist reports, facility verification, cached data, and complaints. Role-based permissions, audit history. Ordinary users cannot publish official information.

### O. Differentiating features (evaluate, prioritize, implement selectively)
1. **Facility Freshness Score** — recency of facility verification
2. **Tourist Truth Reports** — ground conditions with photos + timestamps
3. **Journey Readiness Score** — preparation checklist from weather/road/fuel/facility data
4. **Smart Stop Finder** — useful stops between two cities
5. **Crowd Intelligence** — recommend visiting times only with reliable data
6. **Local Culture Companion** — etiquette, customs, useful phrases
7. **Lost and Found** — responsible reporting/recovery workflow
8. **Accessibility Explorer** — discover by accessibility needs
9. **Smart Trip Optimizer** — itineraries by time/budget/distance/preferences
10. **Destination Change Alerts** — notify verified changes affecting saved trips

Prioritize by user value, technical feasibility, data availability, maintenance cost. Treat as proposed differentiators, not guaranteed unique inventions. Research existing implementations before building.

---

## 6. DESIGN — PAKISTAN NATIONAL IDENTITY (canonical tokens)

Replace the current multi-palette theme with a single premium identity; keep light/dark mode.

| Token | Value |
|---|---|
| Primary (Pakistan Green) | `#01411C` |
| Surface / cards | `#FFFFFF` |
| Scaffold background | `#F4F6F2` |
| Heritage gold (restrained accent) | `#C5A66A` |
| Alert red (alerts/emergency only) | `#B91C1C` |
| Primary text | `#1F2937` |
| Secondary text | `#64748B` |
| Borders | `#E2E8F0` |

**Typography:** Poppins (headings), Roboto (body), Noto Nastaliq Urdu (Urdu) — bundle the fonts in `pubspec.yaml`. Language selector must actually switch the interface (English/Urdu) with correct RTL.

**Logo:** Original SmartMap Punjab identity combining a map/geography motif, location marker, and abstract crescent-and-star-inspired element (original artwork only — do not copy state emblems or government seals).

**Splash / onboarding:** Premium flag-inspired visual with subtle fabric movement, elegant lighting, original branding, strong destination-focused tagline, smooth transitions. Communicates Pakistani identity immediately; not crowded.

**Home dashboard:** Hero section, search, explore cities, historical/religious, nature/adventure, food/culture, nearby facilities, travel planning, safety/emergency access, personalized recommendations — using real project images and data. A government-portal-style service grid is acceptable as a layout pattern, but the content must be truthful and functional. Every card opens a working screen. No decorative dead buttons.

**3D visuals:** Tasteful Punjab topographic map, heritage monument illustration, subtle depth/lighting, controlled motion. Lightweight assets; degrade gracefully on low-end devices.

**Components:** Reusable design tokens and shared widgets for buttons, cards, inputs, chips, loading/empty/error states, spacing, shadows, borders. Redesign all major screens, not just home.

**Bottom navigation:** Home / Explore / Helpline / My Pass — preserve per-tab state; emergency must stay quickly reachable.

---

## 7. ARCHITECTURE RULES

**Flutter (keep current stack):** Riverpod, Dio, Hive, flutter_secure_storage, repository-pattern data access, feature-first modular folders. Separate UI / business logic / data sources. No monolithic `main.dart`. Proper error handling, logging, validation, dependency injection.

**Backend (keep):** Express + MongoDB + JWT/RBAC + helmet/rate-limit/sanitize (already wired). Add models as needed: PermitApplication, RateList, RoadAlert, CurrencyRate, EmergencyContact, Complaint, DigitalPass, Notification, Facility, TouristReport, AuditLog. Add validation, indexes, pagination, access control, audit logging, secure uploads, retention policies.

**Offline-first:** Local DB (Hive), cache expiration rules, last-synced timestamps, background sync, conflict resolution, online/offline indicators, retries, secure storage for sensitive data. Never present expired cache as live. Distinguish: Live / Cached / Expired / Unavailable. Must remain useful in weak-connectivity areas.

**Android:** Fix `applicationId` (`com.example.smartmap_ai` → production ID), release signing, remove dev-only config, correct permissions, supported SDK levels.

**Admin:** In-app admin screens already exist — harden them (RBAC, audit). The `admin-dashboard/` React shell is optional; if built, scope it to data management described in Section 5.N.

---

## 8. DATA QUALITY AND TRUST

Every destination/business/facility record: correct city, correct category, valid coordinates, valid images, relevant description, contact info, hours, price info, data source, last updated, verification status. Prevent duplicates and wrong category mappings. Never fill gaps with fabricated data.

Status vocabulary everywhere: **Verified / Community reported / Needs verification / Information unavailable.** Provide an admin-friendly correction path.

Specific retest targets after data cleanup: Historical & Religious Places, All Cities, Tourist Attractions, Bakeries and Cakes, Fast Food, Restaurants, city-specific attraction pages, maps, saved places, search and filters, emergency workflows.

---

## 9. PERFORMANCE AND COMPATIBILITY

Test: small/large screens, multiple Android versions, low-memory devices, slow/no internet, GPS disabled, permission denied, background/resume, app restart. Optimize image loading, caching, DB queries, network calls, startup time, memory, widget rebuilds. Generate a correctly signed release APK; verify install and launch on representative devices/emulators without developer options or USB debugging.

---

## 10. TESTING AND VALIDATION

Code changes are not proof of functionality. For each feature: inspect implementation → find root cause if broken → fix → static analysis → automated tests → verify full user journey → regression check → record evidence.

Use: `flutter analyze`, unit tests, widget tests, integration tests, backend API tests (e.g., supertest), MongoDB integration tests, offline-mode tests, EN/UR + RTL checks, permission/permission-denied tests, SMS fallback tests, QR generation/validation, Android release build verification.

Expand the near-empty test suite meaningfully; at minimum cover: auth, city/category navigation, search/filters, favorites, reviews, trip planner, budget calculator, bill splitter, AI endpoint error handling, and offline cache expiry behavior.

---

## 11. IMPLEMENTATION ROADMAP (work in order, one phase at a time)

| Phase | Work | Exit evidence |
|---|---|---|
| 1 | Project audit and baseline: run analyze/tests/build, verify both docs exist, rewrite README | Baseline report + clean build notes |
| 2 | Research: competitor matrix + Pakistan problems docs | `docs/COMPETITOR_RESEARCH.md`, `docs/PAKISTAN_TOURIST_PROBLEMS.md` |
| 3 | Data audit and cleanup: cities, categories, coordinates, images, duplicates, seed integrity | Data audit report + fixed seeds |
| 4 | Design system + logo + splash + home redesign (tokens, typography, components, EN/UR/RTL) | Design docs + implemented screens |
| 5 | Critical functional bug fixes: every city/category flow, search/filters, detail pages | Test evidence per flow |
| 6 | Offline and reliability foundation: cache TTL, sync, indicators, secure storage | Offline test results |
| 7 | Core tourist features: facilities, road alerts, travel reality check, trust/pricing, DC rates | Feature tests + source attribution |
| 8 | Differentiating features (approved priorities from Section 5.O) | Per-feature status in matrix |
| 9 | Permits (guidance), foreigner toolkit, digital pass, complaints | Workflow tests |
| 10 | Backend/admin/security hardening: models, RBAC, audit, retention, secrets review | Security checklist |
| 11 | Performance, compatibility, full regression | `docs/TESTING_REPORT.md` |
| 12 | Release: signing, APK, final docs | Signed APK + `docs/RELEASE_NOTES.md` |

**Documentation deliverables:** `docs/PRODUCT_REQUIREMENTS.md`, `docs/ARCHITECTURE.md`, `docs/DATA_SOURCES.md`, `docs/API_DEPENDENCIES.md`, `docs/FEATURE_STATUS.md`, `docs/IMPLEMENTATION_PROGRESS.md`, `docs/TESTING_REPORT.md`, `docs/RELEASE_NOTES.md` (plus the two research docs).

**Optional project skills** under `.agents/skills/` (only if equivalent reliable skills do not already exist): flutter-architecture, tourism-product-research, premium-mobile-ui-ux, pakistan-tourism-domain, mongodb-data-integrity, maps-and-geospatial, offline-first-mobile, qa-and-regression-testing, android-release-engineering, mobile-security-and-accessibility. Each: SKILL.md with scope, activation criteria, guidelines, checklist, testing procedures.

---

## 12. FINAL ACCEPTANCE CRITERIA

1. All existing critical functionality works (81 cities, categories, search, filters, favorites, reviews, trips, budget calculator, bill splitter, taxi estimate, anti-scam, offline guide, payment guide).
2. Every city and category navigation flow works end to end.
3. Consistent Pakistani identity across all major screens; EN/UR switching and RTL work.
4. Core tourist facilities are discoverable with honest verification states.
5. Travel/road information carries source attribution and timestamps; cached vs live is clearly distinguished.
6. Approved differentiating features are implemented; the rest are documented as backlog.
7. Offline functionality works where promised; expired data is labeled.
8. User identity data is protected; consent and data minimization applied.
9. App works across supported Android devices and conditions.
10. Signed release APK builds, installs, and launches.
11. Regression testing passes with recorded evidence.
12. Remaining limitations and external dependencies are documented honestly.

---

## 13. FINAL EXECUTION INSTRUCTION

Take ownership of the complete SmartMap Punjab transformation.

- Do not stop at research or a proposal.
- Do not stop after attractive screens.
- Do not introduce fake functionality to look complete.
- Inspect before editing; preserve working features; commit logically.
- Make technically sound decisions independently, but flag real blockers (missing APIs, missing credentials, missing SDKs) explicitly.
- If an external API, government integration, paid service, or dataset is required, document the dependency and implement the best honest alternative.
- Prioritize real tourist problems over decorative features.
- The final product must feel like a premium, trustworthy Pakistani tourism platform — the usability of a mature travel app with the identity of Pakistan.

Deliver a working, tested application and a verified release APK — not merely a report.
