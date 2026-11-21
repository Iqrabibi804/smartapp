const jwt = require('jsonwebtoken');
const User = require('../models/User');
const asyncHandler = require('../utils/asyncHandler');
const { ApiError } = require('../middleware/errorHandler');

function signToken(userId) {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  });
}

// POST /api/auth/register
const register = asyncHandler(async (req, res) => {
  const { name, email, password, city, interests } = req.body;

  const existing = await User.findOne({ email: email.toLowerCase() });
  if (existing) {
    throw new ApiError(409, 'An account with this email already exists.');
  }

  const user = new User({
    name,
    email: email.toLowerCase(),
    city: city || null,
    preferences: { interests: interests || [] },
  });
  await user.setPassword(password);
  await user.save();

  const token = signToken(user._id);
  res.status(201).json({ success: true, token, user });
});

// POST /api/auth/login
const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email: email.toLowerCase() }).select('+passwordHash');
  if (!user) {
    throw new ApiError(401, 'Invalid email or password.');
  }
  if (user.accountStatus !== 'active') {
    throw new ApiError(403, 'This account is not active.');
  }

  const match = await user.comparePassword(password);
  if (!match) {
    throw new ApiError(401, 'Invalid email or password.');
  }

  const token = signToken(user._id);
  res.json({ success: true, token, user });
});

// GET /api/auth/me  (requires `protect` middleware)
const getMe = asyncHandler(async (req, res) => {
  res.json({ success: true, user: req.user });
});

module.exports = { register, login, getMe };
