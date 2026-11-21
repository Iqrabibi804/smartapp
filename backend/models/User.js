const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const PREFERENCE_INTERESTS = [
  'food', 'nature', 'shopping', 'history', 'adventure',
  'familyActivities', 'sports', 'education', 'entertainment', 'budgetTravel',
];

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Full name is required'],
      trim: true,
      minlength: 2,
      maxlength: 100,
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      lowercase: true,
      trim: true,
      match: [/^\S+@\S+\.\S+$/, 'Please provide a valid email'],
    },
    // Never store plain-text passwords (spec section 8/52).
    passwordHash: {
      type: String,
      required: true,
      select: false, // excluded from queries by default
    },
    profileImage: { type: String, default: null },
    city: { type: String, default: null },
    role: {
      type: String,
      enum: ['user', 'businessOwner', 'admin'],
      default: 'user',
    },
    preferences: {
      interests: [{ type: String, enum: PREFERENCE_INTERESTS }],
    },
    accountStatus: {
      type: String,
      enum: ['active', 'suspended', 'deleted'],
      default: 'active',
    },
    emailVerified: { type: Boolean, default: false },
  },
  { timestamps: true } // createdAt / updatedAt
);

// Hash password before saving whenever it's set/changed.
userSchema.methods.setPassword = async function setPassword(plainPassword) {
  const salt = await bcrypt.genSalt(12);
  this.passwordHash = await bcrypt.hash(plainPassword, salt);
};

userSchema.methods.comparePassword = function comparePassword(plainPassword) {
  return bcrypt.compare(plainPassword, this.passwordHash);
};

// Never leak the password hash if a user doc is serialized.
userSchema.set('toJSON', {
  transform: (_doc, ret) => {
    delete ret.passwordHash;
    return ret;
  },
});

module.exports = mongoose.model('User', userSchema);
module.exports.PREFERENCE_INTERESTS = PREFERENCE_INTERESTS;
