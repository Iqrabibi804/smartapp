# SMARTMAP PUNJAB — DATA SOURCES & PROVENANCE

Every dataset in the app is either (a) compiled by the project team, (b) linked to a
named external publisher, or (c) explicitly marked unavailable. Nothing is presented as
live unless a live source is connected — and at v1.0.0 none are.

## 1. City directory — 81 cities

- **File:** `mobile/lib/core/data/punjab_81_cities_data.dart`
- **Fields:** name, Urdu name, district, region, 2023 population, summary, famous-for,
  signature food, cover image.
- **Provenance:** compiled from public census/district information and general reference
  material. **Population figures are approximate 2023 estimates** and should be treated
  as context, not official statistics.
- **Images:** Unsplash stock photography URLs. They are illustrative — not photographs
  guaranteed to depict the named city.
- **Verification status:** none claimed.

## 2. Offline place directory — 27 places

- **File:** `mobile/lib/core/data/punjab_offline_data.dart`
- **Fields:** category, coordinates, address, facilities, price band, images.
- **Ratings / review counts:** **zeroed in this release.** The app now shows
  "No reviews yet" until real user reviews exist. No seeded star ratings remain.
- **Images:** Unsplash stock photography (illustrative).
- **Phone numbers:** removed during the data audit unless independently confirmable;
  remaining contact fields must be checked before reliance.
- **Verification status:** bundled places carry `verified: false`; no "verified" badge is
  shown without a `verificationStatus == 'verified'` record from the backend.

## 3. Road advisories — 7 corridors

- **File:** `mobile/lib/core/data/road_advisories.dart`
- **Entries:** KKH (N-35), Babusar Pass, Lowari Tunnel, Khunjerab, Naran–Kaghan,
  Murree Expressway, Skardu Road.
- **Provenance:** compiled guidance with source links to **NHA (nha.gov.pk)** and
  **NHMP (nhmp.gov.pk)**; reference date recorded per entry (2026-11-21).
- **Status:** all entries use `RoadStatus.unavailable` — the app has no live feed and does
  not claim one. Users are directed to the agencies for current status.

## 4. Permit guidance — 5 destinations

- **File:** `mobile/lib/features/places/screens/permits_screen.dart`
- **Provenance:** general administrative guidance (DC / police NOC process).
- **Limits:** fees and processing times render "information unavailable"; no application
  is submitted and no status is tracked in-app.

## 5. Foreign-visitor guidance

- **PTA device registration:** steps link to **pta.gov.pk**; no fixed processing time is
  asserted.
- **Embassies:** "Embassy contact information is currently unavailable"; link to
  **mofa.gov.pk**.
- **Currency converter:** requires a rate entered by the user; labelled "not live".
  No exchange-rate API is connected.

## 6. Official prices and rates

- **Status: unavailable.** No official DC rate list is bundled or scraped.
- The Price Fairness screen states that official rate information is unavailable and
  offers general overcharging guidance. On-device reports are never transmitted.

## 7. Culture and language content

- **Files:** `culture_companion_screen.dart`, `app_language.dart`
- General etiquette tips and seven useful Urdu phrases; a disclaimer notes regional
  variation.

## 8. Reviews, businesses, places (backend)

- **Source:** user-submitted records in MongoDB, moderated by staff.
- Ratings shown for backend records are computed from actual submitted reviews.
- Business listings enter `pending` moderation before appearing.

## 9. Dashboard landmark photography (bundled assets)

- **Directory:** `mobile/assets/images/landmarks/` (9 JPEGs, ~3.8 MB total)
- **Files:** badshahi_mosque, lahore_fort, shalimar_gardens, derawar_fort,
  multan_shrine, noor_mahal, rawalpindi_bazaar, murree, taxila_dharmarajika.
- **Publisher:** Wikimedia Commons contributors. Images were downloaded from the
  Commons 1920px thumbnail endpoint; each depicts the named landmark.
- **Retrieval date:** 2026-11-21.
- **Licence:** individual Wikimedia Commons licences (CC BY / CC BY-SA / public
  domain as tagged on each file page) apply; attribution to Commons contributors is
  shown in the Must-Visit Destinations section subtitle.
- **Status:** bundled offline assets — not fetched live, not licensed stock. If a
  file is replaced, record the new Commons file page URL here.

## 10. Explicitly not sourced

- Live road/weather conditions
- Official government approvals, permits or verification
- Official price/fare schedules
- Live currency exchange rates
- Emergency service availability or SMS delivery confirmation

## 11. Maintenance rule

Any new dataset must record here: publisher, URL, retrieval date, and whether the app
shows it as live, cached, or unavailable. If provenance cannot be stated, the data does
not ship.
