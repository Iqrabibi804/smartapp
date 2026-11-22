/// Punjab stays listed on Booking.com.
///
/// Scores, review counts and facilities are the figures supplied in the
/// November 2026 Booking.com search snapshot. They are third-party listing
/// data, not reviews collected by this app, and they change over time. Every
/// link opens a live Booking.com search for the property so prices and
/// availability are always read from Booking.com itself.
class PunjabStay {
  const PunjabStay({
    required this.name,
    required this.area,
    required this.city,
    required this.score,
    required this.scoreWord,
    required this.reviewCount,
    required this.facilities,
  });

  final String name;
  final String area;
  final String city;

  /// Booking.com 10-point score, or null for a listing with no score yet.
  final double? score;
  final String scoreWord;
  final int reviewCount;
  final List<String> facilities;

  bool get hasRating => score != null && reviewCount > 0;

  Uri get bookingUri => Uri.https('www.booking.com', '/searchresults.html', {
        'ss': '$name, $area, $city',
        'lang': 'en-us',
      });

  Uri get mapUri => Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': '$name, $area, $city',
      });
}

const List<PunjabStay> punjabStays = [
  PunjabStay(
    name: 'Hotel Crown Lahore',
    area: 'Johar Town',
    city: 'Lahore',
    score: 9.2,
    scoreWord: 'Wonderful',
    reviewCount: 15,
    facilities: ['Free parking', 'Free WiFi', 'AC', 'Terrace'],
  ),
  PunjabStay(
    name: 'Relax Inn Guest House',
    area: 'Lahore',
    city: 'Lahore',
    score: 10.0,
    scoreWord: 'Exceptional',
    reviewCount: 1,
    facilities: ['Free WiFi', 'Free private parking', 'Terrace'],
  ),
  PunjabStay(
    name: 'Executive Guest House DHA Phase 3',
    area: 'DHA Phase 3',
    city: 'Lahore',
    score: 7.4,
    scoreWord: 'Good',
    reviewCount: 5,
    facilities: ['24-hr front desk', 'Security', 'Room service'],
  ),
  PunjabStay(
    name: 'Bahria Elite Residence',
    area: 'Bahria Town',
    city: 'Rawalpindi',
    score: 10.0,
    scoreWord: 'Exceptional',
    reviewCount: 4,
    facilities: ['Free WiFi', 'Terrace', 'Location 10/10'],
  ),
  PunjabStay(
    name: 'Firefly Retreat',
    area: 'Rawalpindi',
    city: 'Rawalpindi',
    score: 8.7,
    scoreWord: 'Excellent',
    reviewCount: 100,
    facilities: ['City views', 'Garden', 'Shared lounge'],
  ),
  PunjabStay(
    name: 'Cozy & Peaceful Rooms Near Lyallpur Galleria',
    area: 'Near Lyallpur Galleria',
    city: 'Faisalabad',
    score: 9.3,
    scoreWord: 'Wonderful',
    reviewCount: 195,
    facilities: ['Balcony', 'AC', 'Free WiFi'],
  ),
  PunjabStay(
    name: 'Hotel Radisson Blu Inn',
    area: 'Multan',
    city: 'Multan',
    score: 8.8,
    scoreWord: 'Excellent',
    reviewCount: 12,
    facilities: ['Garden', 'Terrace', 'Free private parking'],
  ),
  PunjabStay(
    name: 'Hill View Park Guest House',
    area: 'Citi Housing',
    city: 'Jhelum',
    score: 7.9,
    scoreWord: 'Good',
    reviewCount: 61,
    facilities: ['Sauna', 'Hot tub', 'AC'],
  ),
  PunjabStay(
    name: 'Chakwal Guest House',
    area: 'Near Kallar Kahar',
    city: 'Chakwal',
    score: 6.0,
    scoreWord: 'Review score',
    reviewCount: 2,
    facilities: ['Balcony', 'City views', 'Free parking'],
  ),
  PunjabStay(
    name: 'KMA Guest House',
    area: 'Sialkot',
    city: 'Sialkot',
    score: null,
    scoreWord: 'New on Booking.com',
    reviewCount: 0,
    facilities: ['Garden views', 'Free private parking'],
  ),
];

const List<String> stayCities = [
  'All',
  'Lahore',
  'Rawalpindi',
  'Faisalabad',
  'Multan',
  'Jhelum',
  'Chakwal',
  'Sialkot',
];

final Uri allPunjabStaysUri =
    Uri.https('www.booking.com', '/searchresults.html', {
  'ss': 'Punjab, Pakistan',
  'lang': 'en-us',
});
