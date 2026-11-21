require('dotenv').config();
const mongoose = require('mongoose');
const connectDB = require('../config/db');
const Category = require('../models/Category');
const { CATEGORIES } = require('../config/categories');
const Place = require('../models/Place');

// Seeded records are compiled from public information, not field-verified.
const SEED_SOURCE = 'Compiled public directory (unverified)';

function cityFromAddress(address = '') {
  const parts = address.split(',').map((s) => s.trim()).filter(Boolean);
  const punjabIdx = parts.findIndex((p) => /^punjab$/i.test(p));
  if (punjabIdx > 0) return parts[punjabIdx - 1];
  return parts.length > 1 ? parts[parts.length - 1] : '';
}

const PUNJAB_CITIES_PLACES = [
  // ==========================================
  // 1. ISLAMABAD
  // ==========================================
  // Hospitals
  {
    name: 'Shifa International Hospital',
    description: 'Premier tertiary care hospital in Islamabad with JCI accreditation, 24/7 emergency, heart center, organ transplant, and specialized trauma care.',
    region: 'Islamabad Capital Territory',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [73.0768, 33.6844] },
    address: 'Pitras Bukhari Road, Sector H-8/4, Islamabad',
    priceRange: 'high',
    rating: 4.8,
    reviewCount: 3120,
    verified: true,
    featured: true,
    facilities: ['24/7 Emergency', 'Ambulance Service', 'Pharmacy', 'ICU/CCU', 'Laboratory', 'Parking'],
    phone: '+92 51 8463000',
    images: [
      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'PIMS (Pakistan Institute of Medical Sciences)',
    description: 'Largest public sector research and tertiary hospital in Islamabad offering extensive emergency, pediatric, and surgical departments.',
    region: 'Islamabad Capital Territory',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [73.0558, 33.7029] },
    address: 'G-8/3, Islamabad',
    priceRange: 'low',
    rating: 4.2,
    reviewCount: 2200,
    verified: true,
    featured: false,
    facilities: ['Emergency 24/7', 'Children Hospital', 'Burn Centre', 'Blood Bank', 'Free Medication Counters'],
    phone: '+92 51 9261170',
    images: [
      'https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Restaurants
  {
    name: 'The Monal Restaurant Islamabad',
    description: 'Iconic hilltop dining destination perched on Margalla Hills at 3,900 feet, serving Pakistani BBQ, Continental feasts with panoramic city views.',
    region: 'Islamabad Capital Territory',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [73.0652, 33.7667] },
    address: 'Pir Sohawa Road, Margalla Hills, Islamabad',
    priceRange: 'high',
    rating: 4.9,
    reviewCount: 7800,
    verified: true,
    featured: true,
    facilities: ['Panoramic View', 'Outdoor Seating', 'Live BBQ', 'Valet Parking', 'Family Hall'],
    phone: '+92 51 5837204',
    images: [
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Savour Foods Islamabad',
    description: 'Pakistan famous Savour Crispy Chicken Pulao with shami kabab, fresh raita, salad, and roast chicken. A must-visit culinary staple.',
    region: 'Islamabad Capital Territory',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [73.0844, 33.7145] },
    address: 'Fortune Plaza, Blue Area, Islamabad',
    priceRange: 'low',
    rating: 4.7,
    reviewCount: 5600,
    verified: true,
    featured: true,
    facilities: ['Dine-In', 'Takeaway', 'Home Delivery', 'AC Family Hall', 'Fast Service'],
    phone: '+92 51 2348255',
    images: [
      'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Bakeries & Cakes
  {
    name: 'Layers Bakeshop Islamabad',
    description: 'Most viral and beloved cake destination in Pakistan. Famous for Belgian Malt Cake, Nutella Hazelnut Cake, Lotus Biscoff, and Red Velvet.',
    region: 'Islamabad Capital Territory',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [73.0645, 33.7225] },
    address: 'Bhittai Road, Sector F-7 Markaz, Islamabad (Branches in F-6, F-11, G-11)',
    priceRange: 'medium',
    rating: 4.9,
    reviewCount: 4200,
    verified: true,
    featured: true,
    facilities: ['Online Ordering', 'Home Delivery via Foodpanda & Website', 'Fresh Daily Baking', 'Custom Birthday Cakes'],
    phone: '+92 51 111529377',
    images: [
      'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Tehzeeb Bakers Islamabad',
    description: 'Renowned legacy bakery since 1952. Legendary for Fresh Cream Pineapple Cakes, Black Forest, Pizza Pies, and artisanal patisserie.',
    region: 'Islamabad Capital Territory',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [73.0815, 33.7121] },
    address: 'Jinnah Avenue, Blue Area, Islamabad (Also in F-11 & G-9)',
    priceRange: 'medium',
    rating: 4.8,
    reviewCount: 3890,
    verified: true,
    featured: true,
    facilities: ['Custom Cakes', 'Online Order (tehzeebbakers.com)', 'Doorstep Delivery', 'Catering', 'Gift Hampers'],
    phone: '+92 51 111112253',
    images: [
      'https://images.unsplash.com/photo-1535141192574-5d4897c13136?auto=format&fit=crop&w=1000&q=80',
    ],
  },

  // ==========================================
  // 2. LAHORE
  // ==========================================
  // Hospitals
  {
    name: 'Shaukat Khanum Memorial Cancer Hospital',
    description: 'World-renowned comprehensive cancer care centre founded by Imran Khan. State-of-the-art oncology, nuclear medicine, and free patient assistance programs.',
    region: 'Punjab',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [74.2755, 31.4682] },
    address: '7A Block R-3, Johar Town, Lahore, Punjab',
    priceRange: 'high',
    rating: 4.9,
    reviewCount: 4600,
    verified: true,
    featured: true,
    facilities: ['24/7 Emergency', 'Specialist Oncology', 'Modern Labs', 'Ambulance Fleet', 'Pharmacy'],
    phone: '+92 42 35905000',
    images: [
      'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Doctors Hospital & Medical Center',
    description: 'Renowned multi-specialty private hospital on Lahore Canal with leading cardiology, neurology, pediatrics, and intensive trauma care.',
    region: 'Punjab',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [74.2829, 31.4828] },
    address: '152-G/1, Canal Bank, Johar Town, Lahore, Punjab',
    priceRange: 'high',
    rating: 4.4,
    reviewCount: 1850,
    verified: true,
    featured: false,
    facilities: ['Cardiac Emergency 24/7', 'Helipad', 'MRI/CT Scan', 'Modern ICU', 'Valet Parking'],
    phone: '+92 42 35302701',
    images: [
      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Restaurants
  {
    name: 'Haveli Restaurant Lahore',
    description: 'Dine in a centuries-old haveli overlooking the illuminated Badshahi Mosque. Famous for royal mutton chops, handi, reshmi kebabs, and live gazal.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [74.3129, 31.5898] },
    address: 'Fort Road Food Street, Walled City, Lahore',
    priceRange: 'high',
    rating: 4.8,
    reviewCount: 6200,
    verified: true,
    featured: true,
    facilities: ['Rooftop Badshahi Mosque View', 'Traditional Music', 'Authentic Mughlai Food', 'Family Dining'],
    phone: '+92 300 8414899',
    images: [
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Bundu Khan Restaurant Lahore',
    description: 'The royal benchmark of traditional Pakistani BBQ, sizzling seekh kebabs, chicken boti, and hot parathas in Lahore since decades.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [74.3414, 31.5135] },
    address: 'Liberty Market, Gulberg III, Lahore, Punjab',
    priceRange: 'medium',
    rating: 4.7,
    reviewCount: 5100,
    verified: true,
    featured: true,
    facilities: ['Traditional BBQ', 'Family Dining Halls', 'Takeaway & Delivery', 'Air Conditioning'],
    phone: '+92 42 111444411',
    images: [
      'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Bakeries & Cakes
  {
    name: 'Jalal Sons Bakery & Gourmet',
    description: 'Lahore favorite premium lifestyle store and bakery. Supreme customized birthday cakes, chocolate fudge, cheesecakes, and gourmet live kitchen.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [74.3486, 31.5342] },
    address: 'Main Market, Gulberg II, Lahore (Also DHA Phase 5 & Model Town)',
    priceRange: 'medium',
    rating: 4.8,
    reviewCount: 3950,
    verified: true,
    featured: true,
    facilities: ['Instant Delivery via Foodpanda & Jalal Sons App', 'Custom Cake Pre-orders', 'Live Bakery', 'Card Payment'],
    phone: '+92 42 111525257',
    images: [
      'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Kitchen Cuisine Lahore',
    description: 'Pioneers of upscale desserts in Pakistan. Renowned for Caramel Crunch Cake, Chocolate Decadence, and designer wedding and birthday cakes.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [74.3512, 31.5178] },
    address: 'M.M. Alam Road, Gulberg III, Lahore (Multiple Branches)',
    priceRange: 'high',
    rating: 4.7,
    reviewCount: 2800,
    verified: true,
    featured: true,
    facilities: ['Online Cake Ordering (kitchencuisine.com.pk)', 'Doorstep Express Delivery', 'Fondant Birthday Cakes'],
    phone: '+92 42 35759976',
    images: [
      'https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=1000&q=80',
    ],
  },

  // ==========================================
  // 3. RAWALPINDI
  // ==========================================
  // Hospitals
  {
    name: 'Rawalpindi Institute of Cardiology (RIC)',
    description: 'Specialized government cardiac care hospital equipped with world-class catheterization labs, cardiac bypass surgery, and round-the-clock emergency.',
    region: 'Punjab',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [73.0722, 33.6145] },
    address: 'Rawal Road, Rawalpindi, Punjab',
    priceRange: 'medium',
    rating: 4.7,
    reviewCount: 1980,
    verified: true,
    featured: true,
    facilities: ['24/7 Cardiac Emergency', 'CCU/ICU', 'Angiography', 'Pharmacy', 'Spacious Parking'],
    phone: '+92 51 9281300',
    images: [
      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Holy Family Hospital Rawalpindi',
    description: 'Major historic tertiary teaching hospital in Satellite Town providing comprehensive obstetrics, surgery, pediatrics, and emergency trauma facilities.',
    region: 'Punjab',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [73.0681, 33.6392] },
    address: 'Holy Family Road, Satellite Town, Rawalpindi, Punjab',
    priceRange: 'low',
    rating: 4.1,
    reviewCount: 1600,
    verified: true,
    featured: false,
    facilities: ['Emergency 24 Hours', 'Blood Bank', 'OPD Clinics', 'Affordable Care'],
    phone: '+92 51 9290321',
    images: [
      'https://images.unsplash.com/photo-1538108149393-fbbd81895907?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Restaurants
  {
    name: 'Mei Kong Restaurant Rawalpindi',
    description: 'Legendary Chinese fine dining restaurant in Rawalpindi Cantt since 1978. Renowned for Kung Pao Chicken, Szechuan Beef, and exquisite ambiance.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [73.0543, 33.5962] },
    address: '32 Haider Road, Saddar Cantt, Rawalpindi, Punjab',
    priceRange: 'high',
    rating: 4.7,
    reviewCount: 3400,
    verified: true,
    featured: true,
    facilities: ['Chinese Cuisine', 'Executive Family Hall', 'Valet Parking', 'Corporate Banquets'],
    phone: '+92 51 5566577',
    images: [
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Cheezious Rawalpindi',
    description: 'Top fast food sensation in the twin cities. Famous for Crown Crust Pizza, Bihari Kebab Rolls, Crispy Wings, and family deals.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [73.0687, 33.6421] },
    address: 'Commercial Market, Satellite Town, Rawalpindi, Punjab',
    priceRange: 'medium',
    rating: 4.8,
    reviewCount: 4800,
    verified: true,
    featured: true,
    facilities: ['Fast Home Delivery', 'Dine-In', 'Takeaway', 'Affordable Deals'],
    phone: '+92 51 111446699',
    images: [
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Bakeries & Cakes
  {
    name: 'Tehzeeb Bakers Rawalpindi Saddar',
    description: 'The historic headquarters of Tehzeeb Bakers. Iconic for its rich pineapple fresh cream cakes, pistachio pastries, pizza slices, and savory treats.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [73.0572, 33.5983] },
    address: 'Bank Road, Saddar, Rawalpindi, Punjab',
    priceRange: 'medium',
    rating: 4.9,
    reviewCount: 5200,
    verified: true,
    featured: true,
    facilities: ['Online Booking', 'Same-day Cake Delivery', 'WhatsApp Orders', 'Custom Writing on Cakes'],
    phone: '+92 51 111112253',
    images: [
      'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Layers Bakeshop Rawalpindi',
    description: 'Premier spot for modern chocolate fudge, caramel lotus, and Ferrero Rocher birthday cakes in Rawalpindi with fast local delivery.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [73.0679, 33.6415] },
    address: 'Commercial Market, Satellite Town, Rawalpindi, Punjab',
    priceRange: 'medium',
    rating: 4.9,
    reviewCount: 3100,
    verified: true,
    featured: true,
    facilities: ['Foodpanda Delivery', 'Online Website Ordering (layers.shop)', 'Birthday Candles & Accessories'],
    phone: '+92 51 111529377',
    images: [
      'https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=1000&q=80',
    ],
  },

  // ==========================================
  // 4. ATTOCK
  // ==========================================
  // Hospitals
  {
    name: 'DHQ Hospital Attock (Asfandyar Bukhari Hospital)',
    description: 'Main district headquarters teaching hospital in Attock. Comprehensive 24/7 emergency unit, trauma center, dialysis, and surgical care for the region.',
    region: 'Punjab',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [72.3615, 33.7661] },
    address: 'Kachery Road, Attock City, Punjab',
    priceRange: 'low',
    rating: 4.2,
    reviewCount: 780,
    verified: true,
    featured: true,
    facilities: ['24/7 Trauma Emergency', 'Dialysis Centre', 'Blood Bank', 'Pharmacy', 'Ambulance'],
    phone: '+92 57 9316124',
    images: [
      'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Restaurants
  {
    name: 'Mezban Restaurant Attock',
    description: 'Top family dining spot in Attock city offering authentic Shinwari mutton karahi, chicken handi, BBQ platters, and Chinese dishes in a family setting.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [72.3582, 33.7712] },
    address: 'Kamra Road, Attock City, Punjab',
    priceRange: 'medium',
    rating: 4.5,
    reviewCount: 890,
    verified: true,
    featured: true,
    facilities: ['Family Hall', 'Air Conditioned', 'Live BBQ', 'Takeaway & Delivery'],
    phone: '+92 57 2610111',
    images: [
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Indus River Dolphin View Point & Restaurant',
    description: 'Scenic riverside restaurant at the confluence of Indus and Kabul rivers near Attock Fort. Fresh river fish, chai, and historical riverside vistas.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [72.2458, 33.8912] },
    address: 'Grand Trunk Road, Attock Khurd, Punjab',
    priceRange: 'medium',
    rating: 4.6,
    reviewCount: 1200,
    verified: true,
    featured: true,
    facilities: ['River View', 'Fresh River Fish', 'Outdoor Dining', 'Tourist Photography'],
    phone: '+92 312 9988771',
    images: [
      'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Bakeries & Cakes
  {
    name: 'Gourmet Bakers & Sweets Attock',
    description: 'Most popular bakery in Attock city for fresh birthday cakes, chocolate fudge, black forest, customized event cakes, and traditional sweets.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [72.3641, 33.7694] },
    address: 'Kachery Road, Civil Bazar, Attock City, Punjab',
    priceRange: 'medium',
    rating: 4.6,
    reviewCount: 940,
    verified: true,
    featured: true,
    facilities: ['Birthday Cake Customization', 'Home Delivery via Foodpanda & Phone', 'Fresh Daily Stock', 'Sweets & Bakes'],
    phone: '+92 57 2611456',
    images: [
      'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Rahat Bakers & Sweets Attock',
    description: 'Trusted bakery offering fresh cream pastries, wedding and anniversary cakes, and customized name printing on cakes with local home delivery.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [72.3619, 33.7653] },
    address: 'Pleader Lane, Main Chowk, Attock City, Punjab',
    priceRange: 'medium',
    rating: 4.5,
    reviewCount: 650,
    verified: true,
    featured: false,
    facilities: ['Phone Delivery Order', 'Event Cake Booking', 'Foodpanda Delivery', 'Takeaway'],
    phone: '+92 57 2702233',
    images: [
      'https://images.unsplash.com/photo-1535141192574-5d4897c13136?auto=format&fit=crop&w=1000&q=80',
    ],
  },

  // ==========================================
  // 5. CHAKWAL
  // ==========================================
  // Hospitals
  {
    name: 'DHQ Hospital Chakwal',
    description: 'Leading public hospital in Chakwal district with round-the-clock emergency, surgical wards, maternity services, and pathology laboratory.',
    region: 'Punjab',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [72.8532, 32.9329] },
    address: 'Rawalpindi Road, Chakwal City, Punjab',
    priceRange: 'low',
    rating: 4.1,
    reviewCount: 650,
    verified: true,
    featured: true,
    facilities: ['24/7 Emergency', 'Ambulance', 'Dialysis Center', 'OPD', 'Pharmacy'],
    phone: '+92 543 553018',
    images: [
      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Restaurants
  {
    name: 'Royal Tonite Restaurant Chakwal',
    description: 'Chakwal premier family restaurant serving delicious Handi, BBQ platters, Karahi, Chinese gravies, and mocktails in an upscale setting.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [72.8587, 32.9362] },
    address: 'Opposite District Courts, Rawalpindi Road, Chakwal, Punjab',
    priceRange: 'medium',
    rating: 4.7,
    reviewCount: 1100,
    verified: true,
    featured: true,
    facilities: ['Family Dining', 'Outdoor Lawn', 'Live BBQ', 'Party Hall', 'Fast Service'],
    phone: '+92 543 551122',
    images: [
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Green Lagoon Restaurant Kallar Kahar (Chakwal)',
    description: 'Beautiful lakeside dining restaurant overlooking Kallar Kahar Lake near Chakwal. Renowned for scenic boating views, fried fish, and desi tea.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [72.7012, 32.7814] },
    address: 'Kallar Kahar Lake Shore, Chakwal District, Punjab',
    priceRange: 'medium',
    rating: 4.6,
    reviewCount: 2300,
    verified: true,
    featured: true,
    facilities: ['Lake View', 'Boating Pier', 'Fresh Fish', 'Tourist Spot', 'Open Air Seating'],
    phone: '+92 301 5566778',
    images: [
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Bakeries & Cakes
  {
    name: 'Gourmet Bakers & Sweets Chakwal',
    description: 'Largest bakery in Chakwal district for birthday cakes, custom celebration cakes, dry fruit cakes, biscuits, and authentic Chakwal Rewari & sweets.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [72.8554, 32.9341] },
    address: 'Rawalpindi Road, Near Ayub Chowk, Chakwal, Punjab',
    priceRange: 'medium',
    rating: 4.6,
    reviewCount: 980,
    verified: true,
    featured: true,
    facilities: ['Home Delivery via Foodpanda', 'Call for Delivery Order', 'Event Cake Booking', 'Chakwal Rewari'],
    phone: '+92 543 543201',
    images: [
      'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Rahat Bakers Chakwal',
    description: 'Popular spot for fresh dairy cream cakes, chocolate fudge, pizza slices, and confectionery with prompt local delivery across Chakwal city.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [72.8519, 32.9308] },
    address: 'Bhaun Road Chowk, Chakwal City, Punjab',
    priceRange: 'medium',
    rating: 4.5,
    reviewCount: 710,
    verified: true,
    featured: false,
    facilities: ['Local Delivery', 'Custom Cake Writing', 'Foodpanda Delivery', 'Takeaway'],
    phone: '+92 543 552345',
    images: [
      'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?auto=format&fit=crop&w=1000&q=80',
    ],
  },

  // ==========================================
  // 6. SAMANABAD (LAHORE)
  // ==========================================
  // Hospitals
  {
    name: 'Social Security Teaching Hospital Samanabad',
    description: 'Prominent multidisciplinary teaching hospital located right at Samanabad Multan Road Mor with 24/7 emergency, gynecology, pediatric, and trauma care.',
    region: 'Punjab',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [74.2982, 31.5378] },
    address: 'Multan Road near Samanabad Mor, Lahore, Punjab',
    priceRange: 'low',
    rating: 4.4,
    reviewCount: 1120,
    verified: true,
    featured: true,
    facilities: ['24/7 Emergency', 'Free Treatment Schemes', 'Operation Theatres', 'Laboratory', 'Ambulance'],
    phone: '+92 42 37468451',
    images: [
      'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Samanabad Government Hospital (THQ)',
    description: 'Community government hospital serving the central Samanabad town with emergency wards, immunization clinic, and primary healthcare services.',
    region: 'Punjab',
    categoryName: 'Hospitals & Medical',
    location: { type: 'Point', coordinates: [74.3015, 31.5412] },
    address: 'Main Road Samanabad, Lahore, Punjab',
    priceRange: 'low',
    rating: 4.0,
    reviewCount: 450,
    verified: true,
    featured: false,
    facilities: ['Emergency', 'OPD', 'Maternity Ward', 'Free Medical Tests'],
    phone: '+92 42 99250101',
    images: [
      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Restaurants
  {
    name: 'Butt Karahi & BBQ Samanabad',
    description: 'Famous Punjabi dining destination in Samanabad. Serving pure desi ghee chicken karahi, mutton chops, beef seekh kebabs, and roghni naan.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [74.3028, 31.5435] },
    address: 'Poonch Road, Samanabad, Lahore, Punjab',
    priceRange: 'medium',
    rating: 4.6,
    reviewCount: 2200,
    verified: true,
    featured: true,
    facilities: ['Desi Ghee Karahi', 'Family Dining Space', 'Home Delivery via Foodpanda', 'Live Cooking'],
    phone: '+92 321 4455667',
    images: [
      'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Yasir Broast Samanabad Chowk',
    description: 'Popular fast casual restaurant renowned for golden crispy fried chicken broast, spicy burger rolls, and family rice platters.',
    region: 'Punjab',
    categoryName: 'Restaurants',
    location: { type: 'Point', coordinates: [74.2965, 31.5361] },
    address: 'Near Samanabad Chowk, Multan Road, Lahore, Punjab',
    priceRange: 'medium',
    rating: 4.5,
    reviewCount: 1680,
    verified: true,
    featured: false,
    facilities: ['Fast Delivery', 'Crispy Broast', 'Family Seating', 'Takeaway Counter'],
    phone: '+92 42 37466788',
    images: [
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  // Bakeries & Cakes
  {
    name: 'Cakes & Bakes Samanabad',
    description: 'Premier customized cake brand in Samanabad. Famous for photo cakes, designer birthday themes, lotus cheesecake, chocolate explosion, and pizza breads.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [74.3039, 31.5448] },
    address: 'Main Boulevard Samanabad, Poonch Road, Lahore, Punjab',
    priceRange: 'medium',
    rating: 4.7,
    reviewCount: 1850,
    verified: true,
    featured: true,
    facilities: ['Online Booking (cakesandbakes.com)', 'Foodpanda Express 30-min Delivery', 'Custom Cake Consultation', 'Event Hampers'],
    phone: '+92 42 111225371',
    images: [
      'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=1000&q=80',
    ],
  },
  {
    name: 'Gourmet Bakers & Sweets Samanabad',
    description: 'The go-to neighborhood bakery in Samanabad for instant birthday cakes, chocolate mud cakes, fresh cream pineapple cakes, and traditional sweets.',
    region: 'Punjab',
    categoryName: 'Bakeries & Cakes',
    location: { type: 'Point', coordinates: [74.3008, 31.5419] },
    address: '1st Roundabout (Gol Chakkar), Samanabad, Lahore, Punjab',
    priceRange: 'low',
    rating: 4.6,
    reviewCount: 2400,
    verified: true,
    featured: true,
    facilities: ['Doorstep Delivery via Foodpanda', 'Affordable Birthday Cakes', 'Sweets & Snacks', 'Helpline Orders'],
    phone: '+92 42 111456789',
    images: [
      'https://images.unsplash.com/photo-1535141192574-5d4897c13136?auto=format&fit=crop&w=1000&q=80',
    ],
  },
];

async function seedPunjabCities() {
  await connectDB();
  console.log('Connected to MongoDB.');

  // Ensure the canonical category taxonomy exists so category names resolve accurately.
  for (const data of CATEGORIES) {
    const existing = await Category.findOne({ name: data.name });
    if (!existing) {
      await Category.create(data);
      console.log(`Created category: ${data.name}`);
    }
  }

  // Fetch all category IDs
  const allCategories = await Category.find({});
  const catMap = {};
  allCategories.forEach((c) => {
    catMap[c.name] = c._id;
  });

  console.log(`Seeding ${PUNJAB_CITIES_PLACES.length} places across Islamabad, Lahore, Rawalpindi, Attock, Chakwal, and Samanabad...`);

  let addedCount = 0;
  for (const item of PUNJAB_CITIES_PLACES) {
    const categoryId = catMap[item.categoryName];
    if (!categoryId) {
      console.warn(`Skipped (unknown category "${item.categoryName}"): ${item.name}`);
      continue;
    }
    
    // Check if place already exists by name
    const existing = await Place.findOne({ name: item.name });
    if (!existing) {
      await Place.create({
        name: item.name,
        description: item.description,
        region: item.region,
        categoryId: categoryId,
        location: item.location,
        address: item.address,
        city: cityFromAddress(item.address),
        priceRange: item.priceRange,
        rating: item.rating,
        reviewCount: item.reviewCount,
        verified: false,
        verificationStatus: 'community_reported',
        source: SEED_SOURCE,
        featured: item.featured,
        facilities: item.facilities,
        phone: item.phone,
        images: item.images,
      });
      console.log(`Added: [${item.categoryName}] ${item.name} (${item.address})`);
      addedCount++;
    } else {
      // Never downgrade records that an administrator has genuinely verified.
      if (existing.verificationStatus !== 'verified') {
        existing.city = existing.city || cityFromAddress(item.address);
        existing.verified = false;
        existing.verificationStatus = 'community_reported';
        existing.source = existing.source || SEED_SOURCE;
        await existing.save();
      }
      console.log(`Already exists: ${item.name}`);
    }
  }

  console.log(`\nSuccessfully seeded ${addedCount} new places in Punjab & Islamabad!`);
  process.exit(0);
}

seedPunjabCities().catch((err) => {
  console.error('Seeding error:', err);
  process.exit(1);
});
