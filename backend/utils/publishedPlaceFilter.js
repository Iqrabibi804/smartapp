/**
 * Places shown in public discovery results.
 *
 * "Verified" means an authorized manager confirmed the record. "Community
 * reported" records are compiled from public information and are displayed
 * with that label; they must never be presented as verified.
 *
 * Legacy documents predate `verificationStatus`, so the old `verified`
 * boolean is still honored for them.
 */
function publishedPlaceFilter() {
  return {
    $or: [
      { verificationStatus: { $in: ['verified', 'community_reported'] } },
      { verificationStatus: { $exists: false }, verified: true },
    ],
  };
}

module.exports = { publishedPlaceFilter };
