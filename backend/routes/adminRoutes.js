const express = require('express');
const User = require('../models/User');
const Place = require('../models/Place');
const Review = require('../models/Review');
const Business = require('../models/Business');
const Event = require('../models/Event');
const asyncHandler = require('../utils/asyncHandler');
const { protect, authorize } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');

const router = express.Router();

router.use(protect, authorize('admin'));

router.get(
  '/stats',
  asyncHandler(async (req, res) => {
    const [
      totalUsers,
      activeUsers,
      totalPlaces,
      verifiedBusinesses,
      pendingBusinesses,
      totalReviews,
      reportedReviews,
      totalEvents,
    ] = await Promise.all([
      User.countDocuments(),
      User.countDocuments({ accountStatus: 'active' }),
      Place.countDocuments(),
      Business.countDocuments({ status: 'verified' }),
      Business.countDocuments({ status: 'pending' }),
      Review.countDocuments(),
      Review.countDocuments({ status: 'reported' }),
      Event.countDocuments(),
    ]);

    res.json({
      success: true,
      stats: {
        totalUsers,
        activeUsers,
        totalPlaces,
        verifiedBusinesses,
        pendingBusinesses,
        totalReviews,
        reportedReviews,
        totalEvents,
      },
    });
  })
);

router.get(
  '/users',
  asyncHandler(async (req, res) => {
    const users = await User.find().sort({ createdAt: -1 }).limit(200).lean();
    res.json({ success: true, users });
  })
);

router.put(
  '/users/:id/status',
  asyncHandler(async (req, res) => {
    const { accountStatus } = req.body;
    if (!['active', 'suspended'].includes(accountStatus)) {
      throw new ApiError(400, 'accountStatus must be "active" or "suspended".');
    }

    if (String(req.params.id) === String(req.user._id)) {
      throw new ApiError(400, 'You cannot change your own account status.');
    }

    const user = await User.findByIdAndUpdate(
      req.params.id,
      { accountStatus },
      { new: true }
    );
    if (!user) throw new ApiError(404, 'User not found.');

    res.json({ success: true, user });
  })
);

router.get(
  '/reviews',
  asyncHandler(async (req, res) => {
    const filter = {};
    if (req.query.reported === 'true') filter.status = 'reported';

    const reviews = await Review.find(filter)
      .populate('userId', 'name email')
      .populate('placeId', 'name')
      .sort({ createdAt: -1 })
      .limit(200)
      .lean();

    res.json({ success: true, reviews });
  })
);

router.put(
  '/reviews/:id/status',
  asyncHandler(async (req, res) => {
    const { status } = req.body;
    if (!['approved', 'rejected'].includes(status)) {
      throw new ApiError(400, 'status must be "approved" or "rejected".');
    }

    const review = await Review.findByIdAndUpdate(
      req.params.id,
      { status, reportCount: status === 'approved' ? 0 : undefined },
      { new: true }
    );
    if (!review) throw new ApiError(404, 'Review not found.');

    res.json({ success: true, review });
  })
);

// Admin Place Management endpoints
router.get(
  '/places',
  asyncHandler(async (req, res) => {
    const { q, verified, featured } = req.query;
    const filter = {};
    if (q && q.trim()) {
      filter.name = { $regex: q.trim(), $options: 'i' };
    }
    if (verified !== undefined) {
      filter.verified = verified === 'true';
    }
    if (featured !== undefined) {
      filter.featured = featured === 'true';
    }

    const places = await Place.find(filter)
      .populate('categoryId', 'name icon')
      .sort({ createdAt: -1 })
      .limit(200)
      .lean();

    res.json({ success: true, count: places.length, places });
  })
);

router.put(
  '/places/:id',
  asyncHandler(async (req, res) => {
    const place = await Place.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!place) throw new ApiError(404, 'Place not found.');
    res.json({ success: true, place });
  })
);

router.delete(
  '/places/:id',
  asyncHandler(async (req, res) => {
    const place = await Place.findByIdAndDelete(req.params.id);
    if (!place) throw new ApiError(404, 'Place not found.');
    res.json({ success: true, message: 'Place deleted successfully.' });
  })
);

module.exports = router;