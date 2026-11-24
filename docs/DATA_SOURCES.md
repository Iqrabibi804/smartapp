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
- **Legacy contact/facility/payment fields:** some bundled records still contain phone
  numbers, facility labels and payment-method claims that have not been independently
  confirmed. They are treated as unverified and are not shown as actionable contact,
  hours, facility or payment information in Place Details.
- **Images:** bundled place records may contain generic Unsplash stock images; they are
  illustrative and are now hidden in Place Details unless the place record is verified.
- **Verification status:** bundled places carry `verified: false`; they are labelled
  "Not yet verified". The app only treats an explicit `verificationStatus == 'verified'`
  (or a legacy `verified: true` record with no status field) as verified.

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

## 12. Route planner corridor figures

- **What ships:** three rounded corridor references — Lahore → Islamabad ≈ 375 km / ≈ 4 h 15 m (M-2), Lahore → Multan ≈ 340 km / ≈ 3 h 50 m (M-3), Rawalpindi → Jhelum (Rohtas Fort) ≈ 110 km / ≈ 1 h 45 m (N-5). Rest stops on M-2 (Sukheke KM 85, Bhera KM 220, Kallar Kahar KM 290) are listed with amenity badges.
- **Status:** approximate planning values, not a live routing API and not verified against an NHA feed in this build. The UI labels them "≈" and says facilities must be verified on arrival.
- **Deliberately omitted:** fuel cost, toll amounts and public-transport fares. The screen shows "information unavailable" and directs users to current NHA rates and local adda/station counters.
- **Live status:** marked "No live feed"; users are pointed to nha.gov.pk and nhmp.gov.pk, with reference date 2026-11-22.
- **Maintenance:** if these figures or the rest-stop list are updated, record the source and date here first; otherwise the screen must keep the unavailable wording.

## 13. Stays and restaurants listings

- **Stays (10 properties):** names, cities, Booking.com scores, review counts and facility tags come from a Booking.com search snapshot supplied on 2026-11-22. The screen labels them "as listed on Booking.com in November 2026". No prices, availability or photos are stored.
- **Booking links:** every "Find on Booking.com" button opens a live Booking.com search (`searchresults.html?ss=<property, area, city>`). The bare homepage and invented property permalinks are never used; the bottom banner opens a Punjab-wide search (`ss=Punjab, Pakistan`). No result count is printed.
- **Restaurants (6 venues):** ratings and review counts are public listing figures from the same 2026-11-22 snapshot and are labelled in-app as not being reviews collected by this app. Official websites are linked only where supplied: `haveli.com.pk`, `themonal.com` and `bundukhan.pk` answered HTTP 200 on 2026-11-22; `cafeaylanto.com` answers 403 to non-browser requests but is the restaurant's published domain and is kept.
- **No invented contact data:** Butt Karahi Tikka and Baba Tikka Shop have no verified ordering page in this build, so their primary action opens a Google Maps search. Phones are shown only where the app already carried the number (Butt Karahi, The Monal); no menu, price or phone number was fabricated.
- **Maps:** every card has a Google Maps search built from the name, area and city.
- **Maintenance:** re-check scores and links before each release. If a venue's site goes dark, remove the website action and fall back to the map search; keep the "listed figures" label until a live source exists.
