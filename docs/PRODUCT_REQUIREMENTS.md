# SMARTMAP PUNJAB — PRODUCT REQUIREMENTS (v1.0)

**Tagline:** Explore Punjab. Travel with Confidence.
**Status:** release candidate 1.0.0+1 (Android build in progress at time of writing)

## 1. Vision

A travel companion for Punjab that helps residents and visitors find places, understand
conditions and prepare honestly — with no fabricated "live" data, no claims of government
affiliation, and no invented official prices.

## 2. Users

- **Domestic tourist / family** — discovery, food, hospitals, routes, preparation.
- **Foreign visitor** — PTA registration guidance, currency conversion, permit guidance.
- **Local business owner** — register a listing for moderation.
- **Moderator / admin** — verify businesses, moderate reviews, manage places, audit actions.

## 3. Implemented scope

| Area | Requirement | State |
|---|---|---|
| Directory | 81-city dataset, categories, city guides, search and filters, place details | Implemented |
| Offline | Hive TTL cache (6–24 h), honest freshness banner, bundled fallback | Implemented |
| Facilities | Hospital/pharmacy/fuel/ATM/police/parking/restaurant/washroom filters with verification labels | Implemented |
| Road intelligence | Seven sourced corridor advisories; statuses report "Information unavailable" without a live feed | Implemented |
| Travel reality check | Per-place disclosure of unverified weather/road/permit conditions | Implemented |
| Price fairness | No invented rates; DC rate lists marked unavailable; on-device overcharging reports | Implemented |
| Trust | Verification status surfaced; reviews; business moderation | Implemented |
| Differentiators | Journey readiness checklist; local culture companion; facility verification dates | Implemented |
| Permits | Guidance-only NOC workflow, no submission/tracking | Implemented |
| Foreign toolkit | PTA guidance, manual-rate currency converter, embassy info marked unavailable | Implemented |
| Digital pass | Consent-gated app-generated ID on device, clearly non-official | Implemented |
| Complaints | Local records with reference IDs, official portal link, clearly non-official | Implemented |
| Safety | Emergency contact modal, offline guidance | Implemented (SMS fallback not built) |
| Backend | JWT auth/RBAC, moderation, audit log, rate limits, upload controls | Implemented |
| AI | Rule-based discovery assistant grounded in project data | Implemented |

## 4. Non-goals and explicit limitations

- No official government integration, approval, permit issuance or live road/rate feed.
- No claim that a place, facility or price is verified unless the record says so with a date.
- No SMS delivery claims; no location sharing without explicit user action.
- No live exchange rates; conversion uses a rate the traveller enters.
- No QR code on the digital pass in this build.

## 5. Acceptance criteria mapping

| Criterion | Evidence |
|---|---|
| Brand and navigation consistent | `docs/DESIGN_SYSTEM.md`, splash/home implementations |
| Every city/category flow works | Offline filter tests; device journeys pending |
| No fabricated live data | Road advisories report unavailable; fake alerts/prices removed |
| Offline behaviour | Cache TTL tests; banner; bundled fallbacks |
| Security | `docs/SECURITY_REVIEW.md` |
| Quality gates | `flutter analyze` clean; 20 tests; release web build; APK build (see `docs/RELEASE_NOTES.md`) |

## 6. Outstanding before store release

1. On-device journey verification (no Android device in the build environment).
2. Rotate the MongoDB credential exposed in Git history; restrict the Maps key.
3. Real reviewed content for ratings/images and the empty category gaps.
4. Interface-wide Urdu switching and RTL mirroring.
5. Store listing assets, privacy policy URL and data-safety declaration.
