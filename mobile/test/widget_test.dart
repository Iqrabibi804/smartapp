import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartmap_ai/main.dart';
import 'package:smartmap_ai/core/data/punjab_offline_data.dart';
import 'package:smartmap_ai/features/categories/services/categories_service.dart';
import 'package:smartmap_ai/features/places/services/places_providers.dart';
import 'package:smartmap_ai/features/events/services/events_service.dart';

void main() {
  testWidgets('SmartMapApp renders splash and leaves it cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        // Keep the test hermetic: no real network calls from HomeScreen.
        overrides: [
          categoriesProvider.overrideWith((ref) async => PunjabOfflineData.categories),
          popularPlacesProvider.overrideWith((ref) async => PunjabOfflineData.places.take(8).toList()),
          upcomingEventsProvider.overrideWith((ref) async => []),
        ],
        child: const SmartMapApp(),
      ),
    );

    expect(find.text('SmartMap Punjab'), findsOneWidget);

    // Advance in steps: the splash schedules its minimum brand delay after
    // session restore resolves, so one large pump can leave it pending.
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 2));

    // Dispose the tree so no timers remain pending at test teardown.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
