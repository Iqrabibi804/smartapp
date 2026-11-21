# Competitor Research — SmartMap Punjab (Phase 2)

**Purpose.** Establish an evidence-based view of the existing tourism product landscape relevant to SmartMap Punjab, so that later design and engineering decisions rest on verified competitor capabilities rather than assumptions.

**Method.** Desk research only. Primary sources were official product websites and official app-store listings (Google Play, Apple App Store), including developer-supplied descriptions, "What's new"/version-history notes and declared metadata. Government sources were the official Punjab, federal (PTDC) and provincial tourism portals and official departmental social-media posts. No competitor product was installed or tested hands-on. Every capability statement below is attributed to a numbered source in the [Sources](#sources) list; anything that could not be confirmed from a real source is explicitly marked **Unverified**.

**Access date.** All sources were accessed on **2026-11-21**.

**Known limitations.**

- Competitor feature sets change frequently; a claim is only valid as of the listing date shown in its source entry.
- App-store descriptions are marketing copy written by the developer. They establish that a feature is *claimed*, not that it works well or works in Pakistan.
- Several relevant products could not be inspected directly (blocked pages, timeouts, no listing found); these are recorded in section 3 ("Not verified / excluded").
- No usability testing, pricing audit, or on-the-ground Punjab coverage test was performed.
- Review-derived observations (e.g. star ratings) are included only where the store page exposes them and are treated as secondary evidence.

---

## 1. Scope and product selection

Products requested by the project master prompt, plus the minimum two additional Pakistani products:

| # | Product | What it is | Verified via |
|---|---------|-----------|--------------|
| 1 | Google Maps | Global mapping/navigation platform | Play Store listing [S1] |
| 2 | Tripadvisor | Global reviews, planning and booking platform | Play Store listing [S2] |
| 3 | Wanderlog | Global trip-itinerary planner | Official site [S3] |
| 4 | Rome2Rio | Multimodal long-distance transport search | Play Store listing [S4] |
| 5 | Visit A City | City itinerary/self-guided-tour planner | Play Store listing [S5] |
| 6 | Sygic Travel | Offline city-trip planner | Official site + listings [S6] |
| 7 | Punjab Tourism (official): tourism.punjab.gov.pk | Tourism, Archaeology & Museums Department portal | Official site [S7] |
| 8 | Punjab Tourism (official): Magnificent Punjab App | Official Punjab travel app (by PITB) | Play Store listing [S8], departmental posts [S9] |
| 9 | Punjab Tourism (official): TDCP App | Official app of Tourism Development Corporation of Punjab | Apple listing [S10], PTDC provincial list [S11] |
| 10 | Pakrism | Pakistani tour-discovery/booking app with UGC | Play Store listing [S12], website [S13] |
| 11 | kptourism (KPCTA) | Official Khyber Pakhtunkhwa tourism app | Apple listing [S14], portal [S15] |
| 12 | Official federal portal: PTDC / Salam Pakistan | National tourism facilitation e-portal | Official site [S16], e-portal [S17], Salam Pakistan [S18] |

### Domain verification note

- **Punjab:** `tourism.punjab.gov.pk` is live and identifies the Tourism, Archaeology and Museums Department, Government of the Punjab [S7]. PTDC's provincial directory lists under Punjab the **Tourism Development Corporation Punjab** with domain `tdcp.gop.pk` [S11]; the department site links to `tdcp.gop.pk` tour pages for booking [S7]. The department site also links allied portals `archaeology.punjab.gov.pk`, `lahoremuseum.punjab.gov.pk` and `dts.punjab.gov.pk` [S7]. `tdcp.gop.pk` itself did **not** load within the fetch time limit on the access date, so TDCP's own website functionality is **Unverified** (its app listing is verified separately [S10]).
- **Federal:** PTDC operates `tourism.gov.pk` and the "Salam Pakistan" brand; the official tourism facilitation e-portal is `salampakistan.gov.pk` [S16, S17, S18].
- **Other provinces (for context only):** Sindh `stdc.gos.pk`, Khyber Pakhtunkhwa `kptourism.com` / `tca.kp.gov.pk` [S15], Balochistan `cta.gob.pk`, AJK `ajk.gov.pk`, Gilgit-Baltistan `visitgilgitbaltistan.gov.pk` (linking verified from the PTDC provincial list [S11] and KP portals [S15]).

---

## 2. Product profiles (13 dimensions)

Each profile records the 13 requested dimensions. Dimensions with no verifiable evidence are marked **Unverified** rather than inferred.

### 2.1 Google Maps

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Search and navigate for driving, walking, cycling and public transport; live-traffic routing and real-time GPS turn-by-turn navigation; Street View and Immersive View; saved-place lists that can be shared; delivery and takeout ordering; table reservations; hotel booking in-app [S1]. |
| 2 | Destination discovery | Auto-generates suggestions for food, events and activities; discovery of "250 million businesses and places" with photos and reviews; **popular times** ("see how busy a place is before you get there"); restaurant filtering by cuisine, hours, price and rating; place Q&A ("ask questions… get quick answers"); Lens in Maps for AR-style walking directions [S1]. |
| 3 | Maps/navigation | Best-route selection with live traffic, automatic rerouting on "live traffic, incidents, and road closures"; real-time public-transit and ride-share information; bike/scooter rental discovery; fuel-efficient routing; Wear OS tiles for quick search/navigation [S1]. **No** user-reporting of faults, tolls, police checkpoints or permits in the listing. |
| 4 | Trip planning | Custom lists of saved places, shareable with others; pre-trip area preview with Street View/Immersive View (parking, entrances, weather) [S1]. **No** day-by-day itinerary builder, budget planner or readiness scoring in the listing. |
| 5 | Hotels/restaurants | Books hotels and restaurants via in-app reservations; orders delivery/takeout; finds local restaurants and shops [S1]. |
| 6 | Reviews/UGC | Place reviews and photos; "500 million users contribute and keep the map up to date each year"; place Q&A answered by contributors [S1]. |
| 7 | Offline functionality | "Offline maps in an area with bad signal" [S1]. Offline scope (search, routing, business details) not described in the listing — **Unverified**. |
| 8 | Transport facilities | Public transit, ride-share, cycling/walking routes, bike/scooter rentals, fuel-efficient routes [S1]. Intercity bus/train ticket sales not claimed in the listing. |
| 9 | Safety/emergency support | Not addressed in the listing. The app states "Navigation isn't intended to be used by oversized or emergency vehicles" [S1]. No SOS, incident alerting to the user, or emergency-contact feature is claimed. |
| 10 | AI capabilities | Listing claims quick answers to place questions and Immersive View; AI branding is not used for these. Any broader AI assistant capability: **Unverified**. |
| 11 | Accessibility | Very large accessibility programme is known publicly, but the Play listing does not list specific accessibility features; **Unverified from the source used here**. |
| 12 | UX/UI | Mobile-first map with layered discovery surfaces (search, lists, Lens, Immersive View); Wear OS support [S1]. |
| 13 | Limitations for Punjab goal | Global generic coverage; no Punjab-specific regulatory content (permit/NOC guidance, DC office rates, official tariff references); no offline-resilient SMS SOS; no Pakistani price-transparency or complaint-routing features; business data for small informal Punjab facilities (dhabas, roadside mechanics) is known to be thin — **Unverified** as a measured claim. |

### 2.2 Tripadvisor

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Discovery, planning, booking and sharing in one app; Trip Cash loyalty rewards; booking across "400,000 experiences and 600,000 hotels" with 5% back [S2]. |
| 2 | Destination discovery | Nearby top-rated recommendations; editorial/community discovery; "world's largest travel community for tips and advice" [S2]. |
| 3 | Maps/navigation | Not described in the listing — **Unverified**. |
| 4 | Trip planning | Saves favourite hotels, restaurants and experiences; keeps itineraries, trip ideas and bookings in one place; "create an itinerary in seconds with top recs"; trip-tailored notifications [S2]. |
| 5 | Hotels/restaurants | Hotel and experience booking; free-cancellation on most experiences [S2]. |
| 6 | Reviews/UGC | Central product. Browse reviews; AI summaries give "a quick overview of what travelers are saying"; earn Trip Cash for planning and sharing [S2]. |
| 7 | Offline functionality | Not claimed in the listing — **Unverified**. |
| 8 | Transport facilities | Not claimed in the listing — **Unverified**. |
| 9 | Safety/emergency support | Not claimed in the listing. |
| 10 | AI capabilities | "AI summaries" of reviews [S2]. Any AI itinerary assistant: **Unverified**. |
| 11 | Accessibility | Not stated in the listing — **Unverified**. |
| 12 | UX/UI | Consumer marketplace style with loyalty programme, saved lists and notifications [S2]. |
| 13 | Limitations for Punjab goal | Review density and booking inventory for Punjab's secondary sites is generally low (unverified as a measured claim); no offline guarantees; no Pakistan-specific regulation, tariff or emergency features; rewards model tied to booking. |

### 2.3 Wanderlog

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Trip itinerary builder with route optimization, reservations, lodging comparison, flight status, collaboration, AI assistant, packing checklist, travel guides, budgeting, map view, trip journal, and import from links/images/documents/social posts [S3]. |
| 2 | Destination discovery | Global "travel guides with expert tips and recommendations" [S3]. Place search uses business details (hours, address, website, phone) and links to Google Maps/user reviews per its site metadata [S3]. |
| 3 | Maps/navigation | Map view: "Add a place, and it'll pop up on your map. Track your route and easily export it to Google Maps" [S3]. No turn-by-turn navigation of its own is claimed. |
| 4 | Trip planning | Core product: itinerary with dates, destinations, reservations and activities; automatic **route optimization**; real-time collaboration; Gmail-reservation import (site metadata) [S3]. |
| 5 | Hotels/restaurants | "Lodging — book a place to stay: we gather all suggestions in one spot and compare prices"; reservations hub for hotel/flight/other bookings [S3]. |
| 6 | Reviews/UGC | Travel guides and place information are provided; UGC is not a first-class feature — reviews are linked out rather than hosted (**Unverified** as to hosting). |
| 7 | Offline functionality | "Download your trip plan and access it anytime, even without an internet connection" [S3]. Scope excludes live re-routing — **Unverified**. |
| 8 | Transport facilities | Flight status tracking; route export to Google Maps; multimodal booking not claimed [S3]. |
| 9 | Safety/emergency support | Not claimed in the listing. |
| 10 | AI capabilities | "Ask the AI Assistant to help plan your travel or answer any questions" [S3]. |
| 11 | Accessibility | Not stated in the listing — **Unverified**. |
| 12 | UX/UI | Desktop-web-first planner with companion mobile apps; Play rating 4.7 with ~34,300 ratings and iOS 4.9 with ~33,000 ratings (as shown on the marketing page) [S3]. |
| 13 | Limitations for Punjab goal | Planner-centric; no local regulatory, safety, tariff or permit content for Pakistan; no emergency/SOS; offline limited to the saved plan; assumes users will switch to Google Maps for driving. |

### 2.4 Rome2Rio

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Multimodal transport search between any two points; AI-powered recommendations; comparison of air, rail, bus, ferry and driving options [S4]. |
| 2 | Destination discovery | Route/transport discovery rather than destination inspiration — **Unverified** beyond the listing. |
| 3 | Maps/navigation | Provides transport options and directions; in-app turn-by-turn navigation **Unverified**. |
| 4 | Trip planning | Route search and itinerary planning across transport modes; day-by-day trip planner **Unverified**. |
| 5 | Hotels/restaurants | Not a hotel/restaurant product — **Unverified**. |
| 6 | Reviews/UGC | Not claimed — **Unverified**. |
| 7 | Offline functionality | Not claimed — **Unverified**. |
| 8 | Transport facilities | Strongest dimension: compares and links to operator options across modes; fare and duration estimates [S4]. |
| 9 | Safety/emergency support | Not claimed. |
| 10 | AI capabilities | Listing states "AI-powered recommendations" for routes [S4]. Scope and behaviour **Unverified**. |
| 11 | Accessibility | Not stated — **Unverified**. |
| 12 | UX/UI | Search-first comparison interface; the marketing site returned HTTP 403 to automated fetches on the access date [S4, see Source notes]. |
| 13 | Limitations for Punjab goal | Long-distance transport planning only; Pakistan intercity operator coverage is time-dependent and unmeasured — **Unverified**; no local facilities, tariffs, safety or permit content. |

### 2.5 Visit A City

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Customized itinerary creation; comprehensive destination guides for landmarks, historical sites and "hidden gems"; browsing and booking of tours and activities (walking tours, day trips); detailed info and reviews [S5]. |
| 2 | Destination discovery | City-based guides covering must-see sights and hidden gems; download-and-explore model [S5]. |
| 3 | Maps/navigation | Maps are part of the product per its title/description ("Trip Planning, Maps, Guides"); offline functioning of the map is **Unverified** from the listing [S5]. |
| 4 | Trip planning | Central product: build a personalized, day-structured itinerary with a few taps [S5]. |
| 5 | Hotels/restaurants | Experiences and activity booking claimed; hotel and restaurant coverage **Unverified** [S5]. |
| 6 | Reviews/UGC | "Detailed information and reviews" on experiences [S5]. |
| 7 | Offline functionality | Not explicitly claimed in the listing. Third-party video reviews say the app "works offline", but this is secondary evidence — treat as **Unverified** for the current version [S5]. |
| 8 | Transport facilities | Not claimed. |
| 9 | Safety/emergency support | Not claimed. |
| 10 | AI capabilities | Not claimed (itineraries are template/customization based) [S5]. |
| 11 | Accessibility | Not stated — **Unverified**. |
| 12 | UX/UI | Guided, step-by-step planning suitable for first-time city visitors [S5]. |
| 13 | Limitations for Punjab goal | City-centric and template-driven; Punjab city coverage low/unmeasured — **Unverified**; no Pakistani regulation, safety, permit or tariff features; no transport intelligence. |

### 2.6 Sygic Travel

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | City trip planning with attractions, itineraries and maps; offline maps and guides; trip collaboration and synchronization [S6]. |
| 2 | Destination discovery | Curated city attraction databases and ready-made itineraries [S6]. |
| 3 | Maps/navigation | Offline vector maps with walking navigation and GPS positioning [S6]. |
| 4 | Trip planning | Drag-and-drop day planner with walking-time estimates between stops [S6]. |
| 5 | Hotels/restaurants | Attraction/POI data includes restaurants; hotel booking depth **Unverified** [S6]. |
| 6 | Reviews/UGC | Photo and POI content is curated from public sources; in-app user reviews **Unverified** [S6]. |
| 7 | Offline functionality | Offline maps and itinerary access are explicitly claimed [S6]. |
| 8 | Transport facilities | Walking/public-transport estimation only; intercity booking **Unverified** [S6]. |
| 9 | Safety/emergency support | Not claimed. |
| 10 | AI capabilities | Not claimed on the sources used — **Unverified**. |
| 11 | Accessibility | Not stated — **Unverified**. |
| 12 | UX/UI | Polished offline-first city planning UX; premium content tied to subscription [S6]. |
| 13 | Limitations for Punjab goal | City-break focus with limited Pakistan coverage — **Unverified**; no Pakistani regulatory, tariff, safety or complaint features; no SMS fallback. |

### 2.7 Punjab Tourism Department portal — tourism.punjab.gov.pk

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Official departmental web portal: news, development schemes, tourist destinations, booking links to TDCP tours, complaint submission, museum/archaeology links [S7]. |
| 2 | Destination discovery | Editorial listings of Punjab tourist destinations and heritage sites, cross-linked to Archaeology Department and Lahore Museum portals [S7]. |
| 3 | Maps/navigation | Not a mapping product — **Unverified**. |
| 4 | Trip planning | Not claimed on the portal — **Unverified**. |
| 5 | Hotels/restaurants | Links users to `tdcp.gop.pk` tour/resort booking [S7]. Hotel directory not claimed. |
| 6 | Reviews/UGC | Not claimed. |
| 7 | Offline functionality | None — website only. |
| 8 | Transport facilities | Not claimed. |
| 9 | Safety/emergency support | Not claimed. A special page for tourist facilitation was not verified; treat as **Unverified**. |
| 10 | AI capabilities | None claimed on the portal (AI chatbot claims apply to the departmental *app*, see 2.8) [S7, S9]. |
| 11 | Accessibility | Portal embeds a third-party accessibility widget (UserWay) [S7]. |
| 12 | UX/UI | Institutional government website with a complaint form (`/form/complain-form`) and English content [S7]. |
| 13 | Limitations for Punjab goal | No offline capability, no facility discovery at street level, no road alerts, no rate transparency, no emergency tooling; static informational content with slow update cadence — **Unverified** as a measured claim. |

### 2.8 Official Punjab app — Magnificent Punjab App (PITB)

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Official "one-stop digital experience" of Punjab: forts, shrines, fields, festivals; cultural and historical discovery [S8]. Departmental post says it "brings AR/VR tours, AI chatbot, and interactive features for travelers" [S9]. |
| 2 | Destination discovery | Curated discovery of Punjab's landmarks, shrines and festivals [S8]. |
| 3 | Maps/navigation | Not claimed in the listing — **Unverified**. |
| 4 | Trip planning | Not claimed in the listing — **Unverified**. |
| 5 | Hotels/restaurants | Not claimed in the listing — **Unverified**. |
| 6 | Reviews/UGC | Not claimed in the listing — **Unverified**. |
| 7 | Offline functionality | Not claimed — **Unverified**. |
| 8 | Transport facilities | Not claimed. |
| 9 | Safety/emergency support | Not claimed. |
| 10 | AI capabilities | Departmental social post claims an AI chatbot; scope and quality **Unverified** beyond the post [S9]. |
| 11 | Accessibility | App-store accessibility declaration not reviewed — **Unverified**. |
| 12 | UX/UI | Categorised by Play under "Productivity" despite being a travel app; last update cited on listing 29 Aug 2026 [S8]. |
| 13 | Limitations for Punjab goal | Government-facing content and promotional features; no evidence of facility directories, road intelligence, price transparency, permits, SOS or offline data. This is the closest direct incumbent and its absence of these features is the clearest signal of the gap SmartMap targets — based on listing evidence only, others **Unverified**. |

### 2.9 Official Punjab app — TDCP App

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Booking platform for TDCP resorts, tours, adventures, transport and events; secure online payments; e-tickets with seat selection on supported routes; tour packages with itineraries; luxury coach and fleet booking; event registration including Jeep Rally and Thal Desert Rally [S10]. |
| 2 | Destination discovery | Curated TDCP tour packages with detailed itineraries, inclusions, meal plans and galleries [S10]. |
| 3 | Maps/navigation | "Track map" for the active Jeep Rally event only [S10]. No general navigation. |
| 4 | Trip planning | "Built-in Trip Planner to design your own Punjab adventure"; package itineraries [S10]. |
| 5 | Hotels/restaurants | TDCP resort/hotel booking (Kalar Kahar, Patriata, Murree) with room types, rate plans, facilities, check-in policies and live room availability [S10]. No third-party restaurant directory. |
| 6 | Reviews/UGC | Not claimed — no ratings shown on the App Store listing yet ("hasn't received enough ratings") [S10]. |
| 7 | Offline functionality | Not claimed — **Unverified**. |
| 8 | Transport facilities | Books TDCP luxury coaches and fleet vehicles filtered by type, seating and AC; chairlift, cable car, boating and Softwheel Train tickets [S10]. |
| 9 | Safety/emergency support | Not claimed. |
| 10 | AI capabilities | Not claimed. |
| 11 | Accessibility | "The developer has not yet indicated which accessibility features this app supports" [S10]. |
| 12 | UX/UI | Commercial booking flow; first release 30 Apr 2026, latest 1.0.3 around 18 Nov 2026; publisher shown as Stash Technologies [S10]. |
| 13 | Limitations for Punjab goal | Transactional (sell TDCP inventory). No facility discovery beyond TDCP properties, no road alerts, no price benchmarking, no permits/NOC, no SOS, no offline data, no reviews. |

### 2.10 Pakrism

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Discovery → tour package browsing → customization → secure booking (cards, JazzCash, EasyPaisa, bank transfer) → booking management; traveler community UGC; Pakrism Pro member discounts [S12]. |
| 2 | Destination discovery | Destinations and things to do in Skardu, Hunza, Fairy Meadows, Swat, Kashmir and others; traveler photos, reviews, recommendations [S12]. |
| 3 | Maps/navigation | Not claimed — **Unverified**. |
| 4 | Trip planning | Browse and customize eligible packages; day-by-day itineraries shown pre-booking [S12]. Free-form itinerary planner not claimed. |
| 5 | Hotels/restaurants | Hotels shown as part of packages; hotel-only booking **Unverified** [S12]. |
| 6 | Reviews/UGC | Strong: upload photos, create albums, write stories, review places and tours, share recommendations, ask/answer questions [S12]. |
| 7 | Offline functionality | Not claimed — **Unverified**. |
| 8 | Transport facilities | By-air packages exist; transport-specific tools **Unverified** [S12]. |
| 9 | Safety/emergency support | Not claimed. |
| 10 | AI capabilities | Not claimed. |
| 11 | Accessibility | Not stated — **Unverified**. |
| 12 | UX/UI | Modern consumer tour-marketplace UX; last update 25 Sep 2026 [S12]. |
| 13 | Limitations for Punjab goal | Northern-Pakistan-tour-centric (Punjab content thin — listing examples are Hunza/Skardu/Swat); booking-led; no Punjab facility directory, road alerts, tariffs, permits, SOS or offline mode. Download counts shown in third-party claims (≈50K+) are **Unverified** from official store text. |

### 2.11 kptourism (KP Culture and Tourism Authority)

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | Travel planning, tour packages, attractions, points of interest, blogs, cities, events and videos with "navigational assistance"; social-media component; user profiles [S14]. |
| 2 | Destination discovery | "Rapidly discover nearby attractions"; recommend based on user ratings, blogs, images, related attractions and must-do activities [S14]. |
| 3 | Maps/navigation | "Navigational assistance" claimed; depth and offline behaviour **Unverified** [S14]. |
| 4 | Trip planning | "Plan your trip while sitting at home or even on the go"; packages [S14]. |
| 5 | Hotels/restaurants | Hotels are a content category; App Store review from 2019 notes only one hotel shown for Naran/Swat (secondary, dated) [S14]. |
| 6 | Reviews/UGC | Ratings, photos, follow other tourists, personal profile, "make your own contributions" [S14]. |
| 7 | Offline functionality | Not claimed — **Unverified**. |
| 8 | Transport facilities | Not claimed. |
| 9 | Safety/emergency support | Not claimed, but version notes record a **"Foreign tourist registration feature added"** in v20.0.1 (Dec 2024) [S14] — the only official Pakistani tourism app found with a foreigner-registration flow. |
| 10 | AI capabilities | Not claimed. |
| 11 | Accessibility | "The developer has not yet indicated which accessibility features this app supports" [S14]. |
| 12 | UX/UI | Best industry UX was praised in early ratings ("nice and looks simple and attractive") but early reviews also reported slow loading and email-verification problems; rating 4.1 from 9 ratings [S14]. |
| 13 | Limitations for Punjab goal | KP-scoped; no Punjab facilities, permits, tariffs or road alerts; no offline mode; thin maintenance cadence visible (last iOS update Jan 2025) [S14]. |

### 2.12 Federal — PTDC / Salam Pakistan portal

| # | Dimension | Findings |
|---|-----------|----------|
| 1 | Main features | National tourism brand and facilitation e-portal: planning information, visitor guidance, and partner listings across Pakistan [S16, S17]. |
| 2 | Destination discovery | National destination information and provincial directories linking to official provincial sites (including TDCP for Punjab) [S11, S16]. |
| 3 | Maps/navigation | Not a mapping product — **Unverified**. |
| 4 | Trip planning | Pre-trip guidance (e.g., arrival/entry requirements) rather than itinerary building [S17]. |
| 5 | Hotels/restaurants | Directory-style listings — depth **Unverified**. |
| 6 | Reviews/UGC | Not claimed. |
| 7 | Offline functionality | None (web portal). |
| 8 | Transport facilities | Guidance pages (e.g., "Getting to Pakistan") rather than transport search [S18]. |
| 9 | Safety/emergency support | Not claimed. Notably, the portal states all travellers must submit contact and travel information via the **Pass Track** app [S18] — a separate government app for entry tracking. |
| 10 | AI capabilities | None claimed. |
| 11 | Accessibility | Not stated — **Unverified**. |
| 12 | UX/UI | Federal portal; primarily informational. |
| 13 | Limitations for Punjab goal | National-level and informational; no offline, no road intelligence, no facility-level data, no tariff transparency, no emergency features. |

---

## 3. Not verified / excluded

| Candidate | Status | Reason |
|-----------|--------|--------|
| `tdcp.gop.pk` website | **Not verified** | Page did not load within the fetch limit on 2026-11-21 (timeout). Domain itself is confirmed via PTDC and the Punjab department site [S7, S11]. |
| Rome2Rio website (`rome2rio.com`) | **Not verified directly** | Returned HTTP 403 to automated fetching; features transcribed from its Play listing [S4]. |
| Visit A City website/FAQ (`visitacity.com`) | **Not verified directly** | Returned HTTP 403; features transcribed from its Play listing [S5]. |
| "DigiBook – Tourism digitized", "Discover Pakistan", "Ghoomo Phiroo Pakistan", "Pakistan Places & Wildlife" | **Excluded (unverified)** | Seen only as "You might also like" suggestions on store pages [S14]; no independent verification of identity, ownership or feature set was performed. |
| Pass Track (Government of Pakistan) | **Noted, not profiled** | Mentioned on the Salam Pakistan portal as mandatory entry tooling [S18]; scope outside tourism-companion comparison. |
| Official Sindh / Balochistan / AJK / GB apps | **Excluded (unverified)** | Provincial portals confirmed but no app listings verified. |
| Google Maps accessibility feature list | **Unverified** | Not present on the Play listing used [S1]. |

---

## 4. Competitor feature comparison matrix

Legend: **Y** = claimed by the product's own verified source; **–** = not claimed (absence is not proof the feature does not exist); **U** = Unverified; **N/A** = not applicable to product type.

| Dimension | Google Maps | Tripadvisor | Wanderlog | Rome2Rio | Visit A City | Sygic Travel | Punjab Dept site | Magnificent Punjab | TDCP App | Pakrism | kptourism | PTDC/Salam PK |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Main purpose | Navigation + local discovery | Reviews + booking | Itinerary planner | Transport search | City itineraries | Offline city planner | Info portal | Official Punjab showcase | Official Punjab booking | Tour marketplace + UGC | Official KP tourism | National facilitation |
| Destination discovery | Y [S1] | Y [S2] | Y [S3] | U | Y [S5] | Y [S6] | Y [S7] | Y [S8] | Y [S10] | Y [S12] | Y [S14] | Y [S16] |
| Maps/navigation | Y [S1] | U | Map + export [S3] | U | U | Y [S6] | – | – | Rally track map [S10] | – | "Navigational assistance" [S14] | – |
| Trip planning | Lists only [S1] | Y [S2] | Y [S3] | U | Y [S5] | Y [S6] | U | U | Trip Planner [S10] | Y (packages) [S12] | Y [S14] | – |
| Hotels/restaurants | Y [S1] | Y [S2] | Lodging compare [S3] | U | U | U | Links to TDCP [S7] | – | TDCP resorts [S10] | In packages [S12] | Hotels category [S14] | U |
| Reviews/UGC | Y [S1] | Y [S2] | – (links out) | U | Y [S5] | U | – | – | – | Y [S12] | Y [S14] | – |
| Offline functionality | Offline maps [S1] | U | Plan download [S3] | U | U | Y [S6] | – | – | – | – | – | – |
| Transport facilities | Y [S1] | U | Flight status [S3] | Y [S4] | – | – | – | – | Coaches/fleet/tickets [S10] | U | – | Guidance only [S18] |
| Safety/emergency | – [S1] | – | – | – | – | – | – | – | – | – | Foreigner registration [S14] | – |
| AI capabilities | Q&A answers [S1] | Review summaries [S2] | AI Assistant [S3] | Route AI [S4] | – | U | – | AI chatbot (post) [S9] | – | – | – | – |
| Accessibility declared | U | U | U | U | U | U | Widget [S7] | U | "not indicated" [S10] | U | "not indicated" [S14] | U |
| Live road/incident info | Traffic/incidents in routing [S1] | – | – | – | – | – | – | – | – | – | – | – |
| Facility finder (street-level) | Y [S1] | Y (venue-level) [S2] | – | – | – | POIs | – | – | – | – | – | – |
| Price transparency/tariffs | – | – | – | Fares | – | – | – | – | TDCP rates | Package prices | – | – |
| Permit/NOC guidance | – | – | – | – | – | – | – | – | – | – | – | – |
| SOS / emergency contacts | – | – | – | – | – | – | – | – | – | – | – | – |
| Complaints channel | – | – | – | – | – | – | Web form [S7] | App/site form [S7] | – | UGC | Feedback [S14] | – |
| Offline/SMS fallback | – | – | – | – | – | – | – | – | – | – | – | – |
| Readiness/freshness scoring | – | – | – | – | – | – | – | – | – | – | – | – |

---

## 5. Feature availability analysis

### a) Features available in multiple apps (table stakes for SmartMap Punjab)

These are broadly present, so their absence in SmartMap would be a visible shortfall, and their delivery quality matters more than existence.

1. **Destination/destination-detail discovery** — Google Maps [S1], Tripadvisor [S2], Wanderlog [S3], Visit A City [S5], Sygic [S6], Punjab dept site [S7], Magnificent Punjab [S8], TDCP [S10], Pakrism [S12], kptourism [S14], PTDC [S16].
2. **Saved places / favourites / lists** — Google Maps [S1], Tripadvisor [S2], Wanderlog [S3].
3. **Some form of itinerary or trip organisation** — Tripadvisor [S2], Wanderlog [S3], Visit A City [S5], Sygic [S6], TDCP [S10], Pakrism [S12] (SmartMap already has a trip planner).
4. **Hotel/lodging surfaced inside the app** — Google Maps [S1], Tripadvisor [S2], Wanderlog [S3], TDCP [S10].
5. **Reviews or ratings as discovery input** — Google Maps [S1], Tripadvisor [S2], Visit A City [S5], Pakrism [S12], kptourism [S14].
6. **Offline access to something** (maps or plans) — Google Maps [S1], Wanderlog [S3], Sygic [S6].
7. **AI assist of some kind** — Google Maps (answers) [S1], Tripadvisor (review summaries) [S2], Wanderlog (assistant) [S3], Rome2Rio (route AI) [S4].
8. **Some form of user feedback/complaint channel** — Punjab department complaint form [S7], kptourism feedback link [S14].

### b) Features available in only some apps

1. **Multimodal long-distance transport comparison** — Rome2Rio is purpose-built [S4]; Google Maps covers local transit/ride-share [S1]. Not offered by Pakistani tourism apps reviewed.
2. **Offline city maps with walking navigation** — Sygic [S6] and Google Maps [S1]; Wanderlog only caches plans [S3].
3. **Real-time incident/closure-aware routing** — Google Maps [S1] only.
4. **Loyalty/rewards tied to booking** — Tripadvisor [S2].
5. **Route optimisation and collaborative planning** — Wanderlog [S3].
6. **Package customization with Pakistani payment rails (JazzCash, EasyPaisa)** — Pakrism [S12].
7. **Foreign-tourist registration flow** — kptourism (v20.0.1, Dec 2024) [S14]. Federal Pass Track is separate [S18].
8. **Official in-app tour-and-resort transaction system for Punjab** — TDCP App [S10].
9. **AR/VR tours and AI chatbot as a stated public-sector deliverable** — Magnificent Punjab (departmental post) [S9].
10. **Government complaint intake at department level** — Punjab department form [S7].

### c) Features missing from SmartMap Punjab today (relative to planned scope)

SmartMap Punjab already has: 81-city Punjab guide, trip planner, budget calculator, bill splitter, taxi fare estimator, reviews, favourites, events, business listings.

Planned scope from the master prompt that **no verified competitor** provides (or provides only in an unusable form for Punjab), and that is not in the current SmartMap feature list:

| Planned capability | Closest verified competitor analogue | Gap assessment |
|---|---|---|
| Facility finder (toilets, petrol, tyre shops, mechanics, medical) | Google Maps business search [S1] | Competitor is global/generic, not curated for tourist routes; no facility verification or freshness signal. |
| Road alerts (closures, landslides, construction, checkpoints) | Google Maps live traffic and incidents [S1] | Google covers incidents via routing; local access restrictions and tourist-relevant closures are not a packaging competitors offer. |
| Travel reality check (realistic time/cost/condition expectations) | None verified | Only generic route estimates exist. |
| DC rate lists / official tariff transparency | None verified | TDCP publishes its own rates [S10]; nothing presents DC or official rate notifications for hotels/boats/guides. |
| Permit / NOC guidance | None verified | No competitor covers provincial permits or site NOCs. |
| Foreigner toolkit | kptourism foreigner-registration [S14] | Single-purpose registration only; not a composite toolkit (permits, currency, etiquette, emergency). |
| Digital tourist pass | kptourism registration [S14] | Digital QR/ID-style passes for tourist sites not verified in any product. |
| Complaints (with routing/tracking) | Punjab dept web form [S7] | Web form only; no app-level status tracking or facility targeting. |
| Highway stops directory | Google Maps POI search [S1] | Not curated as an intercity route-stops layer. |
| SOS SMS fallback | None verified | No competitor offers offline, SMS-based emergency messaging. |
| Journey Readiness Score | None verified | No scoring concept exists in any reviewed product. |
| Facility Freshness Score | None verified | Google Maps has contributor updates [S1] but no explicit per-facility freshness scoring. |
| Women/family safety mode | None verified | Not present in any reviewed product. |

Conclusion: most of SmartMap Punjab's differentiators sit in territory with **no verified incumbent**, which argues for prioritising them, while table-stakes items (discovery, reviews, saved lists, offline basics) must match baseline expectations set by Google Maps and Tripadvisor.

### d) Features that solve specific Pakistani tourism problems

| Pakistani problem | Evidence that the problem is recognised | Closest competitor handling |
|---|---|---|
| Tourists arriving without permits/registration knowledge | kptourism adds in-app foreign-tourist registration [S14]; PTDC requires Pass Track information [S18] | Single-flow registration; no guidance on multiple permits |
| Unverified facility conditions (toilets, water, fuel) on intercity routes | None explicitly | Google Maps POIs [S1]; no freshness verification |
| Price exploitation (taxi, boats, guides) | None explicitly | SmartMap's own taxi estimator is already ahead |
| Road closures/landslides on mountain and highway routes | Google Maps incident-aware routing [S1] | Generic, not Punjab-specific |
| Unreliable official information/discovery | Punjab dept portal and Magnificent Punjab app are content-heavy [S7, S8]; TDCP app is transactional [S10] | Both official products omit user-facing facility/road/price/safety tooling |
| Safety incidents with no signal | No competitor offers SMS fallback — **no source claims it exists anywhere** | Completely unclaimed territory |
| Low review density for Punjab's small sites | Pakrism [S12] and kptourism [S14] focus on northern Pakistan | Punjab secondary-site review gap remains |
| Complaints that go nowhere | Punjab dept separates web complaints from its app [S7, S8] | No tracked in-app complaint routing |

### e) Potential differentiating features for SmartMap Punjab

Ranked by strength of differentiation against the verified field, and by fit with existing Punjabi pain points:

1. **SMS-based SOS fallback** — no competitor claims it; uniquely valuable where mobile data fails on highway and hilly stretches.
2. **Facility Freshness Score + verification workflow** — counters the reliability weakness of Google Maps POIs [S1] and the absence of facility tooling in Pakistani apps [S7, S8, S10].
3. **Journey Readiness Score** — turns static planning into pre-departure risk appraisal; no analogue anywhere in the reviewed set.
4. **DC rate list / official tariff transparency** — direct answer to price exploitation; TDCP app only shows its own prices [S10].
5. **Permit and NOC guidance** — complements kptourism's registration feature [S14] with actionable steps for multiple permits/sites.
6. **Digital tourist pass** — no verified analogue; natural companion to permit guidance.
7. **Travel reality check** — converts route estimates (Rome2Rio [S4], Google Maps [S1]) into honest expected experience, which no product packages.
8. **Road alerts with community confirmation** — builds on known Google Maps incident routing [S1] but layers local, off-map knowledge.
9. **Highway stops directory** — differentiated by curation (fuel, washrooms, food, mechanics) along named routes rather than generic POI search.
10. **Complaint routing with tracking** — improves on the Punjab department's un-linked web form [S7].
11. **AI travel companion anchored in SmartMap data** — competes with Wanderlog's assistant [S3] and Tripadvisor's summaries [S2] but grounds answers in official rates, facility freshness and alerts, which those products do not have.
12. **Women/family safety mode** — no competitor claims it; high perceived value for domestic travellers.

**Positioning implication.** Against Big Tech, SmartMap cannot win on map data or POI volume (Google Maps claims 250M places [S1]); against Pakistani official apps, it can win on *usefulness* because those products are either informational [S7, S8] or transactional [S10]. The defensible position is **trustworthy, Punjab-specific operational intelligence**: fresh facilities, honest prices, real road conditions, permits made simple, and safety tooling that works without data.

---

## Sources

All accessed **2026-11-21**.

| ID | Source | URL |
|----|--------|-----|
| S1 | Google Maps — Google Play listing (Google LLC), updated 2026-11-18 | https://play.google.com/store/apps/details?id=com.google.android.apps.maps |
| S2 | Tripadvisor: Plan & Book Trips — Google Play listing, updated 2026-11-19 | https://play.google.com/store/apps/details?id=com.tripadvisor.tripadvisor |
| S3 | Wanderlog — official website (feature tabs and site metadata) | https://wanderlog.com/ |
| S4 | Rome2Rio — Google Play listing (website rome2rio.com returned 403) | https://play.google.com/store/apps/details?id=com.rome2rio.rome2rio |
| S5 | Visit A City — Google Play listing, updated 2026-10-12 (website visitacity.com returned 403) | https://play.google.com/store/apps/details?id=com.visitacity.visitacityapp |
| S6 | Sygic Travel — official website / product pages | https://travel.sygic.com/ |
| S7 | Tourism, Archaeology and Museums Department, Government of the Punjab — official portal | https://tourism.punjab.gov.pk/ |
| S8 | Magnificent Punjab App — Google Play listing (`pk.pitb.gov.magnificentPunjab`), updated 2026-08-29 | https://play.google.com/store/apps/details?id=pk.pitb.gov.magnificentPunjab |
| S9 | Department of Tourism Punjab — official Facebook post describing Magnificent Punjab App AR/VR tours and AI chatbot | https://www.facebook.com/DepttTourism/posts/1301437978771750/ |
| S10 | TDCP App — Apple App Store listing (`id6763981273`), version 1.0.3 | https://apps.apple.com/us/app/tdcp/id6763981273 |
| S11 | Pakistan Tourism Development Corporation — provincial tourism directory (lists TDCP / Tourism Development Corporation Punjab and other provinces) | https://tourism.gov.pk/ |
| S12 | Pakrism — Google Play listing (`com.pakrism`), updated 2026-09-25 | https://play.google.com/store/apps/details?id=com.pakrism |
| S13 | Pakrism — official website | https://pakrism.pk/ |
| S14 | kptourism — Apple App Store listing (`id1470219062`), version history through 20.0.3 | https://apps.apple.com/us/app/kptourism/id1470219062 |
| S15 | Khyber Pakhtunkhwa Culture and Tourism Authority portal / KP Culture, Tourism & Archaeology | https://kptourism.com/ , https://tca.kp.gov.pk/ |
| S16 | PTDC official website (Salam Pakistan brand) | https://tourism.gov.pk/ |
| S17 | Salam Pakistan — official tourism facilitation e-portal | https://salampakistan.gov.pk/ |
| S18 | Salam Pakistan — "Getting to Pakistan" (Pass Track requirement) | https://www.salampakistan.gov.pk/planning/getting-here |

Additional pages consulted for domain verification: `tdcp.gop.pk` (did not load — timeout), `archaeology.punjab.gov.pk`, `lahoremuseum.punjab.gov.pk`, `dts.punjab.gov.pk` (linked from S7).
