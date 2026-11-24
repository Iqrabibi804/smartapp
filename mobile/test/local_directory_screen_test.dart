import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/features/places/screens/local_directory_screen.dart';

void main() {
  testWidgets('local directory exposes categories and reflects bundled data',
      (tester) async {
    final raw = await rootBundle.loadString('assets/data/punjab_directory.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;

    await tester.pumpWidget(
      const MaterialApp(home: LocalDirectoryScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Punjab Local Directory'), findsOneWidget);
    expect(find.text('Bus stations'), findsOneWidget);
    expect(find.text('Hotels'), findsOneWidget);
    expect(find.text('Restaurants'), findsOneWidget);
    expect(find.text('Police reference'), findsOneWidget);

    final busStations = data['busStations'] as List? ?? const [];
    if (busStations.isEmpty) {
      // Build-safe placeholder is allowed until the generated workbook asset
      // is committed. Once populated, assert the source workbook counts and
      // fail if any row is accidentally promoted to verified.
      expect(
        find.text(
          'No records are available in this category yet. Run the workbook importer to populate the offline directory.',
        ),
        findsOneWidget,
      );
      return;
    }

    final counts = data['metadata']['sheetCounts'] as Map<String, dynamic>;
    expect(counts['busStations'], 246);
    expect(counts['hotels'], 733);
    expect(counts['restaurants'], 1166);
    expect(counts['islamabadPolice'], 27);
    expect(counts['islamabadAreaToStation'], 100);
    expect(counts['lahorePolice'], 94);
    expect(counts['punjabHierarchy'], 162);
    expect(counts['appCities'], 81);

    for (final key in [
      'busStations',
      'hotels',
      'restaurants',
      'islamabadPolice',
      'islamabadAreaToStation',
      'lahorePolice',
      'islamabadZoneSummary',
      'punjabHierarchy',
      'punjabDistrictSummary',
      'appCities',
      'tehsilCoverage',
      'divisionSummary',
      'citySummary',
    ]) {
      final rows = data[key] as List;
      expect(rows, isNotEmpty, reason: '$key should be imported');
      for (final row in rows) {
        expect(row['referenceOnly'], isTrue, reason: '$key must remain reference-only');
        expect(row['verified'], isNot(true), reason: '$key must not be marked verified');
      }
    }

    expect(find.text('246 entries'), findsOneWidget);
  });
}
