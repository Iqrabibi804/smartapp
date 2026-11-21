const mongoose = require('mongoose');

const placeSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    description: { type: String, default: '' },
    region: { type: String, required: false, default: 'Punjab' },
    categoryId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Category',
      default: null,
    },

    // GeoJSON point — enables MongoDB $near / $geoWithin queries for
    // "places nearby" (section 11, 19) without a separate geo service.
    location: {
      type: {
        type: String,
        enum: ['Point'],
        default: 'Point',
      },
      coordinates: {
        // [longitude, latitude] — GeoJSON order, not [lat, lng]
        type: [Number],
        required: true,
      },
    },

    address: { type: String, default: '' },
    images: [{ type: String }],

    rating: { type: Number, default: 0, min: 0, max: 5 },
    reviewCount: { type: Number, default: 0 },

    priceRange: {
      type: String,
      enum: ['free', 'low', 'medium', 'high'],
      default: 'medium',
    },

    openingHours: {
      // e.g. { mon: "09:00-22:00", tue: "09:00-22:00", ... }
      type: Map,
      of: String,
      default: {},
    },

    facilities: [{ type: String }], // parking, wifi, wheelchairAccess, etc.

    phone: { type: String, default: null },
    website: { type: String, default: null },

    verified: { type: Boolean, default: false },
    featured: { type: Boolean, default: false },

    submittedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  },
  { timestamps: true }
);

// Required for $near / $geoWithin nearby-search queries.
placeSchema.index({ location: '2dsphere' });
placeSchema.index({ name: 'text', description: 'text' });

module.exports = mongoose.model('Place', placeSchema);
