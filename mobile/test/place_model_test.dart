import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/features/places/models/place_model.dart';

void main() {
  group('PlaceModel verification provenance', () {
    test('legacy verified flag without source is not trusted', () {
      final place = PlaceModel.fromJson({
        '_id': 'legacy-place',
        'name': 'Legacy place',
        'verified': true,
        'location': {'type': 'Point', 'coordinates': [73.0, 31.0]},
      });

      expect(place.hasVerifiedDetails, isFalse);
    });

    test('verified status without verification timestamp is not trusted', () {
      final place = PlaceModel.fromJson({
        '_id': 'missing-date',
        'name': 'Place',
        'verified': true,
        'verificationStatus': 'verified',
        'source': 'https://official.example/place',
        'location': {'type': 'Point', 'coordinates': [73.0, 31.0]},
      });

      expect(place.hasVerifiedDetails, isFalse);
    });

    test('invalid verification timestamp is not trusted', () {
      final place = PlaceModel.fromJson({
        '_id': 'invalid-date',
        'name': 'Place',
        'verified': true,
        'verificationStatus': 'verified',
        'source': 'https://official.example/place',
        'lastVerifiedAt': 'not-a-date',
        'location': {'type': 'Point', 'coordinates': [73.0, 31.0]},
      });

      expect(place.hasVerifiedDetails, isFalse);
    });

    test('verified status cannot override a false verified flag', () {
      final place = PlaceModel.fromJson({
        '_id': 'contradictory-place',
        'name': 'Place',
        'verified': false,
        'verificationStatus': 'verified',
        'source': 'https://official.example/place',
        'lastVerifiedAt': '2026-11-20T10:00:00.000Z',
        'location': {'type': 'Point', 'coordinates': [73.0, 31.0]},
      });

      expect(place.hasVerifiedDetails, isFalse);
    });

    test('verified details require status, source and timestamp', () {
      final place = PlaceModel.fromJson({
        '_id': 'verified-place',
        'name': 'Verified place',
        'verified': true,
        'verificationStatus': 'verified',
        'source': 'https://official.example/place',
        'lastVerifiedAt': '2026-11-20T10:00:00.000Z',
        'location': {'type': 'Point', 'coordinates': [73.0, 31.0]},
      });

      expect(place.hasVerifiedDetails, isTrue);
    });
  });

  group('PlaceModel payment data', () {
    test('missing payment methods stay unknown instead of defaulting to cash apps', () {
      final place = PlaceModel.fromJson({
        '_id': 'place-1',
        'name': 'Test place',
        'location': {
          'type': 'Point',
          'coordinates': [73.0, 31.0],
        },
      });

      expect(place.paymentMethods, isEmpty);
    });

    test('explicit payment methods are preserved', () {
      final place = PlaceModel.fromJson({
        '_id': 'place-2',
        'name': 'Test place',
        'location': {
          'type': 'Point',
          'coordinates': [73.0, 31.0],
        },
        'paymentMethods': ['Cash'],
      });

      expect(place.paymentMethods, ['Cash']);
    });
  });
}
