require('dotenv').config();
const mongoose = require('mongoose');
const connectDB = require('../config/db');
const User = require('../models/User');
const Category = require('../models/Category');
const Place = require('../models/Place');
const Event = require('../models/Event');

const CATEGORIES = [
  { name: 'Tourist Attractions', icon: 'photo_camera', sortOrder: 1 },
  { name: 'Restaurants', icon: 'restaurant', sortOrder: 2 },
  { name: 'Hotels', icon: 'hotel', sortOrder: 3 },
  { name: 'Historical & Religious', icon: 'mosque', sortOrder: 4 },
  { name: 'Shopping & Malls', icon: 'shopping_bag', sortOrder: 5 },
  { name: 'Parks & Nature', icon: 'park', sortOrder: 6 },
  { name: 'Hospitals & Medical', icon: 'local_hospital', sortOrder: 7 },
];

async function seed() {
  await connectDB();

  let admin = await User.findOne({ email: 'admin@smartmap.ai' });
  if (!admin) {
    admin = new User({ name: 'Admin', email: 'admin@smartmap.ai', role: 'admin' });
    await admin.setPassword('Admin1234');
    await admin.save();
    console.log('Created admin user: admin@smartmap.ai / Admin1234');
  }

  const categoryIds = {};
  for (const data of CATEGORIES) {
    let category = await Category.findOne({ name: data.name });
    if (!category) {
      category = await Category.create(data);
      console.log(`Created category: ${data.name}`);
    } else {
      category.icon = data.icon;
      category.sortOrder = data.sortOrder;
      await category.save();
    }
    categoryIds[data.name] = category._id;
  }

  const SAMPLE_PLACES = [
    {
      name: 'Badshahi Mosque',
      description: 'Iconic Mughal-era mosque built in 1673 by Emperor Aurangzeb, featuring striking red sandstone and marble domes.',
      region: 'Punjab',
      categoryId: categoryIds['Historical & Religious'],
      location: { type: 'Point', coordinates: [74.3103, 31.5882] },
      address: 'Walled City, Lahore, Punjab',
      priceRange: 'free',
      rating: 4.9,
      reviewCount: 3420,
      verified: true,
      featured: true,
      facilities: ['Wheelchair Access', 'Guided Tours', 'Prayer Hall', 'Photography Spot', 'Shoe Keeping'],
      phone: '+92 42 99204000',
      images: [
        'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1596401057633-54a8fe8ef647?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Lahore Fort (Shahi Qila)',
      description: 'Majestic UNESCO World Heritage fortress showcasing centuries of Mughal, Sikh, and British architectural heritage including Sheesh Mahal.',
      region: 'Punjab',
      categoryId: categoryIds['Tourist Attractions'],
      location: { type: 'Point', coordinates: [74.3152, 31.5881] },
      address: 'Fort Road, Walled City, Lahore, Punjab',
      priceRange: 'low',
      rating: 4.8,
      reviewCount: 2890,
      verified: true,
      featured: true,
      facilities: ['Museum', 'Sheesh Mahal', 'Historical Walk', 'Souvenir Shops', 'Tour Guides'],
      phone: '+92 42 99204196',
      images: [
        'https://images.unsplash.com/photo-1622547748225-3fc4abd2cca0?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Faisal Mosque',
      description: 'The national mosque of Pakistan, situated at the foot of Margalla Hills with contemporary Turkish-inspired eight-sided desert tent design.',
      region: 'Islamabad Capital Territory',
      categoryId: categoryIds['Historical & Religious'],
      location: { type: 'Point', coordinates: [73.0369, 33.7295] },
      address: 'Shah Faisal Avenue, Sector E-7, Islamabad',
      priceRange: 'free',
      rating: 4.9,
      reviewCount: 4500,
      verified: true,
      featured: true,
      facilities: ['Scenic Mountain Views', 'Courtyard', 'Library', 'Ablution Facilities', 'Family Friendly'],
      phone: '+92 51 9260111',
      images: [
        'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Monal Restaurant',
      description: 'Iconic open-air hilltop dining destination offering panoramic nighttime views of Islamabad and authentic Pakistani barbecue & karahi.',
      region: 'Islamabad / Margalla',
      categoryId: categoryIds['Restaurants'],
      location: { type: 'Point', coordinates: [73.0498, 33.746] },
      address: 'Pir Sohawa Road, Margalla Hills, Islamabad',
      priceRange: 'high',
      rating: 4.7,
      reviewCount: 3820,
      verified: true,
      featured: true,
      facilities: ['Panoramic Mountain View', 'Valet Parking', 'Live Music', 'Outdoor Seating', 'Continental & Desi'],
      phone: '+92 51 2898044',
      website: 'https://monal.themonal.com',
      images: [
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Haveli Restaurant (Fort Road Food Street)',
      description: 'Rooftop culinary treasure situated directly opposite the illuminated Badshahi Mosque, serving traditional Lahori delicacies.',
      region: 'Punjab',
      categoryId: categoryIds['Restaurants'],
      location: { type: 'Point', coordinates: [74.3129, 31.5898] },
      address: 'Badshahi Mosque View, Food Street, Lahore, Punjab',
      priceRange: 'high',
      rating: 4.8,
      reviewCount: 2950,
      verified: true,
      featured: true,
      facilities: ['Heritage View', 'Rooftop Dining', 'Traditional Desi Cuisine', 'Live Sufi Music', 'AC Family Hall'],
      phone: '+92 300 8414899',
      images: [
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Centaurus Mall',
      description: 'Premier multi-storey shopping destination in the heart of Islamabad featuring international luxury brands, Cineplex, food court, and kids arena.',
      region: 'Islamabad Capital Territory',
      categoryId: categoryIds['Shopping & Malls'],
      location: { type: 'Point', coordinates: [73.0713, 33.7089] },
      address: 'Jinnah Avenue, Sector F-8/G-8, Islamabad',
      priceRange: 'medium',
      rating: 4.6,
      reviewCount: 5120,
      verified: true,
      featured: true,
      facilities: ['Cineplex Cinema', 'Mega Food Court', 'Underground Parking', 'Kids Fun City', 'Central Air Conditioning'],
      phone: '+92 51 8483030',
      images: [
        'https://images.unsplash.com/photo-1567449303078-57ad995bd301?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1519567241046-7f570eee3ce6?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Emporium Mall by Nishat',
      description: 'One of the largest shopping malls in Pakistan, complete with international retail outlets, ice-skating rink, luxury hotel, and extensive food boulevard.',
      region: 'Punjab',
      categoryId: categoryIds['Shopping & Malls'],
      location: { type: 'Point', coordinates: [74.2662, 31.4678] },
      address: 'Abdul Haque Road, Johar Town, Lahore, Punjab',
      priceRange: 'medium',
      rating: 4.7,
      reviewCount: 6800,
      verified: true,
      featured: true,
      facilities: ['Universal Cinemas', 'Ice Skating Rink', 'Hyperstar', 'Food Boulevard', 'Valet & Basement Parking'],
      phone: '+92 42 32592000',
      images: [
        'https://images.unsplash.com/photo-1519567241046-7f570eee3ce6?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1567449303078-57ad995bd301?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Shalimar Gardens',
      description: 'Historic Mughal garden complex completed in 1642, renowned for its three tiered terraces, 410 fountains, and lush flora.',
      region: 'Punjab',
      categoryId: categoryIds['Parks & Nature'],
      location: { type: 'Point', coordinates: [74.3822, 31.5861] },
      address: 'Shalamar Town, Grand Trunk Road, Lahore, Punjab',
      priceRange: 'low',
      rating: 4.6,
      reviewCount: 2100,
      verified: true,
      featured: true,
      facilities: ['UNESCO Heritage', 'Fountains', 'Botanical Gardens', 'Historic Pavilions', 'Walkways'],
      phone: '+92 42 99250041',
      images: [
        'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1519331379826-f10be5486c6f?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Mall Road & Murree Hills',
      description: 'Picturesque pine-covered hill resort nestled at 7,500 feet, famous for colonial architecture, chairlifts, cool breeze, and winter snowfall.',
      region: 'Punjab',
      categoryId: categoryIds['Tourist Attractions'],
      location: { type: 'Point', coordinates: [73.3912, 33.9078] },
      address: 'The Mall Road, Murree Hills, Punjab',
      priceRange: 'medium',
      rating: 4.5,
      reviewCount: 4200,
      verified: true,
      featured: true,
      facilities: ['Chairlift & Cable Car', 'Handicraft Stalls', 'Pine Nature Walks', 'Hot Tea & Corn', 'Horse Riding'],
      phone: '+92 51 9269001',
      images: [
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Serena Hotel Islamabad',
      description: 'World-renowned 5-star luxury heritage hotel set on 14 acres of lush gardens, showcasing Islamic architecture, heated outdoor pool, and Maisha Spa.',
      region: 'Islamabad Capital Territory',
      categoryId: categoryIds['Hotels'],
      location: { type: 'Point', coordinates: [73.0904, 33.7108] },
      address: 'Khayaban-e-Suhrwardy, Sector G-5, Islamabad',
      priceRange: 'high',
      rating: 4.8,
      reviewCount: 2150,
      verified: true,
      featured: true,
      facilities: ['Luxury Spa & Wellness', 'Heated Pool', 'Fine Dining Restaurants', 'Airport Shuttle', 'Executive Lounge'],
      phone: '+92 51 2874000',
      website: 'https://www.serenahotels.com',
      images: [
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Pearl Continental (PC) Hotel Lahore',
      description: 'Landmark 5-star hotel in the heart of Lahore, famous for signature restaurants (Dumpukht, Bukhara, Taipan) and supreme hospitality.',
      region: 'Punjab',
      categoryId: categoryIds['Hotels'],
      location: { type: 'Point', coordinates: [74.3387, 31.5546] },
      address: 'Shahrah-e-Quaid-e-Azam, Mall Road, Lahore, Punjab',
      priceRange: 'high',
      rating: 4.7,
      reviewCount: 3100,
      verified: true,
      featured: true,
      facilities: ['Swimming Pool', 'Fitness Club', 'Buffet Breakfast', 'Valet Parking', 'Concierge Service'],
      phone: '+92 42 111 505 505',
      website: 'https://www.pchotels.com',
      images: [
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Shifa International Hospital',
      description: 'JCI-accredited premier quaternary healthcare institution with 24/7 emergency response, modern diagnostic imaging, and multi-lingual medical staff.',
      region: 'Islamabad Capital Territory',
      categoryId: categoryIds['Hospitals & Medical'],
      location: { type: 'Point', coordinates: [73.0768, 33.6766] },
      address: 'Pitras Bukhari Road, Sector H-8/4, Islamabad',
      priceRange: 'medium',
      rating: 4.6,
      reviewCount: 1850,
      verified: true,
      featured: false,
      facilities: ['24/7 Emergency & Trauma', 'Ambulance Service', 'In-house Pharmacy', 'Intensive Care Unit (ICU)', 'ATM on-site'],
      phone: '+92 51 8464646',
      website: 'https://shifa.com.pk',
      images: [
        'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Doctors Hospital & Medical Center',
      description: 'Leading tertiary care hospital in Lahore equipped with comprehensive round-the-clock emergency, cardiology, and international patient care services.',
      region: 'Punjab',
      categoryId: categoryIds['Hospitals & Medical'],
      location: { type: 'Point', coordinates: [74.2694, 31.4883] },
      address: 'Canal Bank Road, Johar Town, Lahore, Punjab',
      priceRange: 'medium',
      rating: 4.5,
      reviewCount: 1620,
      verified: true,
      featured: false,
      facilities: ['24/7 Emergency Wing', 'Cardiac Care Unit', 'Ambulance Fleet', 'Pharmacy', 'Specialist Clinics'],
      phone: '+92 42 35302701',
      website: 'https://doctorshospital.com.pk',
      images: [
        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Katas Raj Temples',
      description: 'Ancient sacred Hindu temple complex dating back to the 6th century, centered around a legendary natural holy pond in the Salt Range hills.',
      region: 'Punjab',
      categoryId: categoryIds['Historical & Religious'],
      location: { type: 'Point', coordinates: [72.9511, 32.7241] },
      address: 'Near Choa Saidan Shah, Chakwal, Punjab',
      priceRange: 'low',
      rating: 4.7,
      reviewCount: 1450,
      verified: true,
      featured: true,
      facilities: ['Ancient Architecture', 'Holy Pond', 'Archaeological Walks', 'Photography Zone'],
      phone: '+92 543 553011',
      images: [
        'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&w=1200&q=80',
      ],
    },
    {
      name: 'Pakistan Monument & Museum',
      description: 'Bloom-shaped granite monument representing Pakistani culture and unity, with a rich wax museum and scenic sunset viewpoints over Islamabad.',
      region: 'Islamabad Capital Territory',
      categoryId: categoryIds['Tourist Attractions'],
      location: { type: 'Point', coordinates: [73.0679, 33.6939] },
      address: 'Shakarparian Hills, Islamabad',
      priceRange: 'low',
      rating: 4.7,
      reviewCount: 3600,
      verified: true,
      featured: true,
      facilities: ['Cultural Heritage Museum', 'Sunset Viewpoint', 'Souvenir Stalls', 'Botanical Garden', 'Spacious Parking'],
      phone: '+92 51 9249200',
      images: [
        'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?auto=format&fit=crop&w=1200&q=80',
        'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=1200&q=80',
      ],
    },
  ];

  // Clear existing places and re-insert fresh rich data
  await Place.deleteMany({});
  console.log('Cleared old place records.');

  for (const placeData of SAMPLE_PLACES) {
    await Place.create(placeData);
    console.log(`Created place with images: ${placeData.name}`);
  }

  // Seed sample events
  await Event.deleteMany({});
  const EVENTS = [
    {
      name: 'Lahore Cultural & Food Festival 2026',
      description: 'Annual heritage gala featuring 80+ street food stalls, classical qawwali performances, and artisan crafts.',
      date: new Date('2026-11-20'),
      location: { type: 'Point', coordinates: [74.3129, 31.5898] },
      address: 'Greater Iqbal Park, opposite Badshahi Mosque, Lahore',
      ticketInfo: 'Rs. 500 Entry Ticket',
      image: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=80',
    },
    {
      name: 'Islamabad Hiking & Eco Tour',
      description: 'Guided tourist trek along Trail 3 & Trail 5 through Margalla Hills with botanical expert and sunset tea.',
      date: new Date('2026-11-25'),
      location: { type: 'Point', coordinates: [73.0551, 33.746] },
      address: 'Trail 3 Margalla Hills, Sector F-6, Islamabad',
      ticketInfo: 'Free Registration',
      image: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80',
    },
    {
      name: 'Murree Winter Snow Carnival',
      description: 'Exciting snow sports, ice sculpture shows, and live music at Mall Road Murree.',
      date: new Date('2026-12-15'),
      location: { type: 'Point', coordinates: [73.3912, 33.9078] },
      address: 'The Mall, Murree Hills, Punjab',
      ticketInfo: 'Free Entry',
      image: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    },
  ];

  for (const eventData of EVENTS) {
    await Event.create(eventData);
    console.log(`Created event: ${eventData.title}`);
  }

  console.log('Seeding complete with high-resolution images and Punjab tourist spots.');
  process.exit(0);
}

seed().catch((err) => {
  console.error('Seeding failed:', err);
  process.exit(1);
});