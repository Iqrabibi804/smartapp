const express = require('express');
const Place = require('../models/Place');
const Category = require('../models/Category');
const asyncHandler = require('../utils/asyncHandler');
const { publishedPlaceFilter } = require('../utils/publishedPlaceFilter');

const router = express.Router();

async function parseQuery(message) {
  const text = message.toLowerCase();
  const filters = {};

  const categories = await Category.find().lean();
  for (const cat of categories) {
    const singular = cat.name.toLowerCase().replace(/s$/, '');
    if (text.includes(cat.name.toLowerCase()) || text.includes(singular)) {
      filters.categoryId = cat._id;
      break;
    }
  }

  if (/\b(cheap|affordable|budget|inexpensive)\b/.test(text)) {
    filters.priceRange = 'low';
  } else if (/\b(free)\b/.test(text)) {
    filters.priceRange = 'free';
  } else if (/\b(luxury|expensive|upscale|high[- ]end)\b/.test(text)) {
    filters.priceRange = 'high';
  }

  if (/\b(best|top|highly rated|great)\b/.test(text)) {
    filters.minRating = 4;
  }

  return filters;
}

function explainPlace(place, filters) {
  const reasons = [];
  if (filters.categoryId) reasons.push('matches what you asked for');
  if (filters.priceRange === 'low') reasons.push('is budget-friendly');
  if (filters.priceRange === 'free') reasons.push('is free to visit');
  if (filters.priceRange === 'high') reasons.push('is a higher-end option');
  if (filters.minRating) reasons.push(`has a strong rating (${place.rating}★)`);
  if (reasons.length === 0) reasons.push(`has a ${place.rating}★ rating from ${place.reviewCount} reviews`);

  return `${place.name} ${reasons.join(' and ')}.`;
}

router.post(
  '/recommend',
  asyncHandler(async (req, res) => {
    const { message, lat, lng } = req.body;

    if (!message || !message.trim()) {
      return res.status(400).json({ success: false, message: 'A message is required.' });
    }

    const filters = await parseQuery(message);

    const query = { ...publishedPlaceFilter() };
    if (filters.categoryId) query.categoryId = filters.categoryId;
    if (filters.priceRange) query.priceRange = filters.priceRange;
    if (filters.minRating) query.rating = { $gte: filters.minRating };

    const hasLocation = typeof lat === 'number' && typeof lng === 'number';
    if (hasLocation) {
      query.location = {
        $near: {
          $geometry: { type: 'Point', coordinates: [lng, lat] },
          $maxDistance: 15000,
        },
      };
    }

    let places = await Place.find(query).populate('categoryId', 'name').limit(5).lean();

    let usedFallback = false;
    if (places.length === 0) {
      const fallbackQuery = { ...publishedPlaceFilter() };
      if (hasLocation) fallbackQuery.location = query.location;
      places = await Place.find(fallbackQuery).populate('categoryId', 'name').sort({ rating: -1 }).limit(5).lean();
      usedFallback = true;
    }

    const recommendations = places.map((place) => ({
      place,
      explanation: explainPlace(place, filters),
    }));

    let reply =
      places.length === 0
        ? "I don't have verified information for that place in our database."
        : usedFallback
        ? "I couldn't find an exact match for your request, but here are some top-rated places nearby:"
        : `Here are some places matching "${message}":`;

    res.json({ success: true, reply, recommendations });
  })
);

module.exports = router;