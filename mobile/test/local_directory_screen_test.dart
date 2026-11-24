import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartmap_ai/features/places/screens/local_directory_screen.dart';

void main() {
  testWidgets('local directory exposes its categories and safe empty state',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LocalDirectoryScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Punjab Local Directory'), findsOneWidget);
    expect(find.text('Bus stations'), findsOneWidget);
    expect(find.text('Hotels'), findsOneWidget);
    expect(find.text('Restaurants'), findsOneWidget);
    expect(find.text('Police reference'), findsOneWidget);
    expect(
      find.text(
        'No records are available in this category yet. Run the workbook importer to populate the offline directory.',
      ),
      findsOneWidget,
    );
  });
}
