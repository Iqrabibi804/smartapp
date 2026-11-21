const express = require('express');
const Review = require('../models/Review');
const Place = require('../models/Place');
const Business = require('../models/Business');
const asyncHandler = require('../utils/asyncHandler');
const { protect } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');

const router = express.Router();

async function recalculatePlaceRating(placeId) {
  const stats = await Review.aggregate([
    { $match: { placeId, status: 'approved' } },
    { $group: { _id: '$placeId', avgRating: { $avg: '$rating' }, count: { $sum: 1 } } },
  ]);

  const avgRating = stats[0]?.avgRating || 0;
  const count = stats[0]?.count || 0;

  await Place.findByIdAndUpdate(placeId, {
    rating: Math.round(avgRating * 10) / 10,
    reviewCount: count,
  });
}

router.get(
  '/places/:placeId/reviews',
  asyncHandler(async (req, res) => {
    const reviews = await Review.find({ placeId: req.params.placeId, status: 'approved' })
      .populate('userId', 'name profileImage')
      .sort({ createdAt: -1 })
      .lean();

    res.json({ success: true, reviews });
  })
);

router.post(
  '/reviews',
  protect,
  asyncHandler(async (req, res) => {
    const { placeId, rating, comment, images } = req.body;

    if (!placeId || !rating) {
      throw new ApiError(400, 'placeId and rating are required.');
    }

    const existing = await Review.findOne({ userId: req.user._id, placeId });
    if (existing) {
      throw new ApiError(409, 'You have already reviewed this place. Edit your existing review instead.');
    }

    const review = await Review.create({
      userId: req.user._id,
      placeId,
      rating,
      comment: comment || '',
      images: Array.isArray(images) ? images : [],
    });

    await recalculatePlaceRating(placeId);

    res.status(201).json({ success: true, review });
  })
);

router.put(
  '/reviews/:id',
  protect,
  asyncHandler(async (req, res) => {
    const review = await Review.findById(req.params.id);
    if (!review) throw new ApiError(404, 'Review not found.');
    if (String(review.userId) !== String(req.user._id)) {
      throw new ApiError(403, 'You can only edit your own review.');
    }

    if (req.body.rating) review.rating = req.body.rating;
    if (req.body.comment !== undefined) review.comment = req.body.comment;
    if (req.body.images !== undefined) review.images = req.body.images;
    await review.save();

    await recalculatePlaceRating(review.placeId);

    res.json({ success: true, review });
  })
);

router.delete(
  '/reviews/:id',
  protect,
  asyncHandler(async (req, res) => {
    const review = await Review.findById(req.params.id);
    if (!review) throw new ApiError(404, 'Review not found.');
    if (String(review.userId) !== String(req.user._id) && req.user.role !== 'admin') {
      throw new ApiError(403, 'You can only delete your own review.');
    }

    const placeId = review.placeId;
    await review.deleteOne();
    await recalculatePlaceRating(placeId);

    res.json({ success: true });
  })
);

router.post(
  '/reviews/:id/report',
  protect,
  asyncHandler(async (req, res) => {
    const review = await Review.findById(req.params.id);
    if (!review) throw new ApiError(404, 'Review not found.');

    review.reportCount += 1;
    review.status = 'reported';
    await review.save();

    res.json({ success: true, message: 'Review reported. An admin will review it.' });
  })
);

router.post(
  '/reviews/:id/reply',
  protect,
  asyncHandler(async (req, res) => {
    const { comment } = req.body;
    if (!comment || !comment.trim()) {
      throw new ApiError(400, 'Reply comment is required.');
    }

    const review = await Review.findById(req.params.id);
    if (!review) throw new ApiError(404, 'Review not found.');

    const business = await Business.findOne({ placeId: review.placeId, ownerId: req.user._id });
    if (!business && req.user.role !== 'admin') {
      throw new ApiError(403, 'Only the verified business owner can reply to this review.');
    }

    review.ownerReply = {
      comment: comment.trim(),
      createdAt: new Date(),
    };
    await review.save();

    res.json({ success: true, review });
  })
);

module.exports = router;