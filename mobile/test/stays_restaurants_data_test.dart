import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/core/data/punjab_restaurants_data.dart';
import 'package:smartmap_ai/core/data/punjab_stays_data.dart';

void main() {
  group('Punjab stays', () {
    test('every stay links to a live Booking.com search, not a homepage', () {
      expect(punjabStays, hasLength(10));
      for (final stay in punjabStays) {
        final uri = stay.bookingUri;
        expect(uri.scheme, 'https');
        expect(uri.host, 'www.booking.com');
        expect(uri.path, '/searchresults.html',
            reason: '${stay.name} must not point at the bare homepage');
        expect(uri.queryParameters['ss'], contains(stay.name));
        expect(uri.queryParameters['ss'], contains(stay.city));
      }
    });

    test('ratings only exist when a review count backs them', () {
      for (final stay in punjabStays) {
        if (stay.hasRating) {
          expect(stay.score, isNotNull);
          expect(stay.reviewCount, greaterThan(0));
          expect(stay.score, inInclusiveRange(0, 10));
        }
      }
      final newListing =
          punjabStays.firstWhere((s) => s.name == 'KMA Guest House');
      expect(newListing.hasRating, isFalse);
    });

    test('city filter covers every listed city plus All', () {
      expect(stayCities.first, 'All');
      for (final stay in punjabStays) {
        expect(stayCities, contains(stay.city));
      }
    });

    test('the browse banner opens a Punjab-wide Booking.com search', () {
      expect(allPunjabStaysUri.host, 'www.booking.com');
      expect(allPunjabStaysUri.queryParameters['ss'], 'Punjab, Pakistan');
    });
  });

  group('Punjab restaurants', () {
    test('the guide contains dining only', () {
      expect(punjabRestaurants, isNotEmpty);
      for (final restaurant in punjabRestaurants) {
        final name = restaurant.name.toLowerCase();
        expect(name, isNot(contains('harappa')));
        expect(name, isNot(contains('dhq')));
        expect(name, isNot(contains('hospital')));
      }
    });

    test('every restaurant has a working fallback action', () {
      for (final restaurant in punjabRestaurants) {
        expect(restaurant.mapUri.queryParameters['query'],
            contains(restaurant.name));
        if (restaurant.website != null) {
          expect(restaurant.websiteUri!.scheme, 'https');
        }
        if (restaurant.phone != null) {
          expect(restaurant.callUri!.scheme, 'tel');
        }
        expect(restaurant.rating, inInclusiveRange(0, 5));
        expect(restaurant.reviewCount, greaterThan(0));
      }
    });

    test('city filter covers every listed city plus All', () {
      expect(restaurantCities.first, 'All');
      for (final restaurant in punjabRestaurants) {
        expect(restaurantCities, contains(restaurant.city));
      }
    });
  });
}
