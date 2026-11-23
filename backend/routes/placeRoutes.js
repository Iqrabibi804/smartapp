const express = require('express');
const mongoose = require('mongoose');
const Place = require('../models/Place');
const Category = require('../models/Category');
const asyncHandler = require('../utils/asyncHandler');
const { protect, authorize } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const { publishedPlaceFilter } = require('../utils/publishedPlaceFilter');

const router = express.Router();

const escapeRegex = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

function readStringParam(value, name, maxLength = 100) {
  if (value === undefined) return undefined;
  if (typeof value !== 'string') {
    throw new ApiError(400, `${name} must be a string.`);
  }
  const normalized = value.trim();
  if (normalized.length > maxLength) {
    throw new ApiError(400, `${name} must be ${maxLength} characters or fewer.`);
  }
  return normalized;
}

function readCoordinate(value, name, min, max) {
  if (value === undefined) return undefined;
  const parsed = Number(value);
  if (!Number.isFinite(parsed) || parsed < min || parsed > max) {
    throw new ApiError(400, `${name} must be between ${min} and ${max}.`);
  }
  return parsed;
}

function readRadius(value, fallback) {
  if (value === undefined) return fallback;
  const parsed = Number(value);
  if (!Number.isFinite(parsed) || parsed <= 0 || parsed > 100) {
    throw new ApiError(400, 'radiusKm must be greater than 0 and no more than 100.');
  }
  return parsed;
}

router.get(
  '/',
  asyncHandler(async (req, res) => {
    const page = Math.max(parseInt(req.query.page, 10) || 1, 1);
    const limit = Math.min(parseInt(req.query.limit, 10) || 20, 100);

    const [places, total] = await Promise.all([
      Place.find(publishedPlaceFilter())
        .populate('categoryId', 'name icon')
        .skip((page - 1) * limit)
        .limit(limit)
        .lean(),
      Place.countDocuments(publishedPlaceFilter()),
    ]);

    res.json({ success: true, page, limit, total, places });
  })
);

router.get(
  '/search',
  asyncHandler(async (req, res) => {
    const q = readStringParam(req.query.q, 'q', 100);
    const categoryId = readStringParam(req.query.categoryId, 'categoryId', 100);
    const categoryName = readStringParam(req.query.categoryName, 'categoryName', 100);
    const city = readStringParam(req.query.city, 'city', 100);
    const sort = readStringParam(req.query.sort, 'sort', 20);
    const priceRange = readStringParam(req.query.priceRange, 'priceRange', 20);
    const minRatingValue = req.query.minRating === undefined ? undefined : Number(req.query.minRating);
    if (minRatingValue !== undefined && (!Number.isFinite(minRatingValue) || minRatingValue < 0 || minRatingValue > 5)) {
      throw new ApiError(400, 'minRating must be between 0 and 5.');
    }
    if (priceRange !== undefined && !['free', 'low', 'medium', 'high'].includes(priceRange)) {
      throw new ApiError(400, 'priceRange must be free, low, medium, or high.');
    }
    if (sort !== undefined && !['rating', 'popular'].includes(sort)) {
      throw new ApiError(400, 'sort must be rating or popular.');
    }

    const lat = readCoordinate(req.query.lat, 'lat', -90, 90);
    const lng = readCoordinate(req.query.lng, 'lng', -180, 180);
    if ((lat === undefined) !== (lng === undefined)) {
      throw new ApiError(400, 'lat and lng must be provided together.');
    }
    const radiusKm = readRadius(req.query.radiusKm, 25);
    const hasLocation = lat !== undefined && lng !== undefined;

    const conditions = [publishedPlaceFilter()];

    if (q) {
      const term = escapeRegex(q);
      conditions.push({
        $or: [
          { name: { $regex: term, $options: 'i' } },
          { description: { $regex: term, $options: 'i' } },
          { address: { $regex: term, $options: 'i' } },
        ],
      });
    }

    if (city && city.toLowerCase() !== 'all' && city.toLowerCase() !== 'all cities') {
      const cityRegex = new RegExp(escapeRegex(city), 'i');
      conditions.push({
        $or: [
          { city: cityRegex },
          { address: cityRegex },
          { name: cityRegex },
        ],
      });
    }

    const catParam = categoryId || categoryName;
    if (catParam && catParam.toLowerCase() !== 'all') {
      if (mongoose.Types.ObjectId.isValid(catParam)) {
        conditions.push({ categoryId: new mongoose.Types.ObjectId(catParam) });
      } else {
        let searchPattern = catParam.trim();
        if (/hospital|medical|clinic/i.test(searchPattern)) searchPattern = 'Hospital';
        else if (/cake|baker|sweet/i.test(searchPattern)) searchPattern = 'Baker';
        else if (/hotel|guest/i.test(searchPattern)) searchPattern = 'Hotel';
        else if (/fast.?food|burger|pizza|fried/i.test(searchPattern)) searchPattern = 'Fast Food';
        else if (/restaurant|food|dining/i.test(searchPattern)) searchPattern = 'Restaurant';
        else if (/tourist|attraction|sight/i.test(searchPattern)) searchPattern = 'Tourist';
        else if (/histor|religio|shrine|mosque|heritage|monument/i.test(searchPattern)) searchPattern = 'Historical';
        else if (/adventure|trek|hiking|jeep/i.test(searchPattern)) searchPattern = 'Adventure';
        else if (/family|kids|children/i.test(searchPattern)) searchPattern = 'Family';
        else if (/nature|park|natural|garden/i.test(searchPattern)) searchPattern = 'Park';
        else if (/shopp|market|bazaar|mall/i.test(searchPattern)) searchPattern = 'Shopping';

        const matchedCats = await Category.find({ name: { $regex: searchPattern, $options: 'i' } });
        if (matchedCats.length > 0) {
          conditions.push({ categoryId: { $in: matchedCats.map(c => c._id) } });
        } else {
          // An unknown category must not silently broaden the search to every place.
          conditions.push({ _id: { $in: [] } });
        }
      }
    }
    if (minRatingValue !== undefined) {
      conditions.push({ rating: { $gte: minRatingValue } });
    }
    if (priceRange) {
      conditions.push({ priceRange: priceRange });
    }

    const filter = conditions.length === 1 ? conditions[0] : { $and: conditions };

    let query;
    if (hasLocation) {
      filter.location = {
        $near: {
          $geometry: { type: 'Point', coordinates: [lng, lat] },
          $maxDistance: radiusKm * 1000,
        },
      };
      query = Place.find(filter).populate('categoryId', 'name icon');
    } else {
      query = Place.find(filter).populate('categoryId', 'name icon');
      if (sort === 'rating') query = query.sort({ rating: -1 });
      else if (sort === 'popular') query = query.sort({ reviewCount: -1 });
    }

    const places = await query.limit(50).lean();
    res.json({ success: true, count: places.length, places });
  })
);

