const express = require('express');
const mongoose = require('mongoose');
const Review = require('../models/Review');
const Place = require('../models/Place');
const Business = require('../models/Business');
const asyncHandler = require('../utils/asyncHandler');
const { protect } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const { publishedPlaceFilter } = require('../utils/publishedPlaceFilter');

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
    if (!mongoose.Types.ObjectId.isValid(req.params.placeId)) {
      throw new ApiError(400, 'A valid placeId is required.');
    }
    const place = await Place.findOne({
      _id: req.params.placeId,
      ...publishedPlaceFilter(),
    }).select('_id').lean();
    if (!place) throw new ApiError(404, 'Published place not found.');

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

    if (!placeId || !mongoose.Types.ObjectId.isValid(placeId)) {
      throw new ApiError(400, 'A valid placeId is required.');
    }
    const numericRating = Number(rating);
    if (!Number.isInteger(numericRating) || numericRating < 1 || numericRating > 5) {
      throw new ApiError(400, 'rating must be a whole number between 1 and 5.');
    }
    if (comment !== undefined && (typeof comment !== 'string' || comment.length > 2000)) {
      throw new ApiError(400, 'comment must be a string of no more than 2000 characters.');
    }
    if (images !== undefined && (!Array.isArray(images) || images.length > 5 || images.some((image) => typeof image !== 'string' || image.length > 1000))) {
      throw new ApiError(400, 'images must be an array of up to 5 valid image URLs.');
    }
    const place = await Place.findOne({ _id: placeId, ...publishedPlaceFilter() }).select('_id').lean();
    if (!place) throw new ApiError(404, 'Published place not found.');

    const existing = await Review.findOne({ userId: req.user._id, placeId });
    if (existing) {
      throw new ApiError(409, 'You have already reviewed this place. Edit your existing review instead.');
    }

    const review = await Review.create({
      userId: req.user._id,
      placeId,
      rating: numericRating,
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

    if (req.body.rating !== undefined) {
      const rating = Number(req.body.rating);
      if (!Number.isInteger(rating) || rating < 1 || rating > 5) {
        throw new ApiError(400, 'rating must be a whole number between 1 and 5.');
      }
      review.rating = rating;
    }
    if (req.body.comment !== undefined) {
      if (typeof req.body.comment !== 'string' || req.body.comment.length > 2000) {
        throw new ApiError(400, 'comment must be a string of no more than 2000 characters.');
      }
      review.comment = req.body.comment;
    }
    if (req.body.images !== undefined) {
      if (!Array.isArray(req.body.images) || req.body.images.length > 5 || req.body.images.some((image) => typeof image !== 'string' || image.length > 1000)) {
        throw new ApiError(400, 'images must be an array of up to 5 valid image URLs.');
      }
      review.images = req.body.images;
    }
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

    if (String(review.userId) === String(req.user._id)) {
      throw new ApiError(400, 'You cannot report your own review.');
    }
    const alreadyReported = (review.reportedBy || []).some((id) => String(id) === String(req.user._id));
    if (alreadyReported) {
      throw new ApiError(409, 'You have already reported this review.');
    }
    review.reportedBy.push(req.user._id);
    review.reportCount = review.reportedBy.length;
    if (review.reportCount >= 3) review.status = 'reported';
    await review.save();
    if (review.status === 'reported') await recalculatePlaceRating(review.placeId);

    res.json({ success: true, message: 'Report recorded. Repeated reports from the same account are not counted again.' });
  })
);

router.post(
  '/reviews/:id/reply',
  protect,
  asyncHandler(async (req, res) => {
    const { comment } = req.body;
    if (typeof comment !== 'string' || !comment.trim() || comment.length > 2000) {
      throw new ApiError(400, 'Reply comment is required and must be no more than 2000 characters.');
    }

    const review = await Review.findById(req.params.id);
    if (!review) throw new ApiError(404, 'Review not found.');

    const business = await Business.findOne({ placeId: review.placeId, ownerId: req.user._id, status: 'verified' });
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