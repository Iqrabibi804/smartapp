import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/core/data/punjab_police_data.dart';

void main() {
  group('Police directory snapshot', () {
    test('contains 27 Islamabad stations', () {
      final entries = policeDirectoryEntries
          .where((entry) => entry.city == 'Islamabad')
          .toList();
      expect(entries, hasLength(27));
      expect(entries.every((entry) => entry.type == 'Police Station'), isTrue);
    });

    test('contains 84 Lahore stations and 10 police posts', () {
      final entries = policeDirectoryEntries
          .where((entry) => entry.city == 'Lahore')
          .toList();
      expect(entries, hasLength(94));
      expect(entries.where((entry) => entry.type == 'Police Station'),
          hasLength(84));
      expect(entries.where((entry) => entry.type == 'Police Post'),
          hasLength(10));
    });

    test('Islamabad area coverage has no blank station or zone', () {
      expect(islamabadAreaCoverage, isNotEmpty);
      expect(
        islamabadAreaCoverage.every(
          (entry) => entry.area.isNotEmpty &&
              entry.station.isNotEmpty &&
              entry.zone.isNotEmpty,
        ),
        isTrue,
      );
    });

    test('directory retains source labels and handles missing phone numbers', () {
      final aabpara = policeDirectoryEntries
          .firstWhere((entry) => entry.name == 'Aabpara');
      final sangjani = policeDirectoryEntries
          .firstWhere((entry) => entry.city == 'Islamabad' &&
              entry.name == 'Sangjani');
      expect(aabpara.source, contains('INCPak'));
      expect(aabpara.phone, '051-9204830');
      expect(sangjani.phone, isNull);
    });
  });
}
