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

// @desc    Trigger SOS SMS (fallback if no internet)
// @route   POST /api/sos
// @access  Protected
exports.sendSOS = asyncHandler(async (req, res, next) => {
  const { lat, lng, userId } = req.body;
  if (lat == null || lng == null) {
    return next(new ApiError(400, 'Latitude and longitude are required'));
  }
  // Find nearest emergency contact (simplified: nearest city by distance)
  // For now, just pick the first city record (could be improved with geo queries)
  const emergency = await Emergency.findOne();
  if (!emergency) {
    return next(new ApiError(500, 'Emergency contacts not configured'));
  }
  // TODO: integrate SMS provider (e.g., Twilio). For now, just return details.
  const message = `SOS from user ${userId || 'unknown'} at (${lat},${lng})`;
  // Placeholder: In production, call SMS gateway here.
  res.json({ success: true, message: 'SOS request received', smsTo: emergency.touristHelpline.phone, smsBody: message });
});
