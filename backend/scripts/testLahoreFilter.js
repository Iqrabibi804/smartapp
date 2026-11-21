require('dotenv').config();
const mongoose = require('mongoose');
const Place = require('../models/Place');
const Category = require('../models/Category');

async function test() {
  await mongoose.connect(process.env.MONGO_URI);
  const cat = await Category.findOne({ name: /Hospital/i });
  console.log('Category ID:', cat._id);

  // Test what MongoDB returns for Lahore filter
  const results = await Place.find({
    verified: true,
    $or: [{ address: /Lahore/i }, { region: /Lahore/i }, { name: /Lahore/i }],
    categoryId: cat._id,
  }).lean();

  console.log('Lahore Hospitals (' + results.length + '):');
  results.forEach(r => console.log(' - ' + r.name + ' (' + r.address + ')'));

  // Test what happens when NO city filter is applied
  const allHosp = await Place.find({
    verified: true,
    categoryId: cat._id,
  }).lean();
  console.log('\nAll Hospitals (' + allHosp.length + '):');
  allHosp.slice(0, 5).forEach(r => console.log(' - ' + r.name + ' (' + r.address + ')'));

  process.exit(0);
}

test().catch(err => {
  console.error(err);
  process.exit(1);
});
