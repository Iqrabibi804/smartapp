const test = require('node:test');
const assert = require('node:assert/strict');
const mongoose = require('mongoose');
const Review = require('../models/Review');
const Event = require('../models/Event');
const { publishedPlaceFilter } = require('../utils/publishedPlaceFilter');

test('public place policy allows verified and explicitly community-reported records only', () => {
  const filter = publishedPlaceFilter();
  assert.deepEqual(filter.$or[0].verificationStatus.$in, ['verified', 'community_reported']);
  assert.deepEqual(filter.$or[1], {
    verificationStatus: { $exists: false },
    verified: true,
  });
});

test('review schema rejects ratings outside 1 through 5', () => {
  const review = new Review({
    userId: new mongoose.Types.ObjectId(),
    placeId: new mongoose.Types.ObjectId(),
    rating: 6,
  });
  const error = review.validateSync();
  assert.ok(error);
  assert.ok(error.errors.rating);
});

test('review schema limits comment length and stores unique reporter references', () => {
  const review = new Review({
    userId: new mongoose.Types.ObjectId(),
    placeId: new mongoose.Types.ObjectId(),
    rating: 5,
    comment: 'x'.repeat(2001),
  });
  const error = review.validateSync();
  assert.ok(error);
  assert.ok(error.errors.comment);
  assert.equal(Review.schema.path('reportedBy').instance, 'Array');
});

test('new events default to needs_verification and cannot be published by default', () => {
  const event = new Event({
    name: 'Test event',
    location: { type: 'Point', coordinates: [73.0, 31.0] },
    date: new Date(),
  });
  assert.equal(event.verificationStatus, 'needs_verification');
  assert.equal(event.source, null);
});
