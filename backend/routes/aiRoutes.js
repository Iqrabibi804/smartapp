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

function explainPlace(place, filters, usedFallback = false) {
  if (usedFallback) {
    return `${place.name} is a nearby alternative. Its category, price, or rating may not match every filter you requested.`;
  }

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

    if (typeof message !== 'string' || !message.trim() || message.length > 500) {
      return res.status(400).json({ success: false, message: 'A message between 1 and 500 characters is required.' });
    }

    const hasLat = lat !== undefined && lat !== null;
    const hasLng = lng !== undefined && lng !== null;
    if (hasLat !== hasLng) {
      return res.status(400).json({ success: false, message: 'lat and lng must be provided together.' });
    }
    if (hasLat && (
      typeof lat !== 'number' || !Number.isFinite(lat) || lat < -90 || lat > 90 ||
      typeof lng !== 'number' || !Number.isFinite(lng) || lng < -180 || lng > 180
    )) {
      return res.status(400).json({ success: false, message: 'Invalid latitude or longitude.' });
    }

    const filters = await parseQuery(message);

    const query = { ...publishedPlaceFilter() };
    if (filters.categoryId) query.categoryId = filters.categoryId;
    if (filters.priceRange) query.priceRange = filters.priceRange;
    if (filters.minRating) query.rating = { $gte: filters.minRating };

    const hasLocation = hasLat && hasLng;
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
      explanation: explainPlace(place, filters, usedFallback),
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