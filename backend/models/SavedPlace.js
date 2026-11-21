const mongoose = require('mongoose');

const savedPlaceSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    placeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Place', required: true },
  },
  { timestamps: true }
);

savedPlaceSchema.index({ userId: 1, placeId: 1 }, { unique: true });

module.exports = mongoose.model('SavedPlace', savedPlaceSchema);