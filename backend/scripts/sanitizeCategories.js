require('dotenv').config();
const mongoose = require('mongoose');
const Category = require('../models/Category');
const Place = require('../models/Place');
const Event = require('../models/Event');

const CANONICAL_CATEGORIES = [
  { name: 'Tourist Attractions', icon: 'photo_camera', sortOrder: 1 },
  { name: 'Historical & Religious', icon: 'mosque', sortOrder: 2 },
  { name: 'Hotels', icon: 'hotel', sortOrder: 3 },
  { name: 'Restaurants', icon: 'restaurant', sortOrder: 4 },
  { name: 'Bakeries & Cakes', icon: 'cake', sortOrder: 5 },
  { name: 'Hospitals & Medical', icon: 'local_hospital', sortOrder: 6 },
  { name: 'Shopping & Malls', icon: 'shopping_bag', sortOrder: 7 },
  { name: 'Parks & Nature', icon: 'park', sortOrder: 8 },
];

async function run() {
  await mongoose.connect(process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/smartmap_ai');
  console.log('Connected to MongoDB');

  // 1. Setup clean canonical categories
  const catMap = {};
  for (const c of CANONICAL_CATEGORIES) {
    let cat = await Category.findOne({ name: c.name });
    if (!cat) {
      cat = await Category.create(c);
      console.log('Created category:', c.name);
    } else {
      cat.icon = c.icon;
      cat.sortOrder = c.sortOrder;
      await cat.save();
    }
    catMap[c.name] = cat._id;
  }

  // Handle aliases: if old categories exist, remap places and delete duplicates
  const oldCats = await Category.find();
  for (const oc of oldCats) {
    let targetName = null;
    if (oc.name === 'Hospitals') targetName = 'Hospitals & Medical';
    else if (oc.name === 'Shopping') targetName = 'Shopping & Malls';
    else if (oc.name === 'Parks') targetName = 'Parks & Nature';
    else if (oc.name === 'Religious Places') targetName = 'Historical & Religious';

    if (targetName) {
      const targetId = catMap[targetName];
      await Place.updateMany({ categoryId: oc._id }, { $set: { categoryId: targetId } });
      await Category.findByIdAndDelete(oc._id);
      console.log(`Merged and deleted old category "${oc.name}" into "${targetName}"`);
    }
  }

  console.log('Categories sanitized successfully.');
  process.exit(0);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});
