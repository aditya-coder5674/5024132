import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:madl_aditya/main.dart';

void main() {
  testWidgets('home screen opens the second screen with both navigation styles', (
    tester,
  ) async {
    await tester.pumpWidget(const NavigationGestureApp());

    expect(find.text('Navigation & gestures'), findsOneWidget);
    expect(find.text('Open with push'), findsOneWidget);
    expect(find.text('Open named route'), findsOneWidget);

    await tester.tap(find.text('Open with push'));
    await tester.pumpAndSettle();
    expect(find.text('Second screen'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Navigation & gestures'), findsOneWidget);

    await tester.tap(find.text('Open named route'));
    await tester.pumpAndSettle();
    expect(find.text('Second screen'), findsOneWidget);
  });

  testWidgets('gesture card responds to tap, double tap, and long press', (
    tester,
  ) async {
    await tester.pumpWidget(const NavigationGestureApp());
    final cardFinder = find.byKey(const Key('gesture-card'));
    final initialColor = tester.widget<Card>(cardFinder).color;

    await tester.tap(cardFinder);
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Single tap detected'), findsOneWidget);

    await tester.tap(cardFinder);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(cardFinder);
    await tester.pumpAndSettle();
    expect(tester.widget<Card>(cardFinder).color, isNot(initialColor));

    await tester.longPress(cardFinder);
    await tester.pumpAndSettle();
    expect(find.text('Long press detected'), findsOneWidget);
  });
}
