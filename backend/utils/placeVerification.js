const { ApiError } = require('../middleware/errorHandler');

/**
 * A place can only enter the verified state when an admin explicitly requests
 * verification and supplies a source reference. Other edits do not silently
 * refresh the verification timestamp.
 */
function withPlaceVerification(payload, existing = {}) {
  const update = { ...payload };
  const requestsVerification =
    update.verificationStatus === 'verified' || update.verified === true;

  if (requestsVerification) {
    const source = typeof update.source === 'string'
      ? update.source.trim()
      : (typeof existing.source === 'string' ? existing.source.trim() : '');

    if (!source) {
      throw new ApiError(400, 'A source reference is required before verifying a place.');
    }

    update.verificationStatus = 'verified';
    update.verified = true;
    update.source = source.slice(0, 500);
    update.lastVerifiedAt = new Date();
  } else if (
    update.verified === false ||
    (update.verificationStatus !== undefined &&
      update.verificationStatus !== 'verified')
  ) {
    update.verified = false;
    if (update.verificationStatus === undefined) {
      update.verificationStatus = 'needs_verification';
    }
  }

  return update;
}

module.exports = { withPlaceVerification };
