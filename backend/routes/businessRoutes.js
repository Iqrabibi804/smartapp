const express = require('express');
const Business = require('../models/Business');
const Place = require('../models/Place');
const Review = require('../models/Review');
const SavedPlace = require('../models/SavedPlace');
const asyncHandler = require('../utils/asyncHandler');
const { recordAudit } = require('../utils/audit');
const { protect, authorize } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');

const router = express.Router();

router.post(
  '/',
  protect,
  asyncHandler(async (req, res) => {
    const {
      name,
      description,
      categoryId,
      latitude,
      longitude,
      address,
      phone,
      website,
      services,
      facilities,
      priceRange,
      images,
    } = req.body;

    if (!name || !address || latitude === undefined || longitude === undefined) {
      throw new ApiError(400, 'name, address, latitude and longitude are required.');
    }

    const business = await Business.create({
      ownerId: req.user._id,
      name,
      description,
      categoryId: categoryId || null,
      location: { type: 'Point', coordinates: [longitude, latitude] },
      address,
      phone,
      website,
      services: services || [],
      facilities: facilities || [],
      priceRange: priceRange || 'medium',
      images: Array.isArray(images) ? images : [],
      status: 'pending',
    });

    res.status(201).json({ success: true, business });
  })
);

router.get(
  '/mine',
  protect,
  asyncHandler(async (req, res) => {
    const businesses = await Business.find({ ownerId: req.user._id })
      .sort({ createdAt: -1 })
      .lean();
    res.json({ success: true, businesses });
  })
);

router.get(
  '/',
  protect,
  authorize('admin'),
  asyncHandler(async (req, res) => {
    const filter = {};
    if (req.query.status) filter.status = req.query.status;

    const businesses = await Business.find(filter)
      .populate('ownerId', 'name email')
      .sort({ createdAt: -1 })
      .lean();
    res.json({ success: true, businesses });
  })
);

router.put(
  '/:id',
  protect,
  asyncHandler(async (req, res) => {
    const business = await Business.findById(req.params.id);
    if (!business) throw new ApiError(404, 'Business not found.');
    if (String(business.ownerId) !== String(req.user._id) && req.user.role !== 'admin') {
      throw new ApiError(403, 'Not authorized to edit this business.');
    }

    const {
      name,
      description,
      categoryId,
      latitude,
      longitude,
      address,
      phone,
      website,
      services,
      facilities,
      priceRange,
      images,
    } = req.body;

    if (name) business.name = name;
    if (description !== undefined) business.description = description;
    if (categoryId !== undefined) business.categoryId = categoryId;
    if (latitude !== undefined && longitude !== undefined) {
      business.location = { type: 'Point', coordinates: [longitude, latitude] };
    }
    if (address !== undefined) business.address = address;
    if (phone !== undefined) business.phone = phone;
    if (website !== undefined) business.website = website;
    if (services !== undefined) business.services = services;
    if (facilities !== undefined) business.facilities = facilities;
    if (priceRange !== undefined) business.priceRange = priceRange;
    if (images !== undefined) business.images = images;

    await business.save();

    if (business.placeId) {
      const updateData = {
        name: business.name,
        description: business.description,
        categoryId: business.categoryId,
        address: business.address,
        phone: business.phone,
        website: business.website,
        facilities: business.facilities,
        priceRange: business.priceRange,
        images: business.images,
      };
      if (latitude !== undefined && longitude !== undefined) {
        updateData.location = business.location;
      }
      await Place.findByIdAndUpdate(business.placeId, updateData);
    }

    res.json({ success: true, business });
  })
);

router.get(
  '/:id/analytics',
  protect,
  asyncHandler(async (req, res) => {
    const business = await Business.findById(req.params.id);
    if (!business) throw new ApiError(404, 'Business not found.');
    if (String(business.ownerId) !== String(req.user._id) && req.user.role !== 'admin') {
      throw new ApiError(403, 'Not authorized to view analytics for this business.');
    }

    let savedCount = 0;
    let reviewCount = 0;
    let averageRating = 0;

    if (business.placeId) {
      const place = await Place.findById(business.placeId);
      if (place) {
        reviewCount = place.reviewCount;
        averageRating = place.rating;
      }
      savedCount = await SavedPlace.countDocuments({ placeId: business.placeId });
    }

    res.json({
      success: true,
      analytics: {
        savedCount,
        reviewCount,
        averageRating,
        status: business.status,
      },
    });
  })
);

router.put(
  '/:id/status',
  protect,
  authorize('admin'),
  asyncHandler(async (req, res) => {
    const { status, rejectionReason } = req.body;
    if (!['pending', 'verified', 'rejected', 'suspended'].includes(status)) {
      throw new ApiError(400, 'Invalid status.');
    }

    const business = await Business.findById(req.params.id);
    if (!business) throw new ApiError(404, 'Business not found.');

    business.status = status;
    business.rejectionReason = status === 'rejected' ? rejectionReason || null : null;

    if (status === 'verified' && !business.placeId) {
      const place = await Place.create({
        name: business.name,
        description: business.description,
        categoryId: business.categoryId,
        location: business.location,
        address: business.address,
        images: business.images,
        priceRange: business.priceRange,
        facilities: business.facilities,
        phone: business.phone,
        website: business.website,
        verified: true,
        verificationStatus: 'verified',
        lastVerifiedAt: new Date(),
        source: 'Business owner submission, verified by moderator',
        submittedBy: business.ownerId,
      });
      business.placeId = place._id;
    }

    if (status !== 'verified' && business.placeId) {
      await Place.findByIdAndUpdate(business.placeId, {
        verified: false,
        verificationStatus: 'needs_verification',
        lastVerifiedAt: null,
      });
    } else if (status === 'verified' && business.placeId) {
      await Place.findByIdAndUpdate(business.placeId, {
        verified: true,
        verificationStatus: 'verified',
        lastVerifiedAt: new Date(),
      });
    }

    await business.save();

    await recordAudit(req, {
      action: 'business.status.update',
      targetType: 'Business',
      targetId: business._id,
      metadata: { status, placeId: business.placeId ? String(business.placeId) : null },
    });

    res.json({ success: true, business });
  })
);

module.exports = router;