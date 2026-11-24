/**
 * Public place discovery policy.
 *
 * Verified records must carry an explicit source and verification timestamp.
 * Community-reported records remain discoverable but are never treated as
 * independently verified by the client.
 *
 * Legacy records are retained only when they also have the provenance fields
 * required by the current verification policy.
 */
function publishedPlaceFilter() {
  const hasSource = { $type: 'string', $ne: '' };
  const hasVerificationDate = { $type: 'date' };

  return {
    $or: [
      {
        verificationStatus: 'verified',
        source: hasSource,
        lastVerifiedAt: hasVerificationDate,
      },
      { verificationStatus: 'community_reported' },
      {
        verificationStatus: { $exists: false },
        verified: true,
        source: hasSource,
        lastVerifiedAt: hasVerificationDate,
      },
    ],
  };
}

module.exports = { publishedPlaceFilter };
