const express = require('express');
const http = require('http');
const https = require('https');
const asyncHandler = require('../utils/asyncHandler');
const { ApiError } = require('../middleware/errorHandler');

const router = express.Router();

function fetchJson(url) {
  return new Promise((resolve, reject) => {
    const client = url.startsWith('https') ? https : http;
    client
      .get(url, (res) => {
        let body = '';
        res.on('data', (chunk) => (body += chunk));
        res.on('end', () => {
          try {
            resolve(JSON.parse(body));
          } catch (e) {
            reject(e);
          }
        });
      })
      .on('error', (err) => reject(err));
  });
}

router.get(
  '/route',
  asyncHandler(async (req, res) => {
    const originLat = parseFloat(req.query.originLat);
    const originLng = parseFloat(req.query.originLng);
    const destLat = parseFloat(req.query.destLat);
    const destLng = parseFloat(req.query.destLng);
    const mode = (req.query.mode || 'driving').toLowerCase(); // driving, walking, cycling

    if (
      Number.isNaN(originLat) ||
      Number.isNaN(originLng) ||
      Number.isNaN(destLat) ||
      Number.isNaN(destLng)
    ) {
      throw new ApiError(400, 'originLat, originLng, destLat, and destLng are required.');
    }

    let osrmProfile = 'driving';
    if (mode === 'walking') osrmProfile = 'foot';
    else if (mode === 'cycling') osrmProfile = 'bike';

    // OSRM expects coordinates in [lng,lat] order
    const url = `http://router.project-osrm.org/route/v1/${osrmProfile}/${originLng},${originLat};${destLng},${destLat}?overview=full&geometries=geojson&steps=true`;

    try {
      const data = await fetchJson(url);

      if (!data.routes || data.routes.length === 0) {
        throw new ApiError(404, 'No route found between coordinates.');
      }

      const route = data.routes[0];
      const coordinates = route.geometry.coordinates.map((coord) => ({
        latitude: coord[1],
        longitude: coord[0],
      }));

      const steps = (route.legs[0]?.steps || []).map((step) => ({
        instruction: `${step.maneuver.type} ${step.name || ''}`.trim(),
        distanceMeters: Math.round(step.distance),
        durationSeconds: Math.round(step.duration),
      }));

      res.json({
        success: true,
        mode,
        distanceMeters: Math.round(route.distance),
        durationSeconds: Math.round(route.duration),
        distanceKm: (route.distance / 1000).toFixed(1),
        durationMins: Math.ceil(route.duration / 60),
        polyline: coordinates,
        steps,
      });
    } catch (err) {
      console.error('OSRM route error:', err);
      // Fallback straight-line calculation if OSRM fails/timeouts
      const R = 6371; // Earth radius in km
      const dLat = ((destLat - originLat) * Math.PI) / 180;
      const dLng = ((destLng - originLng) * Math.PI) / 180;
      const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos((originLat * Math.PI) / 180) *
          Math.cos((destLat * Math.PI) / 180) *
          Math.sin(dLng / 2) *
          Math.sin(dLng / 2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      const distKm = R * c;

      let speedKmH = 40;
      if (mode === 'walking') speedKmH = 5;
      if (mode === 'cycling') speedKmH = 15;
      const durationMins = Math.ceil((distKm / speedKmH) * 60);

      res.json({
        success: true,
        isFallback: true,
        mode,
        distanceKm: distKm.toFixed(1),
        durationMins,
        polyline: [
          { latitude: originLat, longitude: originLng },
          { latitude: destLat, longitude: destLng },
        ],
        steps: [{ instruction: 'Head towards destination', distanceMeters: Math.round(distKm * 1000), durationSeconds: durationMins * 60 }],
      });
    }
  })
);

module.exports = router;
