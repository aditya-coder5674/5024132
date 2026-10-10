// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:practical_8/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the device storage screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PracticalEightApp());

    expect(find.text('Device Storage'), findsOneWidget);
    expect(find.text('Text file content'), findsOneWidget);
    expect(
      find.text(
        'The app locates its documents directory, writes a sample file, '
        'and reads it back asynchronously.',
      ),
      findsOneWidget,
    );
    expect(find.text('practical_8_sample.txt'), findsOneWidget);
    expect(find.text('Write and read again'), findsOneWidget);
  });
}
