const jwt = require('jsonwebtoken');
const User = require('../models/User');
const asyncHandler = require('../utils/asyncHandler');
const { ApiError } = require('./errorHandler');

/**
 * Verifies the Bearer JWT on the request and attaches the authenticated
 * user to req.user. Rejects requests for suspended/deleted accounts.
 */
const protect = asyncHandler(async (req, res, next) => {
  const header = req.headers.authorization;

  if (!header || !header.startsWith('Bearer ')) {
    throw new ApiError(401, 'Not authenticated. Missing Bearer token.');
  }

  const token = header.split(' ')[1];
  const decoded = jwt.verify(token, process.env.JWT_SECRET);

  const user = await User.findById(decoded.id);
  if (!user) {
    throw new ApiError(401, 'User for this token no longer exists.');
  }
  if (user.accountStatus !== 'active') {
    throw new ApiError(403, 'This account is not active.');
  }

  req.user = user;
  next();
});

/**
 * Restricts a route to specific roles. Use after `protect`.
 * Example: router.delete('/:id', protect, authorize('admin'), handler)
 */
const authorize = (...allowedRoles) => (req, res, next) => {
  if (!req.user || !allowedRoles.includes(req.user.role)) {
    return next(new ApiError(403, 'You do not have permission to perform this action.'));
  }
  next();
};

module.exports = { protect, authorize };
