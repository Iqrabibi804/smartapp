const validator = require('validator');
const { ApiError } = require('./errorHandler');

/**
 * Enforces the registration password policy from spec section 8:
 * minimum length, at least one letter and one number.
 */
function isStrongPassword(password) {
  return (
    typeof password === 'string' &&
    password.length >= 8 &&
    /[A-Za-z]/.test(password) &&
    /[0-9]/.test(password)
  );
}

const validateRegister = (req, res, next) => {
  const { name, email, password, confirmPassword } = req.body;

  if (!name || name.trim().length < 2) {
    return next(new ApiError(400, 'Full name must be at least 2 characters.'));
  }
  if (!email || !validator.isEmail(email)) {
    return next(new ApiError(400, 'A valid email is required.'));
  }
  if (!isStrongPassword(password)) {
    return next(
      new ApiError(400, 'Password must be at least 8 characters and include a letter and a number.')
    );
  }
  if (password !== confirmPassword) {
    return next(new ApiError(400, 'Passwords do not match.'));
  }

  next();
};

const validateLogin = (req, res, next) => {
  const { email, password } = req.body;
  if (!email || !validator.isEmail(email)) {
    return next(new ApiError(400, 'A valid email is required.'));
  }
  if (!password) {
    return next(new ApiError(400, 'Password is required.'));
  }
  next();
};

module.exports = { validateRegister, validateLogin, isStrongPassword };
