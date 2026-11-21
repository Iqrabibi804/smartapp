# Pakistan Tourist Problems: Evidence Base for SmartMap Punjab

**Phase 1 research deliverable (§4.2 of `docs/MASTER_PROMPT.md`)**
**All sources accessed: 2026-11-21.** Source numbers in brackets refer to the numbered **Sources** list at the end of this document.

---

## 0. Scope, method and how to read this document

This document sets out twenty recurring problems reported by tourists travelling in Pakistan — with emphasis on the Punjab hill corridors (Murree, Galyat, Soon Valley), the Kaghan–Naran valley and the northern routes that Punjab tourists use to reach Gilgit-Baltistan (KKH, Babusar Top/N15, Lowari Tunnel, Khunjerab Pass) — together with the software interventions SmartMap Punjab can realistically deliver.

**Evidence standard used here**

- Every factual claim is tied to a numbered source. Where only a headline or search-result snippet could be read (some Pakistani news sites block automated retrieval), this is stated plainly.
- No statistic, incident, fare or permit rule has been invented. Prices quoted from sources are quoted as reported by that source and are **not** treated as current official rates.
- Where the evidence is thin, the problem is still described qualitatively and marked **Thin evidence** instead of being dressed up with numbers.
- Official provincial/agency web sources (GB Tourism Department, DTS Gilgit-Baltistan, NHA, NHMP, NDMA, PTDC, Punjab Tourism, TDCP) were checked for the existence of live operational data (road status, rates, complaint tracking). Findings are reported as observed on 2026-11-21, not as permanent facts.

**Region and season conventions**

- *Punjab hill corridors:* Murree, Galyat (Nathia Gali, Dunga Gali), Soon Valley, Fort Munro.
- *Kaghan–Naran:* Mansehra district, Khyber Pakhtunkhwa; the valley is the standard onward route for Punjab travellers heading north.
- *Northern routes:* KKH (N35), N15 Chilas–Babusar, Lowari Tunnel (N45), Khunjerab Pass (N35), Deosai, Hunza, Skardu.
- *Seasons:* monsoon (roughly late June to early October per FCDO [2]); winter (snowfall, Babusar closure); summer peak and Eid holidays (overcrowding).

---

## 1. Unreliable, fragmented road information

**Problem.** Travellers cannot find a single, authoritative, time-stamped answer to "is this road open right now?" Information is scattered across ministry advisories, district administration announcements, police social media, TV/press and word of mouth. Highway authorities publish project and monitoring data, not live road status.

**Who it affects.** Families driving from Lahore/Islamabad to northern valleys; tour operators planning itineraries; foreign tourists deciding whether to risk the KKH. Punjabi tourists dominate traffic into Murree and Kaghan, so a bad road decision is typically made hours from home with no clean-up plan.

**Evidence**

- The National Highway Authority (NHA) states it maintains 39 highways, motorways and expressways totalling about 12,131 km — only 4.6% of national road length — and its public portals are for project monitoring, not live road-condition reporting [9].
- The National Highways & Motorway Police (NHMP) tells travellers to consult Facebook, X (@NHMPofficial), a web travel-advisory page, FM 95 radio and helpline 130 **before** starting a journey — i.e., multiple separate channels with no combined real-time feed [7].
- FCDO notes that in Pakistan "roads, including major routes, may be blocked or closed without warning" [2].

**Regions/seasons.** KKH, N15, Babusar, Lowari; monsoon and winter hardest.

**Software interventions.** Travel Reality Check screen per road segment with six statuses (Open / Closed / Restricted / Landslide reported / Weather warning / Information unavailable), each carrying source agency, publication time and validity window; mandatory "Information unavailable" state instead of assumed Open; link-out to NHMP/NDMA channels; cached last-known status clearly labelled with age.

---

## 2. Landslides and sudden road closures

**Problem.** Monsoon rains and slope instability close highway sections with little warning, strand travellers and sometimes cut communications entirely.

**Who it affects.** Anyone driving KKH, N15/Babusar, Kaghan–Naran and Lowari; passengers in buses and shared vans; families with children and elderly travellers; foreign tourists without local contacts.

**Evidence**

- GB Tourism Department advisory, 16 July 2025 (09:34): "Heavy monsoon rains have triggered multiple landslides along the Karakoram Highway (KKH) … Tatta Pani region, where massive debris flow has severely blocked the highway, stranding several passenger vehicles on both sides", with a "Public Advisory: Avoid travel on KKH until further notice" [4].
- GB Tourism Department advisory, 22 July 2025 (20:17): the Deputy Commissioner Diamer declared an emergency on the Thak–Babusar road; the advisory reports "extensive road blockages", vehicles "swept away by floodwaters", "several tourists reported missing", "families stranded", that "due to the breakdown of communication infrastructure … many tourists have lost contact with their families", and that "over 200 tourists have been safely rescued"; Babusar Road was "officially closed to all types of traffic" [5].
- Pakistan's Press Information Department published (reported 2026-08-04) an NHA "urgent advisory" after flash floods at Thak, stating the Babusar Highway was "completely closed to all vehicular" traffic [11] — headline-level evidence only.
- FCDO: "All sections of the Highway north of Battagram up to the Chinese border have experienced landslides"; "Landslides frequently block or destroy roads" [2].
- A peer-reviewed survey of 500 visitors to Kaghan Valley recorded roads "blocked for several hours due to heavy traffic", roads made "slippery and more dangerous" by snow and glaciers, and travellers unfamiliar with the area suffering most during rain, snow and road blockages [6].

