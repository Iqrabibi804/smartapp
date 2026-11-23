const express = require('express');
const Event = require('../models/Event');
const asyncHandler = require('../utils/asyncHandler');
const { protect, authorize } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');

const router = express.Router();

router.get(
  '/',
  asyncHandler(async (req, res) => {
    const { lat, lng, radiusKm } = req.query;
    const includePast = req.query.all === 'true';
    const filter = { verificationStatus: 'verified' };

    if (!includePast) {
      filter.date = { $gte: new Date() };
    }

    const parsedLat = lat === undefined ? undefined : Number(lat);
    const parsedLng = lng === undefined ? undefined : Number(lng);
    if ((parsedLat === undefined) !== (parsedLng === undefined)) {
      throw new ApiError(400, 'lat and lng must be provided together.');
    }
    if (parsedLat !== undefined && (!Number.isFinite(parsedLat) || parsedLat < -90 || parsedLat > 90 || !Number.isFinite(parsedLng) || parsedLng < -180 || parsedLng > 180)) {
      throw new ApiError(400, 'Invalid latitude or longitude.');
    }
    if (parsedLat !== undefined) {
      filter.location = {
        $near: {
          $geometry: { type: 'Point', coordinates: [parsedLng, parsedLat] },
          $maxDistance: (() => { const radius = radiusKm === undefined ? 20 : Number(radiusKm); if (!Number.isFinite(radius) || radius <= 0 || radius > 100) throw new ApiError(400, 'radiusKm must be greater than 0 and no more than 100.'); return radius * 1000; })(),
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
    const event = await Event.findOne({ _id: req.params.id, verificationStatus: 'verified' }).lean();
    if (!event) throw new ApiError(404, 'Event not found.');
    res.json({ success: true, event });
  })
);

router.post(
  '/',
  protect,
  authorize('admin'),
  asyncHandler(async (req, res) => {
    const isVerified = req.body.verificationStatus === 'verified';
    const source = typeof req.body.source === 'string' ? req.body.source.trim().slice(0, 300) : '';
    if (isVerified && !source) {
      throw new ApiError(400, 'A source is required before publishing a verified event.');
    }
    const event = await Event.create({
      name: req.body.name,
      description: req.body.description,
      location: req.body.location,
      address: req.body.address,
      date: req.body.date,
      startTime: req.body.startTime,
      endTime: req.body.endTime,
      organizer: req.body.organizer,
      ticketInfo: req.body.ticketInfo,
      image: req.body.image,
      verificationStatus: isVerified ? 'verified' : 'needs_verification',
      source: isVerified ? source : null,
      lastVerifiedAt: isVerified ? new Date() : null,
      createdBy: req.user._id,
    });
    res.status(201).json({ success: true, event });
  })
);

module.exports = router;