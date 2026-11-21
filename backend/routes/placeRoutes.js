const express = require('express');
const mongoose = require('mongoose');
const Place = require('../models/Place');
const Category = require('../models/Category');
const asyncHandler = require('../utils/asyncHandler');
const { protect, authorize } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const { publishedPlaceFilter } = require('../utils/publishedPlaceFilter');

const router = express.Router();

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
    const { q, categoryId, categoryName, city, minRating, priceRange, sort } = req.query;
    const lat = parseFloat(req.query.lat);
    const lng = parseFloat(req.query.lng);
    const radiusKm = parseFloat(req.query.radiusKm) || 25;
    const hasLocation = !Number.isNaN(lat) && !Number.isNaN(lng);

    const conditions = [publishedPlaceFilter()];

    if (q && q.trim()) {
      const term = q.trim();
      conditions.push({
        $or: [
          { name: { $regex: term, $options: 'i' } },
          { description: { $regex: term, $options: 'i' } },
          { address: { $regex: term, $options: 'i' } },
        ],
      });
    }

    if (city && city.trim() && city.toLowerCase() !== 'all' && city.toLowerCase() !== 'all cities') {
      const cityRegex = new RegExp(city.trim(), 'i');
      conditions.push({
        $or: [
          { city: cityRegex },
          { address: cityRegex },
          { name: cityRegex },
        ],
      });
    }

    const catParam = categoryId || categoryName;
    if (catParam && catParam.trim() && catParam.toLowerCase() !== 'all') {
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
        }
      }
    }
    if (minRating) {
      conditions.push({ rating: { $gte: parseFloat(minRating) } });
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
    const radiusKm = parseFloat(req.query.radiusKm) || 5;

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
    const place = await Place.findOne({ _id: req.params.id })
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