**Regions/seasons.** KKH (whole length north of Battagram), N15/Babusar, Kaghan–Naran; monsoon June–October; winter snow [2][4][5][6].

**Software interventions.** Road alert module with "Landslide reported" and "Closed" states; alternative-route suggestions (e.g., KKH vs Babusar vs Lowari) with caveats; offline decision prompts ("If communication is lost, see offline emergency card"); family-notification helper that generates a status message (SMS fallback with honest delivery reporting).

---

## 3. Poor road infrastructure: narrow, unfenced, dangerous

**Problem.** Many tourist roads are narrow, unbarriered along rivers and dangerous in wet or icy conditions. Safety is a design problem, not only a closure problem.

**Who it affects.** Self-driving families, especially those unfamiliar with mountain driving; jeep passengers on tracks to lakes and meadows; tourists with children.

**Evidence**

- Kaghan Valley visitor survey (n=500): roads are "very poor, narrow and dangerous"; remote destinations "are not accessible"; "There is no safety along the roads in the form of fencing or barriers, especially on the river sides. So, in case of any mishap, survival is very difficult"; roads become "slippery and more dangerous" due to snow and glaciers [6].
- FCDO advises that the KKH section from Mansehra to Chilas via Battagram, Besham, Dasu and Sazin should be avoided in favour of N15, i.e., even the official-outside advice is to reroute around known hazards [2].

**Regions/seasons.** Kaghan Valley, KKH, mountain jeep tracks; year-round, worse in monsoon and winter.

**Software interventions.** "Road risk notes" per segment (fence/barrier absent, single-track, river edge) populated only from labelled sources; jeep-track hazards shown before users request jeep directions; dark-mode night-driving reminder; SOS integrated with nearest rescue point (Rescue 1122, Tourist Police).

---

## 4. Limited internet and mobile coverage

**Problem.** Mobile data and voice coverage is weak or absent in valleys, at lakes and on passes — precisely where tourists need maps, prices and emergency help.

**Who it affects.** Every traveller using maps or booking apps; families trying to report their location; foreign tourists without a local SIM; women travelling in groups relying on live tracking.

**Evidence**

- Kaghan Valley survey: visitors report ATMs, bank cash, Wi-Fi, internet and mobile signals as problems; "due to the unavailability of the internet, it is difficult for them to explore the valley and move around and similarly, they cannot contact back with their families due to lack or poor mobile signals" [6].
- The GB District Tourism Services page requires online application at its portal and cites multi-week processing, an assumption of connectivity that is not reliably present at destination [3].
- FCDO warns that "mobile data may be cut without warning" in relevant regions [2].
- GSMA reports that 52% of Pakistanis live under mobile broadband coverage but do not use it — a usage gap that shapes realistic design for low-bandwidth users [13].
- A commercial travel-SIM guide describes Skardu as having "moderate" coverage and weak coverage near lakes [15] (**commercial source; thin/indirect evidence**).

**Regions/seasons.** Hunza, Skardu, Deosai, Naran–Babusar, side valleys; outages also occur during monsoon damage and official restrictions [2][5].

**Software interventions.** Offline-first architecture (Hive cache with TTL, last-synced timestamps, online/offline banner, background sync); downloadable "trip packs" per destination (facilities, contacts, rates, road notes, emergency card); SMS-based SOS fallback; map tiles cached for selected route corridors; every cached fact shows its age and source.

**Thin evidence note.** No public, destination-level coverage dataset from PTA/operators could be found; coverage claims here are qualitative.

---

## 5. Unreliable hotel availability and pricing

**Problem.** (a) Many guesthouses and hotels in valleys cannot be booked online and have no systematic reservation process; (b) prices swing sharply with season and Eid holidays, and official rate lists, where they exist, are not adhered to.

**Who it affects.** Families booking in advance; budget travellers; foreign tourists who cannot call local numbers; walk-in arrivals during peak weekends.

**Evidence**

- Kaghan Valley survey: "There are very few hotels in the valley offering online reservations. The rest of the hotels receive walk-in guests only because they do not have any systematic procedure of reservations"; "During the peak season, some tourists spend their nights on the roads"; "A room normally having a rent of Rs.2000 is sold @ Rs.15,000 to Rs. 20,000 per night in the valley during the season"; "There is no check and balance for the prices by the local administration" [6].
- TCKP *Kaghan* booklet lists hotels and rates but explicitly warns rates are "subject to seasonal fluctuations" with a "possibility of plus minus in the rates mentioned in the hotel list" [14].
- PTDC states on its tour-packages page that "All PTDC Motels are closed", i.e., one historical public accommodation network is no longer available [10].
- Express Tribune, 25 April 2023: after last year's Murree incident, "the government hotel fare system has not been implemented to date"; the Additional Deputy Commissioner said "the administration does not have any framework to force the hotel owners to charge less" [17].

