import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartmap_ai/main.dart';

void main() {
  testWidgets('SmartMapApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SmartMapApp()));
    expect(find.byType(SmartMapApp), findsOneWidget);
  });
}
