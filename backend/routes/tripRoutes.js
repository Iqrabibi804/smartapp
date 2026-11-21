const express = require('express');
const Trip = require('../models/Trip');
const Place = require('../models/Place');
const Category = require('../models/Category');
const asyncHandler = require('../utils/asyncHandler');
const { protect } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const { publishedPlaceFilter } = require('../utils/publishedPlaceFilter');

const router = express.Router();

const INTEREST_TO_CATEGORY = {
  food: 'Restaurants',
  nature: 'Parks',
  shopping: 'Shopping',
  history: 'Tourist Attractions',
  religious: 'Religious Places',
};

const PRICE_ESTIMATE = { free: 0, low: 800, medium: 2500, high: 6000 };

async function generateItinerary({ days, interests, travelers }) {
  const categoryNames = (interests || [])
    .map((i) => INTEREST_TO_CATEGORY[i])
    .filter(Boolean);

  let categoryIds = [];
  if (categoryNames.length > 0) {
    const categories = await Category.find({ name: { $in: categoryNames } }).lean();
    categoryIds = categories.map((c) => c._id);
  }

  const filter = { ...publishedPlaceFilter() };
  if (categoryIds.length > 0) filter.categoryId = { $in: categoryIds };

  let places = await Place.find(filter).sort({ rating: -1 }).limit(days * 3).lean();

  if (places.length < days * 2) {
    const fallback = await Place.find(publishedPlaceFilter()).sort({ rating: -1 }).limit(days * 3).lean();
    const seen = new Set(places.map((p) => String(p._id)));
    for (const p of fallback) {
      if (!seen.has(String(p._id))) places.push(p);
      if (places.length >= days * 3) break;
    }
  }

  const timeSlots = ['Morning', 'Afternoon', 'Evening'];
  const itinerary = [];
  let placeIndex = 0;
  let totalCost = 0;

  for (let day = 1; day <= days; day++) {
    const dayPlaces = [];
    for (const slot of timeSlots) {
      const place = places[placeIndex];
      if (!place) break;
      dayPlaces.push({ placeId: place._id, name: place.name, timeSlot: slot });
      totalCost += (PRICE_ESTIMATE[place.priceRange] ?? PRICE_ESTIMATE.medium) * (travelers || 1);
      placeIndex++;
    }
    itinerary.push({ day, places: dayPlaces });
  }

  return { itinerary, estimatedCost: totalCost };
}

router.post(
  '/',
  protect,
  asyncHandler(async (req, res) => {
    const { destination, days, travelers, budget, interests } = req.body;

    if (!destination || !days) {
      throw new ApiError(400, 'destination and days are required.');
    }

    const { itinerary, estimatedCost } = await generateItinerary({
      days: Math.min(Math.max(parseInt(days, 10) || 1, 1), 14),
      interests,
      travelers: travelers || 1,
    });

    const trip = await Trip.create({
      userId: req.user._id,
      destination,
      days,
      travelers: travelers || 1,
      budget: budget || 0,
      interests: interests || [],
      itinerary,
      estimatedCost,
    });

    res.status(201).json({ success: true, trip });
  })
);

router.get(
  '/',
  protect,
  asyncHandler(async (req, res) => {
    const trips = await Trip.find({ userId: req.user._id }).sort({ createdAt: -1 }).lean();
    res.json({ success: true, trips });
  })
);

router.get(
  '/:id',
  protect,
  asyncHandler(async (req, res) => {
    const trip = await Trip.findOne({ _id: req.params.id, userId: req.user._id }).lean();
    if (!trip) throw new ApiError(404, 'Trip not found.');
    res.json({ success: true, trip });
  })
);

router.delete(
  '/:id',
  protect,
  asyncHandler(async (req, res) => {
    await Trip.deleteOne({ _id: req.params.id, userId: req.user._id });
    res.json({ success: true });
  })
);

module.exports = router;