import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/features/places/services/osm_facilities_service.dart';

void main() {
  group('OSM facility distance', () {
    test('same coordinates return zero', () {
      expect(OsmFacilitiesService.distanceKm(33.6844, 73.0479, 33.6844, 73.0479), 0);
    });

    test('calculates a reasonable distance between nearby coordinates', () {
      final distance = OsmFacilitiesService.distanceKm(33.6844, 73.0479, 33.6944, 73.0479);
      expect(distance, greaterThan(1.0));
      expect(distance, lessThan(1.2));
    });
  });
}
