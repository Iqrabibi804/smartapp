require('dotenv').config();

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const mongoSanitize = require('express-mongo-sanitize');
const rateLimit = require('express-rate-limit');
const path = require('path');

const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const placeRoutes = require('./routes/placeRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const reviewRoutes = require('./routes/reviewRoutes');
const favoritesRoutes = require('./routes/favoritesRoutes');
const aiRoutes = require('./routes/aiRoutes');
const tripRoutes = require('./routes/tripRoutes');
const eventRoutes = require('./routes/eventRoutes');
const businessRoutes = require('./routes/businessRoutes');
const adminRoutes = require('./routes/adminRoutes');
const emergencyRoutes = require('./routes/emergencyRoutes');


const uploadRoutes = require('./routes/uploadRoutes');
const directionsRoutes = require('./routes/directionsRoutes');
const customListRoutes = require('./routes/customListRoutes');
const { notFound, errorHandler } = require('./middleware/errorHandler');

const app = express();
app.disable('x-powered-by');

app.use(helmet());
if (process.env.NODE_ENV === 'production' && !process.env.CLIENT_ORIGIN) {
  throw new Error('CLIENT_ORIGIN must be set to the app origin in production.');
}
app.use(cors({ origin: process.env.CLIENT_ORIGIN || '*' }));
app.use(express.json({ limit: '2mb' }));
app.use(mongoSanitize());

// Serve static uploaded files (no directory listings or dotfiles).
app.use(
  '/uploads',
  express.static(path.join(__dirname, 'uploads'), {
    dotfiles: 'deny',
    index: false,
  })
);

if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
}

app.use(
  rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 300,
  })
);

app.get('/api/health', (req, res) => res.json({ success: true, status: 'ok' }));
app.use('/api/auth', authRoutes);
app.use('/api/places', placeRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api', reviewRoutes);
app.use('/api/favorites', favoritesRoutes);
app.use('/api/ai', aiRoutes);
app.use('/api/trips', tripRoutes);
app.use('/api/events', eventRoutes);
app.use('/api/businesses', businessRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/emergency', emergencyRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/directions', directionsRoutes);
app.use('/api/lists', customListRoutes);

app.use(notFound);
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

async function start() {
  if (!process.env.JWT_SECRET || process.env.JWT_SECRET.length < 32) {
    throw new Error('JWT_SECRET must be set to at least 32 characters before starting.');
  }
  if (!process.env.MONGO_URI) {
    throw new Error('MONGO_URI must be set before starting.');
  }

  await connectDB();
  app.listen(PORT, '0.0.0.0', () => console.log(`SmartMap AI API running on http://0.0.0.0:${PORT}`));
}

start();