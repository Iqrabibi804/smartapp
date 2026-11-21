/**
 * Custom error class for API responses.
 * Mirrors the typical pattern used in many Express apps.
 * Usage: `return next(new ApiError(404, 'Not found'))`.
 */
class ApiError extends Error {
  /**
   * @param {number} statusCode HTTP status code to send
   * @param {string} message Human‑readable error message
   */
  constructor(statusCode, message) {
    super(message);
    this.statusCode = statusCode;
    // Flag used by error‑handling middleware to differentiate operational errors
    this.isOperational = true;
    // Capture stack trace excluding constructor call
    Error.captureStackTrace(this, this.constructor);
  }
}

module.exports = ApiError;
