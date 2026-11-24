const mongoose = require('mongoose');
const dns = require('dns');

// Use reliable Google/Cloudflare DNS to prevent ISP DNS SRV resolution failures
try {
  dns.setServers(['8.8.8.8', '1.1.1.1']);
} catch (_) {}

/**
 * Connects to MongoDB using the URI from environment config.
 * Fails fast with a clear message if the connection can't be established,
 * rather than letting the server start in a broken state.
 */
async function connectDB() {
  const uri = process.env.MONGO_URI;

  if (!uri) {
    throw new Error('MONGO_URI is not set. Copy .env.example to .env and configure it.');
  }

  try {
    await mongoose.connect(uri);
    console.log(`MongoDB connected: ${mongoose.connection.host}`);
  } catch (err) {
    console.error('MongoDB connection failed:', err.message);
    // Do not start an API instance that cannot serve database-backed routes.
    throw err;
  }
}

module.exports = connectDB;
