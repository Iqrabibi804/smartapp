const AuditLog = require('../models/AuditLog');

/**
 * Records a moderator/admin action. Audit failures are logged but never block
 * the underlying action response.
 */
async function recordAudit(req, { action, targetType, targetId = null, metadata = {} }) {
  try {
    await AuditLog.create({
      actor: req.user._id,
      action,
      targetType,
      targetId: targetId === null ? null : String(targetId),
      metadata,
      ip: req.ip || null,
    });
  } catch (err) {
    console.error('Audit log write failed:', err.message);
  }
}

module.exports = { recordAudit };
