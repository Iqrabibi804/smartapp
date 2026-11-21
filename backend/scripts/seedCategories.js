require('dotenv').config();
const connectDB = require('../config/db');
const Category = require('../models/Category');
const { CATEGORIES } = require('../config/categories');

// Creates or updates the canonical category taxonomy. Safe to re-run:
// existing categories keep their _id so place references stay intact.
async function seedCategories() {
  await connectDB();
  console.log('Connected to MongoDB.');

  let created = 0;
  let updated = 0;

  for (const data of CATEGORIES) {
    const existing = await Category.findOne({ name: data.name });
    if (!existing) {
      await Category.create(data);
      created++;
      console.log(`Created category: ${data.name}`);
    } else {
      existing.icon = data.icon;
      existing.sortOrder = data.sortOrder;
      await existing.save();
      updated++;
      console.log(`Updated category: ${data.name}`);
    }
  }

  console.log(`\nCategories: ${created} created, ${updated} updated, ${CATEGORIES.length} total.`);
  process.exit(0);
}

seedCategories().catch((err) => {
  console.error('Category seeding failed:', err);
  process.exit(1);
});