router.get(
  '/nearby',
  asyncHandler(async (req, res) => {
    const lat = parseFloat(req.query.lat);
    const lng = parseFloat(req.query.lng);
    const radiusKm = readRadius(req.query.radiusKm, 5);

    if (Number.isNaN(lat) || Number.isNaN(lng)) {
      return res.status(400).json({ success: false, message: 'lat and lng query params are required.' });
    }

    const places = await Place.find({
      ...publishedPlaceFilter(),
      location: {
        $near: {
          $geometry: { type: 'Point', coordinates: [lng, lat] },
          $maxDistance: radiusKm * 1000,
        },
      },
    })
      .populate('categoryId', 'name icon')
      .limit(100)
      .lean();

    res.json({ success: true, count: places.length, places });
  })
);

router.get(
  '/:id',
  asyncHandler(async (req, res) => {
    const place = await Place.findOne({ _id: req.params.id, ...publishedPlaceFilter() })
      .populate('categoryId', 'name icon')
      .lean();

    if (!place) {
      return res.status(404).json({ success: false, message: 'Place not found.' });
    }

    const nearbyFilter = {
      _id: { $ne: place._id },
      ...publishedPlaceFilter(),
      location: {
        $near: {
          $geometry: place.location,
          $maxDistance: 10000,
        },
      },
    };
    if (place.categoryId) nearbyFilter.categoryId = place.categoryId._id || place.categoryId;

    const related = await Place.find(nearbyFilter).limit(6).lean();

    res.json({ success: true, place, related });
  })
);

router.post(
  '/',
  protect,
  authorize('admin'),
  asyncHandler(async (req, res) => {
    const place = await Place.create({ ...req.body, submittedBy: req.user._id });
    res.status(201).json({ success: true, place });
  })
);

router.put(
  '/:id',
  protect,
  authorize('admin'),
  asyncHandler(async (req, res) => {
    const place = await Place.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!place) throw new ApiError(404, 'Place not found.');
    res.json({ success: true, place });
  })
);

router.delete(
  '/:id',
  protect,
  authorize('admin'),
  asyncHandler(async (req, res) => {
    const place = await Place.findByIdAndDelete(req.params.id);
    if (!place) throw new ApiError(404, 'Place not found.');
    res.json({ success: true, message: 'Place deleted.' });
  })
);

module.exports = router;