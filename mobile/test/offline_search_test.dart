import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/core/data/punjab_offline_data.dart';

void main() {
  group('offline place filtering', () {
    test('hospital category only returns hospitals', () {
      final results = PunjabOfflineData.filterPlaces(categoryName: 'Hospitals & Medical');
      expect(results, isNotEmpty);
      for (final place in results) {
        expect(place.categoryName, 'Hospitals & Medical');
      }
    });

    test('offline category IDs filter the expected category', () {
      final results = PunjabOfflineData.filterPlaces(categoryId: 'cat-hospitals');
      expect(results, isNotEmpty);
      for (final place in results) {
        expect(place.categoryName, 'Hospitals & Medical');
      }
    });

    test('unknown offline category IDs return no unrelated places', () {
      expect(PunjabOfflineData.filterPlaces(categoryId: 'unknown-category'), isEmpty);
    });

    test('city filter only returns places referencing that city', () {
      final results = PunjabOfflineData.filterPlaces(city: 'Lahore');
      expect(results, isNotEmpty);
      for (final place in results) {
        final haystack =
            '${place.address} ${place.name} ${place.description} ${place.city ?? ''}'.toLowerCase();
        expect(haystack.contains('lahore'), isTrue);
      }
    });

    test('minimum rating threshold is respected', () {
      final results = PunjabOfflineData.filterPlaces(minRating: 4.5);
      for (final place in results) {
        expect(place.rating, greaterThanOrEqualTo(4.5));
      }
    });

    test('price range filter returns only matching price bands', () {
      final results = PunjabOfflineData.filterPlaces(priceRange: 'high');
      expect(results, isNotEmpty);
      for (final place in results) {
        expect(place.priceRange, 'high');
      }
    });

    test('unmatched price range returns no unrelated places', () {
      final results = PunjabOfflineData.filterPlaces(priceRange: 'not-a-real-band');
      expect(results, isEmpty);
    });

    test('sort by rating returns descending ratings', () {
      final results = PunjabOfflineData.filterPlaces(sort: 'rating');
      expect(results, isNotEmpty);
      for (var i = 1; i < results.length; i++) {
        expect(results[i - 1].rating, greaterThanOrEqualTo(results[i].rating));
      }
    });

    test('sort by popularity returns descending review counts', () {
      final results = PunjabOfflineData.filterPlaces(sort: 'popular');
      expect(results, isNotEmpty);
      for (var i = 1; i < results.length; i++) {
        expect(results[i - 1].reviewCount, greaterThanOrEqualTo(results[i].reviewCount));
      }
    });

    test('keyword search matches name and address fields', () {
      final results = PunjabOfflineData.filterPlaces(query: 'Badshahi');
      expect(results, isNotEmpty);
      expect(results.any((p) => p.name.toLowerCase().contains('badshahi')), isTrue);
    });
  });
}
