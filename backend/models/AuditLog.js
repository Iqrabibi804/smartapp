const mongoose = require('mongoose');

const auditLogSchema = new mongoose.Schema(
  {
    actor: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    action: { type: String, required: true, trim: true },
    targetType: { type: String, required: true, trim: true },
    targetId: { type: String, default: null },
    metadata: { type: mongoose.Schema.Types.Mixed, default: {} },
    ip: { type: String, default: null },
  },
  { timestamps: { createdAt: true, updatedAt: false } }
);

// Audit entries are kept for one year; this is a retention safeguard, not a
// substitute for a formal records policy.
auditLogSchema.index({ createdAt: 1 }, { expireAfterSeconds: 60 * 60 * 24 * 365 });

module.exports = mongoose.model('AuditLog', auditLogSchema);
