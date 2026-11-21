const express = require('express');
const SavedPlace = require('../models/SavedPlace');
const asyncHandler = require('../utils/asyncHandler');
const { protect } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');

const router = express.Router();

router.get(
  '/',
  protect,
  asyncHandler(async (req, res) => {
    const saved = await SavedPlace.find({ userId: req.user._id })
      .populate('placeId')
      .sort({ createdAt: -1 })
      .lean();

    const places = saved.filter((s) => s.placeId).map((s) => s.placeId);
    res.json({ success: true, places });
  })
);

router.post(
  '/',
  protect,
  asyncHandler(async (req, res) => {
    const { placeId } = req.body;
    if (!placeId) throw new ApiError(400, 'placeId is required.');

    try {
      await SavedPlace.create({ userId: req.user._id, placeId });
    } catch (err) {
      if (err.code !== 11000) throw err;
    }

    res.status(201).json({ success: true });
  })
);

router.delete(
  '/:placeId',
  protect,
  asyncHandler(async (req, res) => {
    await SavedPlace.deleteOne({ userId: req.user._id, placeId: req.params.placeId });
    res.json({ success: true });
  })
);

module.exports = router;