// Canonical category taxonomy shared by seed scripts and admin tooling.
// Keep names in sync with the category alias mapping in routes/placeRoutes.js.
const CATEGORIES = [
  { name: 'Tourist Attractions', icon: 'photo_camera', sortOrder: 1 },
  { name: 'Historical & Religious', icon: 'mosque', sortOrder: 2 },
  { name: 'Parks & Nature', icon: 'park', sortOrder: 3 },
  { name: 'Adventure', icon: 'hiking', sortOrder: 4 },
  { name: 'Family Attractions', icon: 'family_restroom', sortOrder: 5 },
  { name: 'Restaurants', icon: 'restaurant', sortOrder: 6 },
  { name: 'Fast Food', icon: 'fastfood', sortOrder: 7 },
  { name: 'Bakeries & Cakes', icon: 'cake', sortOrder: 8 },
  { name: 'Hotels', icon: 'hotel', sortOrder: 9 },
  { name: 'Shopping & Malls', icon: 'shopping_bag', sortOrder: 10 },
  { name: 'Hospitals & Medical', icon: 'local_hospital', sortOrder: 11 },
];

module.exports = { CATEGORIES };
