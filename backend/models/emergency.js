const mongoose = require('mongoose');

const emergencySchema = new mongoose.Schema({
  city: { type: String, required: true, unique: true },
  police: [
    {
      name: { type: String, required: true },
      phone: { type: String, required: true },
      language: { type: String, default: 'ur' },
    },
  ],
  hospital: [
    {
      name: { type: String, required: true },
      phone: { type: String, required: true },
      language: { type: String, default: 'ur' },
    },
  ],
  touristHelpline: {
    phone: { type: String, required: true },
    smsKeyword: { type: String, default: 'SOS' },
  },
}, { timestamps: true });


module.exports = mongoose.model('Emergency', emergencySchema);
