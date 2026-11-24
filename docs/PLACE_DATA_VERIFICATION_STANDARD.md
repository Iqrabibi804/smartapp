# Place Data Verification Standard

## Current baseline

The bundled offline catalogue contains 27 place records. These records are useful as discovery placeholders, not as a verified directory. They currently have no per-record source URL or verification timestamp. Phone numbers, street addresses, coordinates, opening hours, facilities, prices, payment options and images must therefore not be treated as confirmed facts.

A place's name appearing in an official tourism list confirms that it is a recognised destination; it does **not** independently verify its current address, coordinates, opening hours, fees, phone number, accessibility or operating status.

## Source hierarchy

Use sources according to the field being verified:

1. **Destination identity and heritage context**
   - Punjab Tourism Department / TDCP: https://tdcp.gop.pk/
   - National tourism portal (Salam Pakistan), Punjab destinations: https://salampakistan.gov.pk/where-to-go/location/punjab/featured?parentCategoryId=610284db08208f067f7a4d62
   - Ministry of Foreign Affairs Pakistan Tourism Guide: https://www.mofa.gov.pk/storage/gallery/Pakistan%20Tourism%20Guide.pdf
   - Ministry of Tourism / PTDC publications: https://tourism.gov.pk/publications.html
2. **Tourism service licensing**
   - Department of Tourist Services Punjab: https://dtsweb.punjab.gov.pk/
   - DTS contact and regional offices: https://dts.punjab.gov.pk/contact_pg
   - A listing in DTS material may support licensing/registration status only; it does not prove that a business is currently open or that its phone number, prices or services are current.
3. **Hospital and emergency-service identity**
   - Prefer the relevant Punjab Specialized Healthcare & Medical Education Department, district health authority, or hospital's own official website/contact directory. Do not infer emergency availability, phone numbers or operating hours from a map pin.
4. **Coordinates and route geometry**
   - Prefer coordinates published by the responsible government/venue authority. OpenStreetMap or another map provider can be a secondary geospatial reference, not proof of ownership, public access, operating status or safety.
5. **Commercial contact details, fees, facilities and opening hours**
   - Require a current official venue website, verified official social account, government register, or direct documented confirmation. Record the date checked. Search snippets and third-party directories are leads, not sufficient evidence.
6. **Images**
   - Use venue/government-owned media or properly licensed media with attribution and a recorded source. Generic stock imagery must not be presented as a photograph of the actual place.

## Field-level publication rules

| Field | Minimum evidence before marking verified |
|---|---|
| Name and category | Official tourism, government, venue, or responsible authority source |
| Address | Current official venue/authority source; record the date checked |
| Latitude/longitude | Authoritative coordinates or manually cross-checked map pin plus official address |
| Phone / website | Official venue or responsible authority contact page |
| Opening hours | Current official venue/authority notice; store checked-at date |
| Facilities / accessibility | Explicit official listing or dated direct confirmation |
| Entry fee / parking / guide fee | Current official tariff or dated venue confirmation; show currency and effective date |
| Payment methods | Explicit venue confirmation; never infer from common local practice |
| Safety / patrol / emergency claims | Current statement from the responsible authority; never invent a numeric safety score |
| Photo | Actual venue image with source and licence/permission recorded |

## Status semantics

- `needs_verification`: not independently checked; do not display as confirmed.
- `community_reported`: submitted by a user; label as unverified until reviewed.
- `verified`: a reviewer has checked the relevant fields against a recorded source and set `source` plus `lastVerifiedAt`.
- Verification is field-sensitive. A verified destination name does not automatically verify its phone number, prices, hours, facilities, safety or coordinates. If fields have different sources or check dates, record that provenance separately rather than treating the whole record as universally current.

## Review workflow

1. Select one place and identify the responsible authority or official venue.
2. Verify the destination identity and each high-impact field independently.
3. Record source URL, source type, date checked, reviewer and any limitations.
4. Keep unsupported fields absent or explicitly marked unknown; do not fill gaps with guessed values.
5. Request a second-person review for coordinates, emergency contacts, safety claims and fees.
6. Re-check volatile fields (phone, hours, fees, services) on a scheduled cadence and expire stale verification.
7. Keep an audit trail when data changes. Do not refresh `lastVerifiedAt` merely because an unrelated description field was edited.

## Known coverage limitation

The Department of Tourist Services Punjab publishes information about licensing and registration of tourism businesses, and the official tourism portals publish destination information. These sources are not a single comprehensive, field-level API for every place in the app. Manual verification and explicit unknown values remain necessary.

## Current app behaviour

The Place Details screen hides contact details, hours, facilities and imagery for unverified bundled records. Directions and WhatsApp location sharing are also gated on the place's verified status. The backend requires a source reference before a place can be marked verified. This is a conservative baseline, not a substitute for a complete per-field provenance model.
