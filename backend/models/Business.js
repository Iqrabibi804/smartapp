const mongoose = require('mongoose');

const businessSchema = new mongoose.Schema(
  {
    ownerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    name: { type: String, required: true, trim: true },
    description: { type: String, default: '' },
    categoryId: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', default: null },
    location: {
      type: { type: String, enum: ['Point'], default: 'Point' },
      coordinates: { type: [Number], required: true },
    },
    address: { type: String, required: true },
    phone: { type: String, default: null },
    website: { type: String, default: null },
    openingHours: { type: Map, of: String, default: {} },
    images: [{ type: String }],
    services: [{ type: String }],
    facilities: [{ type: String }],
    priceRange: {
      type: String,
      enum: ['free', 'low', 'medium', 'high'],
      default: 'medium',
    },
    status: {
      type: String,
      enum: ['pending', 'verified', 'rejected', 'suspended'],
      default: 'pending',
    },
    placeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Place', default: null },
    rejectionReason: { type: String, default: null },
  },
  { timestamps: true }
);

businessSchema.index({ location: '2dsphere' });

module.exports = mongoose.model('Business', businessSchema);