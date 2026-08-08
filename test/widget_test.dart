import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_study/main.dart';

void main() {
  testWidgets('shows configuration instructions without credentials', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.textContaining('Supabase configuration is missing'), findsOneWidget);
  });
}