**Regions/seasons.** Kaghan/Naran, Murree, Hunza, Skardu; peak Eid and July–August weekends worst.

**Software interventions.** Accommodation directory with explicit data-quality fields (contact verified date, price range reported by, "online booking available: yes/no/unknown"); "call to confirm" workflow with cached phone numbers and a scratchpad; comparison of reported price vs DC official rate when one is published; honest "freshness" badges; no invented star ratings.

---

## 6. Taxi, jeep and transport overcharging

**Problem.** Transport operators and parking contractors charge far above posted fares, and for hire-jeeps on poor tracks the price depends on road condition.

**Who it affects.** Tourists without local bargaining knowledge; families arriving at terminal points (Murree, Balakot, Naran); foreign tourists told to avoid street taxis altogether but given no fare benchmark.

**Evidence**

- Express Tribune, 5 October 2020: at Patriyata chairlift, TDCP had posted parking rates (Rs150 coaster/bus, Rs100 van/jeep, Rs70 car, Rs30 motorcycle) but contractors charged "more than double"; agents sold chairlift tickets at a premium; "for merely a boat ride, contractors asked for Rs4,000 to Rs6,000" at Khanpur Dam; a TDCP manager acknowledged "several local groups … are operating like mafias" [18].
- Kaghan Valley survey reports jeep owners demanding high fares "due to poor roads" and unskilled jeep drivers [6].
- FCDO instructs foreign visitors: "Avoid using street taxis, e-taxis. or online apps for taxi services" [2].
- Dawn reported (2026-06-04, snippet level) that special traffic-police squads were established in Murree to check transporters charging excessive fares [16].
- APP reported a DC Murree warning to transporters against non-compliance with prescribed policy (snippet level) [20].

**Regions/seasons.** Murree, Naran/Balakot, Khanpur, tourist lakes; every season, worst at Eid and public holidays.

**Software interventions.** Taxi fare estimator (distance × per-km band) **labelled as an estimate**, with "official rate" shown only when a verified government source exists; jeep/4x4 fare estimator with route-condition caveat; DC official rate list viewer; report flow for overcharging that drafts a complaint with time, place, operator plate and photo — clearly labelled as **not** an official submission.

**Thin evidence note.** Overcharging is documented in press reports and visitor surveys but no public statistics exist on frequency or amounts.

---

## 7. Missing tourist information and signboards

**Problem.** There is little consolidated, practical information about destinations: no tourist information centres on many routes, few signboards, and no professional guides.

**Who it affects.** First-time visitors, domestic tourists taking families, and foreigners who cannot rely on locals understanding English.

**Evidence**

- Kaghan Valley survey: visitors report "no tourist information centre, no professional/educated guides, lack of signage" [6].
- Punjab Tourism's public site describes districts and events and points to a complaint form, but no per-destination operational information (road status, facilities, rates) was observed on 2026-11-21 [12].
- PTDC's *Salam Pakistan* e-portal was observed as promotional/event content rather than live operational data on 2026-11-21 [10].

**Regions/seasons.** Kaghan–Naran, Galyat, Soon Valley, KKH towns; year-round.

**Software interventions.** Destination pages with verified descriptions, coordinates, hours, facilities, price info, "data source" and "last updated"; offline city/destination packs; transliteration for place names; signposts "where to ask" (DC office, Tourist Police).

---

## 8. Lack of clean washrooms

**Problem.** Public washrooms are scarce, dirty and rarely suitable for women and children.

**Who it affects.** Women and children travelling long routes, elderly travellers, pilgrims, and foreign tourists.

**Evidence**

- Kaghan Valley survey: "There are very few public washrooms in the valley from Balakot to Babusar top. While travelling, females and children face a lot of washroom problems"; people use open areas and riversides, contaminating water; hotel washrooms also criticised; "Most of the visitors have pointed out the non-availability of public washrooms, especially for females" [6].

**Regions/seasons.** Balakot–Babusar, KKH towns, motorway-adjacent tourist roads; all seasons, worst at peak Eid.

