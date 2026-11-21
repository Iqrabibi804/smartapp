const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    placeId: { type: mongoose.Schema.Types.ObjectId, ref: 'Place', required: true },
    rating: { type: Number, required: true, min: 1, max: 5 },
    comment: { type: String, default: '', maxlength: 2000 },
    images: [{ type: String }],
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected', 'reported'],
      default: 'approved',
    },
    reportCount: { type: Number, default: 0 },
    ownerReply: {
      comment: { type: String, default: '' },
      createdAt: { type: Date },
    },
  },
  { timestamps: true }
);

reviewSchema.index({ userId: 1, placeId: 1 }, { unique: true });

module.exports = mongoose.model('Review', reviewSchema);