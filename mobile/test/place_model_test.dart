import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/features/places/models/place_model.dart';

void main() {
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
