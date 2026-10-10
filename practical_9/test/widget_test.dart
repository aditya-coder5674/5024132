import 'package:flutter_test/flutter_test.dart';
import 'package:practical_9/main.dart';

void main() {
  testWidgets('shows Firebase setup details before configuration', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const PracticalNineApp(
        user: null,
        setupError: 'Firebase has not been configured.',
      ),
    );

    expect(find.text('Firebase Database'), findsOneWidget);
    expect(find.text('Firebase setup required'), findsOneWidget);
    expect(find.text('Firebase has not been configured.'), findsOneWidget);
    expect(
      find.text('You have pushed the button this many times:'),
      findsNothing,
    );
  });
}
