# SMARTMAP PUNJAB — TESTING REPORT

**Updated:** 2026-11-21
**Environment:** Windows 11, Flutter 3.35.7, Dart bundled, Node.js 22.20.0, Chrome 157 (web target available), no Android emulator or physical device attached, no MongoDB instance running.

## 1. Automated results (current)

| Check | Command | Result |
|---|---|---|
| Static analysis | `flutter analyze` | 0 errors, 0 warnings, 18 info-level hints (`use_build_context_synchronously`, `prefer_const`, deprecated `DropdownButtonFormField.value`) |
| Widget smoke test | `flutter test` | Passes: splash renders, leaves cleanly, no pending timers |
| Offline filter tests | `flutter test` | 6/6 pass (category, city, rating threshold, rating sort, popularity sort, keyword) |
| Offline cache tests | `flutter test` | 4/4 pass (fresh→cached, stale→expired, missing→unavailable, online/offline reporting) |
| Road advisory provenance | `flutter test` | 3/3 pass (all advisories sourced and dated; none claims a live status; ids unique) |
| Phase 8 content | `flutter test` | 2/2 pass (readiness sections/ids valid; culture tips and phrases populated) |
| Phase 9 content | `flutter test` | 3/3 pass (permit steps/destinations; PTA/currency content without fixed durations; complaint categories) |
| Backend syntax | `node --check` on all modified files | OK (Phase 3 scripts, routes, models) |

Suite total: 20 tests, all passing.

## 2. Runtime smoke test (web)

- `flutter run -d chrome --web-port=8123` started successfully.
- Page title rendered as **SmartMap Punjab**; HTTP 200 on `http://127.0.0.1:8123/`.
- Browser console (errors + warnings, preserved messages): **none** during load through the home screen.
- Limitation: the in-app browser surface was not visible (`viewport=0x0`), so screenshots and pointer-level journey checks could not be captured in this environment. Visual verification on a real Android device/emulator remains required.

## 3. Offline behaviour verified by tests

- City filter only returns places whose address/name/description reference the city.
- Category filter returns only records in that category.
- Minimum rating and both sort orders behave as specified; sort was previously ignored in the offline path and is now applied.
- Keyword matching covers name, address, description, category, and facilities.
- Cache entries expose age/TTL honesty: a fresh write reads back as `cached`, an expired entry as `expired`, and a missing key as `unavailable`; online/offline reports flip the banner state.

## 4. Bug fixes landed in Phase 5

| Bug | Fix |
|---|---|
| `getById` fallback silently returned the first place for any unknown id | Now returns only a matching bundled record or throws; detail screen shows its error state |
| `getNearby` fallback labelled eight arbitrary places as "nearby" | Now filters bundled places by real Haversine distance to the requested coordinates |
| Offline `sort` parameter ignored | `rating` and `popular` sorting implemented |
| "Explore Verified Places" and "real-time verified spots" copy | Replaced with factual copy (no verification exists) |
| "Immediate 24/7 emergency response numbers active across …" | Reworded to "Commonly published emergency numbers. Confirm locally…" |
| Home profile text claiming Punjab Tourism Department officers | Reworded to app administrator tools |

## 5. Not yet verified (blocked / pending)

| Item | Reason |
|---|---|
| City guide and detail-page tap-through | No Android device/emulator; web screenshot surface unavailable. Code paths compile and data is static. |
| Search against live API | Backend/MongoDB not running in this environment; offline fallback covered by tests. |
| Auth flows | No backend; hermetic widget test only. |
| RTL layout | Urdu strings render with Nastaliq; full mirroring not yet audited. |
| Offline cache expiry | Implemented in Phase 6, not yet built. |
| Signed release APK | Phase 12. |

## 6. Repro commands

```bash
cd mobile
flutter pub get
flutter analyze
flutter test
flutter run -d chrome --web-port=8123
```
