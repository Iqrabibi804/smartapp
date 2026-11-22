/// Punjab restaurants included in the dining guide.
///
/// Ratings are the public listing figures supplied in the November 2026
/// snapshot. They are not reviews collected by this app and should be
/// confirmed on Google Maps or the restaurant's own page. Official websites
/// are only linked where the business publishes one; otherwise the card
/// falls back to a map search rather than a guessed booking page.
class PunjabRestaurant {
  const PunjabRestaurant({
    required this.name,
    required this.area,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.specialty,
    this.website,
    this.phone,
  });

  final String name;
  final String area;
  final String city;
  final double rating;
  final int reviewCount;
  final String specialty;
  final String? website;
  final String? phone;

  Uri get mapUri => Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': '$name, $area, $city',
      });

  Uri? get websiteUri => website == null ? null : Uri.parse(website!);

  Uri? get callUri {
    final digits = phone?.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits == null || digits.isEmpty) return null;
    return Uri(scheme: 'tel', path: digits);
  }
}

const List<PunjabRestaurant> punjabRestaurants = [
  PunjabRestaurant(
    name: 'Haveli Restaurant',
    area: 'Fort Road Food Street',
    city: 'Lahore',
    rating: 4.7,
    reviewCount: 12400,
    specialty: 'Rooftop Badshahi Mosque view & BBQ',
    website: 'https://haveli.com.pk',
  ),
  PunjabRestaurant(
    name: 'Butt Karahi Tikka',
    area: 'Lakshmi Chowk',
    city: 'Lahore',
    rating: 4.6,
    reviewCount: 9800,
    specialty: 'Desi chicken & mutton karahi',
    phone: '+92 42 37248888',
  ),
  PunjabRestaurant(
    name: 'Café Aylanto',
    area: 'MM Alam Road, Gulberg',
    city: 'Lahore',
    rating: 4.6,
    reviewCount: 4500,
    specialty: 'Mediterranean & steaks, table booking',
    website: 'https://cafeaylanto.com',
  ),
  PunjabRestaurant(
    name: 'The Monal',
    area: 'Pir Sohawa',
    city: 'Islamabad',
    rating: 4.7,
    reviewCount: 28000,
    specialty: 'Hilltop dining & Pakistani platter',
    website: 'https://themonal.com',
    phone: '+92 51 5837204',
  ),
  PunjabRestaurant(
    name: 'Bundu Khan Restaurant',
    area: 'Liberty Market',
    city: 'Lahore',
    rating: 4.5,
    reviewCount: 6200,
    specialty: 'Family BBQ, puri paratha & halwa',
    website: 'https://bundukhan.pk',
  ),
  PunjabRestaurant(
    name: 'Baba Tikka Shop',
    area: 'Purana Qila / Saddar',
    city: 'Faisalabad',
    rating: 4.6,
    reviewCount: 5100,
    specialty: 'Charcoal BBQ & traditional sajji',
  ),
];

const List<String> restaurantCities = [
  'All',
  'Lahore',
  'Islamabad',
  'Faisalabad',
];
