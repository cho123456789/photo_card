import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_study/main.dart';

void main() {
  testWidgets('shows the empty collection state', (tester) async {
    await tester.pumpWidget(const PhotocardBinderApp());
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
