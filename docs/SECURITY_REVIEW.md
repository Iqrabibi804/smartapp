# SMARTMAP PUNJAB — SECURITY REVIEW

**Date:** 2026-11-24
**Scope:** Flutter client, Node/Express API, MongoDB models, repository secrets.

## 1. Secrets

| Finding | Status |
|---|---|
| `MONGO_URI` placed in `mobile/.env` (client-side file) | **Removed.** The file now contains only a note; the client never uses database credentials. |
| Live MongoDB Atlas URI committed in `backend/.env.example` | **Removed.** Placeholder is now `mongodb://127.0.0.1:27017/smartmap_ai`. The exposed credential remains in earlier Git history and must be rotated in MongoDB Atlas. |
| Google Maps API key hardcoded in `AndroidManifest.xml` | **Source fix applied.** The manifest now uses a Gradle placeholder populated from a local Gradle property or environment variable. The previously exposed key must still be rotated/restricted in Google Cloud; Android keys are extractable from APKs and must be application/API restricted. |
| Server JWT secret | **Hardened.** The server now refuses to start unless `JWT_SECRET` is at least 32 characters. |
| Source scan for hardcoded passwords / `sk-` / `AIza` outside the manifest | No additional matches in the reviewed current source tree; historical Git commits still require credential rotation. |

## 2. Authentication and authorization

- Passwords hashed with bcrypt cost 12; `passwordHash` excluded from queries by default.
- JWT verified on every protected route; suspended/deleted accounts are rejected.
- `authorize('admin')` guards every admin route; registration cannot self-assign a role.
- Auth endpoints throttled to 20 attempts per 15 minutes per IP; global API limit 300 per 15 minutes.
- Malformed/expired JWTs map to 401, not 500.
- **Open:** no email verification enforcement, no admin MFA, no account lockout beyond rate limiting.

## 3. Audit trail

- New `AuditLog` model records actor, action, target type/id, metadata, IP and timestamp.
- Logged actions: user status change, review moderation, place update/delete, business
  verification status change.
- `GET /api/admin/audit-logs` (admin only) returns the latest 200 entries.
- Audit entries expire after 365 days via a TTL index (retention safeguard).
- Audit failures are logged but never block the moderator action.

## 4. Input, transport and uploads

- `helmet` security headers; `x-powered-by` disabled.
- `express-mongo-sanitize` blocks operator injection; Mongoose schema validation on all models.
- JSON body limit 2 MB.
- Uploads: authenticated, MIME + extension allow-list (jpg/png/webp/gif), 5 MB limit, generated filenames.
- Static `/uploads` disables directory indexes and dotfiles.
- CORS: `CLIENT_ORIGIN` must be set in production (startup fails otherwise); permissive `*` only in development.
- **Open:** uploaded images are publicly readable by URL; no malware scanning; no per-user quota.
  Do not accept identity documents through this endpoint.

## 5. Privacy

- Local-only data (digital pass, complaints, road reports, readiness checklist) stays in the
  on-device Hive cache and is explicitly labelled as not submitted.
- No location is sent to the backend without a user-initiated search or map action.
- **Open:** CNIC verification screen still requires a privacy audit (consent, minimisation,
  encryption at rest); document upload is not implemented, which is the safe default until
  encryption and retention rules exist.

## 6. Startup guards

`server.js` now fails fast when:
- `JWT_SECRET` is missing or shorter than 32 characters,
- `MONGO_URI` is missing,
- `NODE_ENV=production` without `CLIENT_ORIGIN`.

## 7. Verification

- CI runs the full backend dependency audit, backend tests and JavaScript syntax checks.
- CI runs Flutter tests, Android debug APK compilation and Flutter web release compilation.
- Check the latest [Quality checks workflow](https://github.com/Iqrabibi804/smartapp/actions/workflows/quality-checks.yml) for current commit-specific results; do not treat older successful runs as proof for newer commits.

## 8. Required follow-ups

1. Rotate the MongoDB Atlas credential exposed in Git history.
2. Rotate/restrict the previously exposed Google Maps API key. The current source now injects it through a build-time property; keep it application- and API-restricted.
3. Add email verification and consider MFA for admin accounts.
4. Add upload scanning/quota and keep identity documents off public storage.
5. Extend audit logging to emergency-contact and rate-list management once those admin
   endpoints exist.
