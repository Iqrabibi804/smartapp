const express = require('express');
const Event = require('../models/Event');
const asyncHandler = require('../utils/asyncHandler');
const { protect, authorize } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');

const router = express.Router();

router.get(
  '/',
  asyncHandler(async (req, res) => {
    const { lat, lng, radiusKm, all } = req.query;
    const filter = {};

    if (!all) {
      filter.date = { $gte: new Date() };
    }

    const parsedLat = parseFloat(lat);
    const parsedLng = parseFloat(lng);
    if (!Number.isNaN(parsedLat) && !Number.isNaN(parsedLng)) {
      filter.location = {
        $near: {
          $geometry: { type: 'Point', coordinates: [parsedLng, parsedLat] },
          $maxDistance: (parseFloat(radiusKm) || 20) * 1000,
        },
      };
    }

    const events = await Event.find(filter).sort(filter.location ? {} : { date: 1 }).limit(50).lean();
    res.json({ success: true, events });
  })
);

router.get(
  '/:id',
  asyncHandler(async (req, res) => {
    const event = await Event.findById(req.params.id).lean();
    if (!event) throw new ApiError(404, 'Event not found.');
    res.json({ success: true, event });
  })
);

router.post(
  '/',
  protect,
  authorize('admin'),
  asyncHandler(async (req, res) => {
    const event = await Event.create({ ...req.body, createdBy: req.user._id });
    res.status(201).json({ success: true, event });
  })
);

module.exports = router;