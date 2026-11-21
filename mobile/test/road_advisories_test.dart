import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/core/data/road_advisories.dart';

void main() {
  group('road advisories', () {
    test('every advisory carries an official source and reference date', () {
      expect(kRoadAdvisories, isNotEmpty);
      for (final advisory in kRoadAdvisories) {
        expect(advisory.corridor.trim(), isNotEmpty);
        expect(advisory.segment.trim(), isNotEmpty);
        expect(advisory.sourceAgency.trim(), isNotEmpty);
        expect(Uri.tryParse(advisory.sourceUrl)?.hasScheme, isTrue);
        expect(advisory.referenceDate, matches(r'^\d{4}-\d{2}-\d{2}$'));
        expect(advisory.alternativeRoute.trim(), isNotEmpty);
      }
    });

    test('no advisory pretends to be a live verified status', () {
      for (final advisory in kRoadAdvisories) {
        expect(advisory.status, RoadStatus.unavailable);
        expect(advisory.status.label, 'Information unavailable');
      }
    });

    test('advisory ids are unique', () {
      final ids = kRoadAdvisories.map((a) => a.id).toSet();
      expect(ids.length, kRoadAdvisories.length);
    });
  });
}
