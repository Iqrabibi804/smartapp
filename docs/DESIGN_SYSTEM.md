# SMARTMAP PUNJAB — DESIGN SYSTEM

**Updated:** 2026-11-21
**Source of truth:** `mobile/lib/core/theme/design_tokens.dart`, `mobile/lib/core/constants/app_colors.dart`

## 1. Identity

| Element | Value |
|---|---|
| Product name | SmartMap Punjab |
| Tagline | Explore Punjab. Travel with Confidence. |
| Urdu name | سمارٹ میپ پنجاب |
| Mark | Location pin holding a crescent and star (original artwork, `core/widgets/app_logo.dart`) |
| Affiliation | Independent guide. No government affiliation is claimed anywhere in the UI. |

## 2. Color tokens

| Token | Value | Usage |
|---|---|---|
| Pakistan Green | `#01411C` | Primary actions, headers, selected navigation |
| Green dark | `#012E13` | Splash background top, pressed states |
| Heritage gold | `#C5A66A` | Restrained accent, dividers, Urdu subtitle, logo crescent |
| Scaffold | `#F4F6F2` | App background (light) |
| Surface | `#FFFFFF` | Cards, sheets, inputs (light) |
| Text primary | `#1F2937` | Body text (light) |
| Text secondary | `#64748B` | Captions, metadata (light) |
| Border | `#E2E8F0` | Card and input borders (light) |
| Success | `#15803D` | Positive status |
| Warning | `#B45309` | Caution |
| Alert red | `#B91C1C` | Errors and emergency actions only |
| Scaffold dark | `#0F172A` | Dark background |
| Surface dark | `#1E293B` | Dark cards |
| Border dark | `#334155` | Dark borders |

Legacy palette names in `AppColors` (`heritageGreen`, `glacialBlue`, `truckArt*`, …) are compatibility aliases that now resolve to the canonical identity. The multi-palette selector was removed from the app.

## 3. Typography

| Role | Family | Weights |
|---|---|---|
| Headings, titles, buttons | Poppins | 400 / 600 / 700 |
| Body, labels | Roboto | variable |
| Urdu | Noto Nastaliq Urdu | 400 |

Fonts are bundled under `mobile/assets/fonts/` (OFL licensed; license texts included) and declared in `pubspec.yaml`. No runtime font download.

## 4. Spacing, radius, elevation

- Spacing scale: 4 / 8 / 12 / 16 / 24 / 32 (`AppSpacing`).
- Corner radius: 8 / 12 / 16 / 24 (`AppRadius`); cards use 12.
- Card shadow: 5% black, 12px blur, y-offset 4. Floating elements: 12%, 24px blur.

## 5. Gradients

- `AppGradients.splash` — dark green vertical gradient.
- `AppGradients.hero` — Pakistan Green to leaf green, top-left to bottom-right.
- `AppGradients.goldRule` — heritage gold hairline accents.

## 6. Components implemented

- Themed `NavigationBar`, `ElevatedButton`, `OutlinedButton`, `TextButton`, `InputDecoration`, `Card`, `Chip`, bottom sheet, snackbar, progress indicator (light + dark).
- `AppLogoMark` / `AppLogo` — original vector mark, scalable, no bitmap assets.
- Splash screen — flag-inspired green field, gold rule, logo mark, English + Urdu branding, honest footer ("Independent guide — not affiliated with any government body").
- Home header — logo mark, English title + tagline, location chip, "Independent guide" chip, language selector (EN/UR/PA/中文/AR), theme toggle, cities shortcut.

## 7. Screen coverage status

| Screen | Brand pass |
|---|---|
| Splash | Done |
| Home header + bottom navigation + AI FAB | Done |
| Home content sections | Uses themed components; section-level polish continues in Phase 5 |
| Onboarding, auth, search, details, trips, admin | Picked up by global theme; individual polish pending Phase 5 |

## 8. Accessibility notes

- Text colors meet contrast on their intended surfaces; alert red is not used for decoration.
- Urdu strings use the Nastaliq family and `TextDirection.rtl` where rendered as standalone labels.
- Full RTL layout mirroring and interface-wide language switching remain open (tracked in `FEATURE_STATUS.md`).
