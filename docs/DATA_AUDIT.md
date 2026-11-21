# DATA AUDIT — Phase 3

**Date:** 2026-11-21
**Scope:** Flutter offline datasets, backend seed scripts, MongoDB `Place` schema, and API publication filters.

## Method

- Parsed `mobile/lib/core/data/punjab_81_cities_data.dart` and `punjab_offline_data.dart` with a script checking field completeness, duplicates, coordinate ranges, category validity, and URL format.
- Inspected all backend seed scripts and the `Place` model.
- Spot-checked four representative image URLs with HTTP requests (all returned 200).
- No live database was available during this audit; findings concern source data and code, not a deployed dataset.

## 1. 81-city dataset (`punjab_81_cities_data.dart`)

| Check | Result |
|---|---|
| City count | 81 |
| Featured cities | 12 |
| Duplicate ids | 0 |
| Duplicate names | 0 |
| Missing Urdu name / image / population | 0 |
| Non-HTTPS cover images | 0 |

Conclusion: structurally clean. Image URL availability spot-check passed (4/4 HTTP 200). Full URL sweep not performed.

## 2. Offline place dataset (`punjab_offline_data.dart`)

| Check | Before | After |
|---|---|---|
| Places | 27 | 27 |
| Records marked `verified: true` | 27 (all) | 0 |
| Explicit female-safe claims | 4 (+ all via default) | 0 |
| Explicit family-friendly claims | 4 (+ all via default) | 0 |
| Duplicate ids/names | 0 | 0 |
| Unknown categories | 0 | 0 |
| Missing coordinates | 0 | 0 |
| Coordinates outside Punjab bounds | 0 | 0 |

**Issues found and fixed:**

1. **All 27 offline places were marked verified** without any verification evidence. Changed to `verified: false`.
2. **`PlaceModel` defaulted `isFemaleSafe` and `isFamilyFriendly` to `true`**, so every record implicitly claimed safety/family suitability. Defaults changed to `false`; explicit `true` values in offline data changed to `false`. Such claims now require actual verification.
3. **No provenance fields existed.** Added `verificationStatus`, `lastVerifiedAt`, and `source` to the Flutter `PlaceModel` and the backend schema (see §4).

## 3. Seed scripts

| Script | Places | Categories used | Issues |
|---|---|---|---|
| `seedAllPunjabPlacesAndEvents.js` | 71 | 7 | All marked verified; no city field; no provenance |
| `seedPunjabCitiesData.js` | ~40 | Bakeries + existing categories | Same |
| `seedPlaces.js` | 15 | Sample subset | Same |
| `seedMorePlaces.js` | several | Sample subset | Same |

**Fixes applied:**

- Seeds now insert `verificationStatus: 'community_reported'`, `source: 'Compiled public directory (unverified)'`, and `verified: false`. Seed data is compiled from public information; it is not field-verified.
- Main seeds derive `city` from the address's city segment (for example `..., Lahore, Punjab` → `Lahore`) and store it explicitly.
- Re-seeding never downgrades a record already marked `verificationStatus: 'verified'` by an administrator.

**Category coverage gap (data, not fabricated — tracked as follow-up):**

| Required category | Seed coverage |
|---|---|
| Historical & Religious | Present (5) |
| Restaurants | Present (12) |
| Bakeries & Cakes | Present (20) |
| Hotels | Present (4) |
| Parks & Nature | Present (4) |
| Shopping & Malls | Present (4) |
| Hospitals & Medical | Present (22) |
| Fast Food | Category now seeded; **no place records yet** |
| Adventure | Category now seeded; **no place records yet** |
| Family Attractions | Category now seeded; **no place records yet** |
| Tourist Attractions | Category present; records largely live under other categories |

**Taxonomy fix applied:** new `backend/config/categories.js` defines 11 canonical categories; `backend/scripts/seedCategories.js` upserts them. All seed scripts now ensure the taxonomy exists, and `seedPunjabCitiesData.js` no longer falls back to the "Restaurants" category for unknown names (it skips the record with a warning, avoiding mislabeled data). Empty categories must be filled with real, sourced records (`source` + `verificationStatus`), not invented ones. The keyword → category search mapping in `placeRoutes.js` resolves correctly against these names.

## 4. Backend schema and API

`backend/models/Place.js` additions:

- `city` (string, indexed)
- `verificationStatus` — enum: `verified` | `community_reported` | `needs_verification` | `unavailable` (default `needs_verification`)
- `lastVerifiedAt` (date)
- `source` (string)
- Legacy `verified` boolean retained for compatibility.

New shared filter `backend/utils/publishedPlaceFilter.js` publishes only `verified` and `community_reported` records (with a legacy fallback for old documents). Applied to:

- `GET /api/places` (list + count)
- `GET /api/places/search`
- `GET /api/places/nearby`
- `GET /api/places/:id` related places
- `/api/ai/recommend` (main and fallback queries)
- `/api/trips` itinerary generation
- Business verification flow now sets `verificationStatus` and `lastVerifiedAt` on approve/revoke.

City filtering now matches the explicit `city` field as well as address/name text.

## 5. Remaining data risks

1. `mobile/lib/core/data/punjab_cities_data.dart` is unused legacy data. Deletion was blocked by the environment's safety classifier; it should be removed in a follow-up with explicit confirmation.
2. All city/place images reference Unsplash stock photography, not real photographs of the named places. The prompt requires "real project images and destination information"; stock photos presented as destination imagery should be replaced or clearly labeled.
3. Ratings and review counts in seeds are not backed by real user reviews. They must be treated as placeholder metadata and labeled, or replaced by real data before release.
4. Coordinates are plausible but not independently verified for every record; verification requires field data or authoritative sources.
5. `punjab_81_cities_data.dart` populations use 2023 census figures but individual values were not cross-checked in this audit.

## 6. Verification state after Phase 3

| Item | Status |
|---|---|
| Dataset structural audit | Verified (scripted checks) |
| Honest verification labels in code/seeds | Implemented |
| Backend publication filter | Implemented |
| Canonical category taxonomy (11 categories) | Implemented |
| Flutter analyze + test after changes | Verified (0 errors/0 warnings; tests pass) |
| Category content gaps | Blocked (needs sourced data) |
| Stock imagery replacement | Blocked (needs licensed real photos) |
| Real ratings/reviews replacement | Blocked (needs real user data) |
