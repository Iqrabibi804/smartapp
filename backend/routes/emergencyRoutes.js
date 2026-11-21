const express = require('express');
const { getEmergencyByCity, sendSOS } = require('../controllers/emergencyController');
const { protect } = require('../middleware/auth');

const router = express.Router();

// Get emergency contacts for a city (protected)
router.get('/:city', protect, getEmergencyByCity);

// Send SOS (protected) - body: { lat, lng, userId }
router.post('/sos', protect, sendSOS);

module.exports = router;
