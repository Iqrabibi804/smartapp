const Emergency = require('../models/emergency');
const ApiError = require('../utils/apiError'); // Assuming exists, else create simple error
const asyncHandler = require('../utils/asyncHandler');

// @desc    Get emergency contacts for a city
// @route   GET /api/emergency/:city
// @access  Protected
exports.getEmergencyByCity = asyncHandler(async (req, res, next) => {
  const { city } = req.params;
  const emergency = await Emergency.findOne({ city: new RegExp(`^${city}$`, 'i') });
  if (!emergency) {
    return next(new ApiError(404, `No emergency data found for city ${city}`));
  }
  res.json({ success: true, data: emergency });
});

// @desc    SOS delivery endpoint
// @route   POST /api/emergency/sos
// @access  Protected
// No SMS gateway is connected in this release, so the endpoint refuses rather than
// implying that help was dispatched.
exports.sendSOS = asyncHandler(async (req, res) => {
  res.status(503).json({
    success: false,
    message:
      'SOS delivery is not connected. Call Rescue 1122, Police 15 or the Tourist Helpline directly.',
  });
});
