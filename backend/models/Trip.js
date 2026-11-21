const mongoose = require('mongoose');

const tripSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    destination: { type: String, required: true, trim: true },
    days: { type: Number, required: true, min: 1, max: 14 },
    travelers: { type: Number, default: 1, min: 1 },
    budget: { type: Number, default: 0 },
    interests: [{ type: String }],
    itinerary: [
      {
        day: Number,
        places: [
          {
            placeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Place' },
            name: String,
            timeSlot: String,
          },
        ],
      },
    ],
    estimatedCost: { type: Number, default: 0 },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Trip', tripSchema);