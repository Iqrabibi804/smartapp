# External Directory Workbook Audit

**Reviewed file:** `Punjab_Islamabad_Hierarchy_Police_completed.xlsx`  
**Workbook snapshot date:** 23 November 2026 (as stated in the workbook)  
**Review date:** 24 November 2026

## Decision

The workbook is useful as a research and candidate-data source, but it is **not safe to import wholesale into the published places catalogue**. Keep its records separate until each dataset has the required location, provenance and publication checks. OpenStreetMap presence does not prove that a business is open, safe, licensed, currently reachable, or that its contact details are current.

## Workbook coverage

Counts below are source workbook rows (excluding headers), not verified/current listings.

| Sheet | Rows | Assessment / handling |
|---|---:|---|
| `Bus_Stations` | 246 | OSM reference entries. All have numeric coordinates within valid latitude/longitude ranges and unique OSM links in this workbook snapshot. |
| `Hotels` | 733 | OSM/curated directory candidates. No latitude/longitude columns; map links are search/reference links, not coordinates. |
| `Restaurants` | 1,166 | OSM/curated directory candidates. No latitude/longitude columns; map links are search/reference links, not coordinates. |
| `Islamabad_Police` | 27 | Secondary-source station directory; workbook notes disagreement among sources on station totals. Not an emergency directory. |
| `Islamabad_Area_to_Station` | 100 | Secondary-source area-to-station mappings; not suitable for emergency routing without official confirmation. |
| `Islamabad_Zone_Summary` | 6 | Summary data from workbook. |
| `Lahore_Police` | 94 | Workbook describes 84 stations plus 10 posts; secondary-source data, not an official emergency directory. |
| `Punjab_Hierarchy` | 162 | Tehsil hierarchy based on workbook's cited 2023-census-based Wikipedia list; confirm against official records. |
| `Punjab_District_Summary` | 42 | Derived administrative summary. |
| `App_Cities_81` | 81 | Existing app-city profile reference snapshot. |
| `Tehsil_Coverage` | 162 | Name-based tehsil-to-app-city coverage summary. |
| `Division_Summary` | 11 | Derived division summary. |
| `City_Summary` | 83 | Aggregated workbook summary rows, including non-city/total summary rows. |

The workbook README also states that it is not a complete directory for hospitals, clinics, Chinese restaurants, or every service across all 81 app cities.

## Safe import policy

1. Import every supplied sheet into its own JSON collection; do not merge this material into verified place records.
2. Preserve original source columns, blank values, OSM object URLs and workbook provenance. Never infer missing coordinates, ratings, hours, operators, prices, or contact information.
3. Keep all imported rows marked `referenceOnly: true` and `verified: false`. OSM presence is not verification.
4. Validate bus-station latitude/longitude ranges. Preserve invalid/missing coordinates as unavailable rather than fabricating a map pin.
5. Flag duplicate OSM references for review; do not deduplicate solely by name because same-name businesses can exist in different towns.
6. Do not expose phone numbers, hours, ratings or amenities as trusted/current until independently verified. The app directory hides unverified contact values.
7. Do not use police numbers or station mappings for SOS/emergency actions. Official ICT Police / Punjab Police confirmation is required before any emergency use.
8. Keep hotels/restaurants as list and external map-search references unless genuine coordinates are separately obtained and checked.
9. Include OpenStreetMap attribution: **© OpenStreetMap contributors**, and comply with ODbL 1.0 attribution/notice requirements.

## Importer

The feature branch includes `scripts/import_directory_workbook.py`. It imports all 13 workbook sheets listed above, preserves source columns and missing values, marks OSM duplicates and coordinate validity, and attaches reference-only/verification metadata.

Run from the repository root:

```powershell
python -m pip install openpyxl
python scripts/import_directory_workbook.py .\\Punjab_Islamabad_Hierarchy_Police_completed.xlsx
cd mobile
flutter pub get
flutter test
```

The output path is `mobile/assets/data/punjab_directory.json`.

## Integration status

The searchable directory UI has bus-station, hotel, restaurant and police-reference tabs, city filtering, search, map/reference links, OSM attribution and an explicit police-source warning. Unverified phone values are hidden. The importer and UI are committed on the feature branch.

**The generated workbook JSON is not yet checked into the app asset.** The current asset remains an empty build-safe placeholder, so the workbook's records are not yet available offline in the running app. This is a deliberate data-integration blocker, not a claim that the workbook is already bundled. After replacing the placeholder with the generated JSON, update the widget test to assert real category counts and rerun Flutter tests, Android APK build and web release build before merging.
