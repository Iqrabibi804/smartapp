import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/features/places/screens/culture_companion_screen.dart';
import 'package:smartmap_ai/features/trips/screens/journey_readiness_screen.dart';

void main() {
  group('journey readiness content', () {
    test('has substantive sections with unique item ids', () {
      expect(kReadinessSections.length, greaterThanOrEqualTo(5));
      final ids = <String>[];
      for (final section in kReadinessSections) {
        expect(section.title.trim(), isNotEmpty);
        expect(section.items, isNotEmpty);
        for (final item in section.items) {
          expect(item.id.trim(), isNotEmpty);
          expect(item.label.trim(), isNotEmpty);
          ids.add(item.id);
        }
      }
      expect(ids.toSet().length, ids.length);
    });
  });

  group('culture companion content', () {
    test('tips and phrases are populated', () {
      expect(kCultureTips.length, greaterThanOrEqualTo(5));
      for (final tip in kCultureTips) {
        expect(tip.title.trim(), isNotEmpty);
        expect(tip.body.trim(), isNotEmpty);
      }
      expect(kUsefulPhrases.length, greaterThanOrEqualTo(5));
      for (final phrase in kUsefulPhrases) {
        expect(phrase.key.trim(), isNotEmpty);
        expect(phrase.value.trim(), isNotEmpty);
      }
    });
  });
}
