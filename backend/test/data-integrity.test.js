const test = require('node:test');
const assert = require('node:assert/strict');
const mongoose = require('mongoose');
const Review = require('../models/Review');
const Event = require('../models/Event');
const { publishedPlaceFilter } = require('../utils/publishedPlaceFilter');
const { withPlaceVerification } = require('../utils/placeVerification');

test('public place policy requires source and timestamp for verified records', () => {
  const filter = publishedPlaceFilter();
  assert.equal(filter.$or[0].verificationStatus, 'verified');
  assert.deepEqual(filter.$or[0].source, { $type: 'string', $ne: '' });
  assert.deepEqual(filter.$or[0].lastVerifiedAt, { $type: 'date' });
  assert.deepEqual(filter.$or[1], { verificationStatus: 'community_reported' });
  assert.equal(filter.$or[2].verificationStatus.$exists, false);
  assert.equal(filter.$or[2].verified, true);
  assert.deepEqual(filter.$or[2].source, { $type: 'string', $ne: '' });
  assert.deepEqual(filter.$or[2].lastVerifiedAt, { $type: 'date' });
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

test('place verification requires a source reference', () => {
  assert.throws(() => withPlaceVerification({ verified: true }), /source reference is required/i);
});

test('place verification records source and verification timestamp', () => {
  const update = withPlaceVerification({ verificationStatus: 'verified', source: 'https://official.example/place' });
  assert.equal(update.verified, true);
  assert.equal(update.verificationStatus, 'verified');
  assert.equal(update.source, 'https://official.example/place');
  assert.ok(update.lastVerifiedAt instanceof Date);
});

test('ordinary place edits do not silently refresh verification timestamp', () => {
  const priorDate = new Date('2026-01-01T00:00:00.000Z');
  const update = withPlaceVerification({ description: 'Updated description' }, {
    verified: true,
    verificationStatus: 'verified',
    source: 'https://official.example/place',
    lastVerifiedAt: priorDate,
  });
  assert.equal(update.lastVerifiedAt, undefined);
});