**Software interventions.** Facility finder for washrooms with **verification status** (community-suggested / verified-by-admin / last verified date), amenities (women's, family, accessible), user-reported cleanliness within a recency window; no facility shown as "verified" without admin verification; offline cached facility lists per corridor.

---

## 9. Clean drinking water

**Problem.** Clean drinking water is not reliably available in valleys or in many hotels/restaurants, and contamination is aggravated by open defecation near rivers.

**Who it affects.** Families with children, tourists with health conditions, foreign visitors without trusted local advice.

**Evidence**

- Kaghan Valley survey: "there is no clean drinking water available in the valley and in the hotels"; open defecation contaminates the river from which local residents and riverside communities fetch drinking water; cleanliness of hotels/restaurants also criticised [6].
- Express Tribune (2020) reported at a Punjab hill resort that water tankers were sold for Rs1,500–2,000 each, pushing up the cost of tourist services [18].

**Regions/seasons.** Kaghan, KKH side valleys, Deosai; year-round.

**Software interventions.** Drinking-water points in facility finder with verification status; "safe water" guidance in destination packs (boil/filter advice — generic guidance, not medical advice); report flow for unsanitary facilities.

---

## 10. Limited medical facilities

**Problem.** Healthcare facilities in valleys are minimal; emergencies require evacuation to tehsil or district hospitals hours away.

**Who it affects.** Families with children, elderly travellers, asthmatics/diabetics, accident victims, foreign tourists.

**Evidence**

- Kaghan Valley survey: "in the valley, there are no worth mentioning healthcare centres"; emergencies and first aid are limited and patients "are referred to Tehsil Headquarter Hospital Balakot, where after first aid, the patient is referred to Mansehra or Abbottabad for further treatment if needed" [6].
- GB Tourism advisory helplines list Rescue 1122 for general emergencies and a Tourist Police number for GB [4].

**Regions/seasons.** Kaghan–Naran, Babusar, KKH, Deosai; year-round, worst when passes are blocked.

**Software interventions.** Facility finder for hospitals, BHUs, pharmacies and first-aid posts with verification status and hours; hospital list embedded in offline trip packs per corridor; SOS screen showing nearest facility, evacuation path and ambulance numbers (numbers verified for coverage before displaying as nationwide).

---

## 11. Petrol and fuel availability

**Problem.** Fuel supply is unreliable in peak season and at remote points; shortages are reported during Eid surges.

**Who it affects.** Self-driving tourists, motorcyclists, jeep operators, buses.

**Evidence**

- Kaghan Valley survey: during Eid, "there is a shortage of meals and fuel" in the valley; visitors also complain about "high prices of accommodations, meals, petrol, and transport fares" [6].
- The same survey notes emergency situations in which "sometimes army helps the victims by providing safe passages" — indicating capacity limits rather than fuel services [6].

**Regions/seasons.** Kaghan/Naran, Babusar approach, KKH; Eid and July–August; winter closures on Babusar.

**Software interventions.** Highway essentials finder listing fuel stations with brand, opening hours and verification date; "last fuel before pass/gap" markers; community reports on fuel availability with timestamps; cached list in offline trip packs; no live price claims unless sourced.

**Thin evidence note.** No official fuel-supply dataset was located; evidence is visitor-reported.

---

## 12. Women's travel safety concerns

**Problem.** Women and mixed-family groups report discomfort linked to inadequate privacy facilities, unsafe parking, theft fears and inconsistent security support. Information tailored to women is scarce.

**Who it affects.** Women travelling without male relatives, mother-and-children groups, foreign women travellers.

**Evidence**

- Kaghan Valley survey: lack of washrooms "especially for females"; families report feeling insecure because of dangerous roads, unsafe parking, a hotel theft case, and "the negative role of the police"; "due to this attitude of the locals, tourists, and the police … some of the visitors having families with them specially"; and overcrowded Eid periods where "families … cut short their visit and return in distress" [6].
- FCDO advises foreign nationals to register with local authorities when visiting Gilgit-Baltistan and to avoid street taxis [1][2] — safety guidance that is useful but not women-specific.

**Regions/seasons.** Kaghan, Murree, KKH towns; Eid and weekend peaks.

**Software interventions.** Women & family mode toggle: filter to family-friendly attractions, women-friendly washrooms (verified), nearby hospitals, emergency contacts; "travel with family" checklist; no claims of "safe area" status — only source-backed facts and clear "information unavailable" states.

**Thin evidence note.** No Pakistan-specific public statistics on harassment or assault of women tourists were located; this section is qualitatively grounded only. Do not present any "safety score" as evidence-based.

---

## 13. Family-friendly facilities (and attractions for children)

**Problem.** Many destinations lack recreational facilities for children, rest areas and family-appropriate accommodation, making trips with young children exhausting.

**Who it affects.** Parents with young children, grandparents, large family groups.

**Evidence**

- Kaghan Valley survey: "there are no recreational facilities available in the valley for children as well as for elders. There are no playgrounds or play lands, parks, zoos and other places for recreational activities"; families report children "in their laps" suffering during travel; lack of variety in food [6].
- Express Tribune (2023): Eid crowds with families and reports of price surges hitting household budgets [17].

**Regions/seasons.** Kaghan–Naran, Murree, Galyat; summer and Eid.

**Software interventions.** "Family-friendly" filters based on verified amenities (parking, washrooms, accessible paths, seating); nap/rest-stop suggestions; picnic spot list with verification; honest "no facilities recorded" label.

---

## 14. Seasonal accessibility (passes, snow, monsoon)

**Problem.** Key routes and destinations are only open part of the year, and opening dates vary. Travellers plan around outdated website text or generic blog posts.

**Who it affects.** All self-driving tourists; foreign visitors building multi-week itineraries; tour operators.

**Evidence**

- TCKP Kaghan booklet: Naran-to-Babusar section is snowbound and generally open "late June to late October"; season described as mid-May to mid-October; "Mid July to Mid August is monsoon season and vehicle movement is sometimes restricted due to landslides and rains in the lower Kaghan Valley" [14].
- FCDO: "Babusar Pass liable to close due to snowfall"; N15 Chilas–Babusar "inaccessible part of year"; monsoon season "late June to early October" [2].
- GB advisory 22 July 2025: Babusar Road "officially closed to all types of traffic" after flooding [5].

**Regions/seasons.** Babusar Top, Deosai, Khunjerab, Lowari, Fairy Meadows tracks; April–June (before opening) and October–November (after closure) are the risk windows.

**Software interventions.** Per-destination seasonal calendar showing historical open/closed windows **with source and year**, clearly separated from current status; "check before travel" prompts; alternative route suggestions when a pass is outside its window; validity dates on every seasonal claim.

---

## 15. Permits, NOC and foreign-tourist registration

**Problem.** Foreign tourists face a patchwork of requirements: registration with local authorities in GB, restricted-area permits, trekking and mountaineering permits, and in some areas Ministry of Interior NOC — with conflicting information across official sites, tourists blogs and tour operators.

**Who it affects.** Foreign tourists and their families; overseas Pakistanis; tour operators; Pakistani hosts planning itineraries.

**Evidence**

- GB District Tourism Services: "All foreign tourists must register with the local authorities upon arrival"; "Obtain necessary permits for restricted areas before visiting"; trekking permits (3–5 working days), mountaineering permits via Alpine Club (2–4 weeks), restricted-area permit via Ministry of Interior or a licensed operator (up to 4 weeks) [3].
- FCDO: "All foreign nationals must register with the local authorities when visiting Gilgit-Baltistan"; permits for mountaineering/trekking (especially above 6,000 m) may take up to 2 months and may invalidate insurance; advance permission is required for KP, Balochistan and several AJK districts; police will advise if a No Objection Certificate from the Ministry of Interior is needed [1][2].
- PTA DIRBS temporary registration for foreign nationals/overseas Pakistanis is "allowed for a period of 120 days from date of arrival", needing passport, a Pakistani SIM in the applicant's name, IMEI and travel dates; otherwise a 60-day grace period before FBR duty applies [19].

**Regions/seasons.** GB (Hunza, Skardu, KKH, Khunjerab), restricted districts in KP/AJK; year-round.

**Software interventions.** Guidance-first NOC workflow (destination → nationality → requirements → official instructions → document checklist → application tracking). **No simulated permits.** The app must never generate a document that looks like a government permit; local reference numbers must be clearly app-branded. Foreign tourist toolkit includes a PTA device-registration guide (eligibility, documents, steps, time limits, official portal link) with a warning that rules can change and the official portal is authoritative.

---

## 16. Language barriers

**Problem.** In remote areas, many residents do not understand Urdu or English, and information is available mostly in English or Urdu only.

**Who it affects.** Foreign tourists; Punjabi/Sindhi-speaking visitors; families with hearing impairment relying on text.

**Evidence**

- Kaghan Valley survey: "Although the Urdu language is a means of communication in the valley in the remote parts of the valley, most of the people do not understand Urdu, so some of the visitors also highlighted the language problem that they do not understand the language of the local community" [6].
- GB Tourism advisories and DTS instructions are published in English only — as observed on 2026-11-21 [3][4][5].

**Regions/seasons.** Kaghan side valleys, GB villages, Deosai; year-round.

**Software interventions.** UI in English, Urdu and Roman Urdu with RTL (Nastaliq) support; offline phrasebook cards per destination; key notices (road closure, emergency) downloadable in Urdu/English to show to locals; no claim of full local-language coverage.

---

## 17. Emergency assistance gaps

**Problem.** In emergencies, tourists face: no single emergency number list that works everywhere, no knowledge of nearest facility, and total communication blackouts.

**Who it affects.** Accident victims, stranded families, tourists in flood/landslide events.

**Evidence**

- GB Tourism advisory: helplines "1122: General emergencies 1422 or 05811930055: Tourist Police" [4]; the 22 July advisory reports communication infrastructure breakdown leaving "many tourists … lost contact with their families" [5].
- NDMA: "NDMA Emergency Helpline: 051-111-157-157 — Available 24/7"; its app gives early warning roughly 10–20 minutes ahead [8].
- NHMP helpline 130 and citizen complaints portal [7].

**Regions/seasons.** All tourist routes; emergency spikes in monsoon and winter.

**Software interventions.** Smart SOS: one-tap call to verified national numbers, shared location, family notification draft; SMS fallback when data is down, with honest "queued / not confirmed delivered" states; offline emergency card (nearest district hospital, police, pass closure notes); NDMA app download prompt; per-number coverage notes (e.g., "works on GB mobile networks only").

---

## 18. Poor local transport information

**Problem.** Local jeep, van and bus services are unpredictable, fares are negotiated, and schedules/boarding points are not published.

**Who it affects.** Tourists without private cars, students, foreign tourists, women travelling without a vehicle.

**Evidence**

- TCKP Kaghan booklet: jeeps can be hired at Balakot, Kewai, Shogran, Kaghan and Naran, with no published fares [14].
- Kaghan Valley survey: jeep owners demand high fares and jeep drivers are often unskilled; visitors cannot plan because of unreliable transport [6].
- FCDO advises against street taxis for foreign visitors [2].

**Regions/seasons.** Balakot–Naran, Murree, KKH towns; summer.

**Software interventions.** Local transport directory (jeep stands, van terminals, boarding points) with verified coordinates and contact; estimated fare bands (labelled estimates); operator verification status; "book through your hotel" guidance; report flow for overcharging or unsafe driving.

---

## 19. Misleading business information

**Problem.** Listings (on maps, social media and directories) show outdated details: closed hotels, wrong phone numbers, prices no longer honoured, and services not provided. Visitors arrive to find a different reality.

**Who it affects.** Everyone relying on online listings; foreign tourists in particular cannot call to verify.

**Evidence**

- Kaghan Valley survey: hotels lack "systematic procedure of reservations"; staff and service quality criticised as unprofessional; no complaint mechanism recorded for tourists against private contractors [6].
- Express Tribune (2020): a parking contractor told tourists the displayed tariff was "old" and rates had been increased; "Tuck shops have set their own tariffs for snacks and meals but nobody is available to address complaints against private contractors" [18].
- PTDC states "All PTDC Motels are closed" — an example of a historical network that still appears in older travel material [10].

**Regions/seasons.** All destinations; changes sharpen at start/end of season.

**Software interventions.** Every business record carries: data source, last updated, verification status, "price info as of" date. Unverified records shown as "community-listed, unverified"; stale records auto-flagged after a configurable TTL; user report "misleading info" with photo; admin verification workflow.

**Thin evidence note.** No systematic audit of listing accuracy in Pakistani tourism apps was found; evidence here is qualitative.

---

## 20. Lack of trustworthy reviews and complaint channels

**Problem.** Reviews are sparse, may be incentivised, and there is no visible, trusted complaint channel for tourists against private operators. Tourists do not know that a complaint was received or acted on.

**Who it affects.** All tourists making purchase decisions; private operators who lose trust from bad actors; district administrations without structured data on problems.

**Evidence**

- Express Tribune (2023): a visitor said "The biggest atrocity is that there is no mechanism for complaints against the overcharging" [17].
- Express Tribune (2020): the TDCP manager said several local groups operate "like mafias" and the corporation had "served notice to a parking contractor over public complaints but the problem still persists" [18].
- Punjab Tourism's site does offer a complaint form and phone/email contacts [12]; NHMP offers a citizen complaints portal [7] — i.e., channels exist but tourists evidently do not find or trust them.
- Kaghan Valley survey: hotel theft reported; police role criticised as "negative" [6].

**Regions/seasons.** All destinations.

**Software interventions.** In-app complaint tracker with categories (overcharging, misleading hotel info, poor facilities, road problems, safety concerns, damaged infrastructure, incorrect destination info, other), evidence attachments and transparent status ("Draft / Submitted locally / Forwarded by you to agency"); clearly labelled as **not** an official government submission unless an authorised integration exists; reviews restricted to verified visits where possible; "review helpfulness" weighting and duplicate detection; no removal of negative reviews without an audit trail.

**Thin evidence note.** Evidence on review manipulation in Pakistan's tourism sector is anecdotal in the sources reviewed; no study was located.

---

## 21. Problem → SmartMap Punjab intervention mapping

| # | Problem | Primary SmartMap Punjab feature | Honest limitation label |
|---|---------|-------------------------------|-------------------------|
| 1 | Unreliable road info | Travel Reality Check; road alert module with source agency, publication time, validity | "Information unavailable" when no source; not a live traffic service |
| 2 | Landslides and closures | Road alert statuses (Closed / Landslide reported), alternative route suggestions | Alerts are sourced/manual unless an authorised API exists |
| 3 | Poor road infrastructure | Road risk notes per segment; jeep-track hazard warnings | Qualitative notes, not structural engineering data |
| 4 | Internet coverage gaps | Offline-first cache with expiry labelling; downloadable trip packs; SMS fallback | Cached data may be outdated — age always shown |
| 5 | Hotel availability/pricing | Accommodation directory with verification status and price-info date; call-to-confirm flow; DC rate comparison | No live inventory; prices are "as reported" |
| 6 | Taxi overcharging | Taxi fare estimator (estimate label); DC official rate lists; overcharging report flow | Estimation model, not a metered fare; reports are not official complaints |
| 7 | Missing information | Destination pages with verified facts and provenance; offline packs; "where to ask" contacts | Community data labelled unverified |
| 8 | Washrooms | Facility finder with verification status, last verified date, women/family/accessible filters | Unverified facilities never shown as verified |
| 9 | Drinking water | Water points in facility finder; generic safe-water guidance | No water-quality certification data |
| 10 | Medical facilities | Hospital/BHU/pharmacy finder; hospital list in offline packs; SOS nearest-facility | Hours and services may change — verification date shown |
| 11 | Fuel | Highway essentials finder with last-verified status; "last fuel before gap" | Availability is community-reported |
| 12 | Women's safety | Women & family mode: filtered facilities, contacts, checklists | No "safe area" rating; no statistics claimed |
| 13 | Family facilities | Family-friendly filters and picnic/rest points with verification status | No claims beyond recorded amenities |
| 14 | Seasonal accessibility | Seasonal calendar per pass with source, year and validity; current status separate | Historical windows ≠ current status |
| 15 | Permits/NOC | Guidance-first NOC workflow; PTA DIRBS device-registration guide; official links | Never generates permits; not an authorised submission |
| 16 | Language barriers | EN/UR/Roman-Urdu UI, RTL Nastaliq; offline phrasebook; printable notices | Local dialect coverage not claimed |
| 17 | Emergency assistance | Smart SOS with verified numbers, location share, SMS fallback with honest delivery status | Delivery not guaranteed; numbers may change |
| 18 | Local transport info | Jeep/van terminal directory, estimated fare bands, operator verification | Schedules not official |
| 19 | Misleading listings | Provenance fields on every record; stale-data flagging; "misleading info" reports; admin verification | Cannot independently verify every business at launch |
| 20 | Trustworthy reviews/complaints | Review integrity rules; in-app complaint tracker with transparent status | Local tracking only until an authorised integration exists |

---

## 22. Honesty constraints

Several problems cannot be honestly "solved" by software alone. The following interventions depend on official integrations that do not currently exist publicly and must ship as clearly labelled guidance or local workflows:

1. **Live road status.** No public real-time road-status API from NHA or NHMP was observed on 2026-11-21 [7][9]. Until authorised data access exists, road alerts must be curated with a named source, a timestamp and a validity window, and must display "Information unavailable" rather than an assumed "Open".
2. **Official DC rate lists.** Rates must be transcribed only from verified published documents (as prompted in `MASTER_PROMPT.md` §0). If no current document exists, display "Official rate information currently unavailable" — never estimated rates presented as official. Estimates from the app must always be labelled as estimates.
3. **NOC / restricted-area permits and foreign registration.** SmartMap can prepare and track documents but cannot issue or submit permits unless an authorised government interface is integrated. Locally generated references must never look like official permits [3][1][2].
4. **Complaint delivery.** In-app complaints are local tracking records. They must state "Not submitted to any government agency" unless an official integration is approved and delivery is confirmed.
5. **Emergency numbers and SOS delivery.** Emergency numbers (Rescue 1122, Tourist Police, NDMA 051-111-157-157, NHMP 130) are shown with source and coverage notes [4][8][7]. SMS delivery must be reported as attempted/queued unless a delivery receipt exists.
6. **Weather warnings and early warning.** NDMA/Pakistan Meteorological Department feeds should be cited, not re-generated. The NDMA app is the authoritative early-warning channel [8].
7. **Reviews.** Reviews can be moderated for integrity but cannot be certified as true; verified-visit reviews must be explained clearly.
8. **Coverage, fuel, water quality.** No authoritative dataset was found for these; they must be shown as community-reported or "data not available", never inferred.

---

## 23. Research limitations

- **Limited public statistics.** Pakistan does not publish comprehensive tourist-incident, complaint or price-violation statistics. Most quantitative figures cited here come from a single peer-reviewed survey of 500 visitors in Kaghan Valley (2022) [6] and from press reports in single districts [17][18].
- **Rapidly changing conditions.** Road status, pass opening dates, fares and permit rules change within days; advisories from 2025 [4][5] and a 2026 NHA flash-flood advisory [11] demonstrate how fast a route can be closed. All facts in this document must be re-verified at implementation time.
- **Access problems.** Some official sites and major newspapers (e.g., Dawn articles [16], PID releases [11]) returned partial or blocked content; where only the headline or snippet was readable, the claim is marked accordingly and should be re-checked manually.
- **Agency sources are mostly non-operational.** PTDC/Salam Pakistan, Punjab Tourism and TDCP pages were promotional or procedural on 2026-11-21 [10][12][14]; no live rates or road feeds were observed. TCKP's Kaghan booklet is printed 2018 [14].
- **Thin-evidence problems:** women's travel safety (12), fuel availability (11), trustworthy review integrity (20), misleading listings (19), connectivity level (4) and overcharging frequency (6). These are described qualitatively and must not be presented in the product with invented numbers.
- **Geographic bias.** Much of the best-documented evidence concerns Kaghan and GB. Punjab hill stations (Murree, Galyat, Soon Valley) have press-reported pricing problems but fewer structured studies.

---

## Sources

All URLs accessed on **2026-11-21** unless stated otherwise.

1. UK Foreign, Commonwealth & Development Office — *Pakistan: Regional risks* (page dateModified 2026-11-18). https://www.gov.uk/foreign-travel-advice/pakistan/regional-risks
2. UK Foreign, Commonwealth & Development Office — *Pakistan: Safety and security* (page dateModified 2026-11-18). https://www.gov.uk/foreign-travel-advice/pakistan/safety-and-security
3. District Tourism Services, Gilgit-Baltistan — *Regulations* page. https://www.dtsgb.gog.pk/regulations
4. Tourism, Sports, Culture, Archaeology & Museums Department, Gilgit-Baltistan — News advisory "KKH blocked after landslides" (published 16 July 2025, 09:34). https://visitgilgitbaltistan.gov.pk/pages/news/43
5. Tourism Department, Gilgit-Baltistan — Advisory/emergency on Thak–Babusar road (published 22 July 2025, 20:17). https://visitgilgitbaltistan.gov.pk/pages/news/45
6. Arif, A. M., Hameed, A., & Anwar, A. (2022). "Problems Faced by Visitors in Pakistan: A Case Study of Kaghan Valley, Mansehra." *Global Political Review*, VII(I), 74–82. DOI: 10.31703/gpr.2022(VII-I).08. PDF (accessed 2026-11-21): https://pdfs.semanticscholar.org/7868/03472ce5475f9aae134cdaca8c852bbe040d.pdf
7. National Highways & Motorway Police (NHMP) — official website, traveller information and helpline guidance. https://nhmp.gov.pk/
8. National Disaster Management Authority (NDMA) — official website, emergency helpline 051-111-157-157. https://www.ndma.gov.pk/ ; NDMA *Disaster Alert* app early-warning note (posted 2025-08-26): https://www.facebook.com/ndmapk/posts/1095289256122070/
9. National Highway Authority (NHA) — corporate information (39 highways/motorways/expressways; 12,131 km; 4.6% of national road length). https://communication.gov.pk/Detail/MTAyMGFlN2ItMTc2Mi00MjAxLTg3MDEtZDZjYmY3NDU4N2Y1 ; NHA MIS portal: https://mis.nha.gov.pk/
10. Pakistan Tourism Development Corporation (PTDC) — portal and publications. https://tourism.gov.pk/ ; tour-packages notice ("All PTDC Motels are closed"): https://tourism.gov.pk/packages_promotion.html
11. Press Information Department (PID) — NHA urgent advisory on flash floods at Thak, Babusar Highway closure (dated 2026-08-04; read via search-result snippet). https://pid.gov.pk/site/press_detail/33458
12. Tourism, Archaeology and Museums Department, Government of the Punjab — district directory, complaint form, contacts. https://tourism.punjab.gov.pk/ ; complaint form: https://tourism.punjab.gov.pk/form/complain-form
13. GSMA — "Unlocking Pakistan's Digital Future: GSMA Highlights Opportunities and Progress at Digital Nation Summit Islamabad" (press release, 2025-08-07; "52% of Pakistanis live under mobile broadband coverage but do not use it"). https://www.gsma.com/newsroom/press-release/unlocking-pakistans-digital-future-gsma-highlights-opportunities-and-progress-at-digital-nation-summit-islamabad/
14. Tourism Corporation Khyber Pakhtunkhwa (TCKP) — *Kaghan* brochure (year printed 2018). https://tourism.gov.pk/publications/Kaghan%20Booklet.pdf
15. Zorobooking — Gilgit-Baltistan SIM/connectivity travel guide (commercial source; used only for qualitative coverage remarks). https://www.zorobooking.com/
16. Dawn — "Traffic police squad to check transporters overcharging fares in Murree" (2026-06-04; read via search-result snippet only; page returns HTTP 403). https://www.dawn.com/news/2005084
17. The Express Tribune — "Tourists complain of overcharging in Murree" (2023-04-25). https://tribune.com.pk/story/2413468/tourists-complain-of-overcharging-in-murree
18. The Express Tribune — "Overcharging mars tourists' experience" (2020-10-05). https://tribune.com.pk/story/2266979/overcharging-mars-tourists-experience
19. Pakistan Telecommunication Authority — DIRBS FAQs, temporary registration for foreign nationals/overseas Pakistanis (120 days). https://dirbs.pta.gov.pk/faqs
20. Associated Press of Pakistan (APP) — "Murree transporters warned against overcharging travel fares" (read via search-result snippet). https://www.app.com.pk/domestic/murree-transporters-warned-against-overcharging-travel-fares/
21. Anadolu Agency — "10 killed, thousands stranded as rain-triggered landslides blocked China-Pakistan highway" (2025-07-23; headline-level evidence). https://www.aa.com.tr/en/asia-pacific/10-killed-thousands-stranded-as-rain-triggered-landslides-blocked-china-pakistan-highway/3639597
22. The World News (English) — "Thousands stranded as landslides block Karakoram Highway and disrupt communications in Pakistan's north" (2025-07-24; headline-level evidence). https://wenewsenglish.com/thousands-stranded-as-landslides-block-karakoram-highway-and-disrupt-communications-in-pakistans-north/
