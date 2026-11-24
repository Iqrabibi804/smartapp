# External Directory Workbook Audit

**Reviewed file:** `Punjab_Islamabad_Hierarchy_Police_completed.xlsx`  
**Workbook snapshot date:** 23 November 2026 (as stated in the workbook)  
**Review date:** 24 November 2026

## Decision

The workbook is useful as a research and candidate-data source, but it is **not safe to import wholesale into the published places catalogue**. Keep its records separate until each dataset has the required location, provenance and publication checks. In particular, do not treat OpenStreetMap presence as proof that a business is open, safe, licensed, currently reachable, or that its contact details are current.

## Sheet-by-sheet assessment

| Sheet | Rows / coverage | Assessment | App decision |
|---|---:|---|---|
| `App_Cities_81` | 81 cities | Matches the app's existing 81-city directory snapshot. | Do not duplicate; use only for reconciliation. |
| `Punjab_Hierarchy` | 162 tehsils / 42 districts | Workbook says the hierarchy is based on Wikipedia's 2023-census-based list; matching is name-based and some newer administrative changes need official confirmation. | Reference only; do not present as an authoritative government boundary dataset. |
| `Bus_Stations` | 246 records / 50 City labels | All 246 rows have numeric coordinates in valid latitude/longitude ranges and unique OSM links. 16 rows are labelled `Other Punjab`. 230 rows have no `Nearest app city`; 229 have no operator. OSM coverage is not complete service coverage. | Best candidate for a separate, clearly labelled OSM transport directory. Keep unverified; add OSM attribution if shipped. |
| `Hotels` | 733 rows | 723 OSM-sourced rows plus curated app snapshot rows. The sheet has no latitude/longitude columns, so it cannot supply reliable map pins. Only 88 phone values and 25 websites; 729 have no star value; 723 have no review score. Ten rows have no OSM link. | Do not import into map/place records yet. Resolve coordinates and deduplicate/reconcile curated rows first. |
| `Restaurants` | 1,166 rows | 1,161 OSM-sourced rows plus curated app snapshot rows. The sheet has no latitude/longitude columns. Only 109 phone values and 46 websites; only 6 rows have rating and price-tier values. Five rows have no OSM link. | Do not import into map/place records yet. Resolve coordinates and keep ratings/prices unknown unless separately evidenced. |
| `Islamabad_Police` | 27 stations | Secondary directory source (INCPak, per workbook); 7 phone values missing. Workbook itself notes disagreement between 22, 27 and 32 station counts across sources. | Do not publish as an official emergency directory until checked against ICT Police. |
| `Lahore_Police` | 94 rows | 84 police stations plus 10 police posts, per workbook; secondary directory source. Police divisions are not revenue tehsils. | Do not publish as an official emergency directory until checked against Punjab Police. |
| `Islamabad_Area_to_Station` | 100 area mappings | Useful as a lead, but the underlying station coverage and phone data inherit the secondary-source limitation. | Research reference only; not for emergency routing. |
| `Punjab_District_Summary` / `Division_Summary` / `Tehsil_Coverage` | 42 districts / 10 divisions | Derived from the hierarchy and name-based matching. | Use for planning coverage, not as verified administrative reference. |
| `City_Summary` | 83 rows including Other Punjab and TOTAL | Aggregated counts from the workbook, not independent validation of availability. | Analytics/research only. |

## Quantitative quality checks

- Bus stations: 246/246 coordinates present and in valid numeric ranges; 246/246 OSM links unique.
- Hotels: 733 rows; 10 rows without OSM links; no coordinate columns.
- Restaurants: 1,166 rows; 5 rows without OSM links; no coordinate columns.
- Police contacts: 7/27 Islamabad station phone fields are blank.
- Workbook README explicitly says the workbook is not a complete directory for hospitals, clinics, Chinese restaurants, or all services across all 81 cities.

## Import rules

1. Preserve OSM records as a separate source class; do not mark them `verified` merely because an OSM object exists.
2. If bus stations are added, retain OSM object URL, source snapshot date and coordinates; label the record as map/reference data, not confirmation of current service.
3. Include the required OpenStreetMap attribution: **Data (c) OpenStreetMap contributors**, with ODbL 1.0 attribution/notice in the app's About/data sources screen.
4. Do not infer opening hours, routes, operators, phone numbers, accessibility, safety or service frequency from missing values.
5. Do not use workbook phone numbers for SOS/emergency actions without official-source verification.
6. Before hotels/restaurants are mapped, resolve coordinates from their OSM object IDs and check object type/status; do not geocode the generated Google Maps search URL as a substitute.
7. Keep blank ratings, review counts, star ratings and price tiers blank. Do not turn blanks into zero or estimated values.
8. Deduplicate by OSM object identity, not by name alone; identical business names can legitimately occur in different towns.

## Recommended next step

A searchable local-directory screen and workbook importer are now present on the feature branch. To generate the real offline asset, place the workbook at the repository root and run:

```powershell
python -m pip install openpyxl
python scripts/import_directory_workbook.py .\\Punjab_Islamabad_Hierarchy_Police_completed.xlsx
cd mobile
flutter pub get
flutter test
```

The script writes `mobile/assets/data/punjab_directory.json`. The checked-in JSON is currently an empty build-safe placeholder, not the workbook records. This is intentional until the generated asset can be added and validated; do not claim the workbook's 2,266 business/transport rows are already available in the app. The UI includes separate bus, hotel, restaurant and police-reference tabs. Hotel/restaurant entries remain list/map-link records because their workbook sheets have no coordinate columns. Police entries are labelled as secondary-source references and are not exposed as emergency-call actions. After the generated asset is added, run the full Flutter test and Android/web build before merging. Police directories should remain out of the public app as an authoritative emergency directory until official verification is complete.
