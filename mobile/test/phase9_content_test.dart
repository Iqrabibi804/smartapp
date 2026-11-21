import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/features/places/screens/complaints_screen.dart';
import 'package:smartmap_ai/features/places/screens/foreigner_toolkit_screen.dart';
import 'package:smartmap_ai/features/places/screens/permits_screen.dart';

void main() {
  group('permits guidance', () {
    test('destinations and steps are populated', () {
      expect(kPermitDestinations, isNotEmpty);
      expect(kPermitSteps.length, greaterThanOrEqualTo(4));
      for (final destination in kPermitDestinations) {
        expect(destination.trim(), isNotEmpty);
      }
      for (final step in kPermitSteps) {
        expect(step.trim(), isNotEmpty);
      }
    });

    test('does not hardcode unverified permit time limits', () {
      final text = kPermitSteps.join(' ').toLowerCase();
      expect(text.contains('120 days'), isFalse);
      expect(text.contains('processing time:'), isFalse);
    });
  });

  group('foreign visitor toolkit', () {
    test('currencies and PTA steps are populated without fixed durations', () {
      expect(kToolkitCurrencies, containsAll(['USD', 'EUR', 'GBP', 'AED', 'SAR']));
      expect(kPtaSteps.length, greaterThanOrEqualTo(3));
      final text = kPtaSteps.join(' ').toLowerCase();
      expect(text.contains('120 days'), isFalse);
    });
  });

  group('complaints', () {
    test('categories cover the required report types', () {
      expect(kComplaintCategories, contains('Overcharging'));
      expect(kComplaintCategories, contains('Road problem'));
      expect(kComplaintCategories, contains('Other'));
      expect(kComplaintCategories.toSet().length, kComplaintCategories.length);
    });
  });
}
