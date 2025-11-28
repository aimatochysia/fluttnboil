/// FluttnBoil Tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fluttnboil/main.dart';

void main() {
  testWidgets('FluttnBoil app starts without error', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: FluttnBoilApp(),
      ),
    );

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the app renders (landing page should show)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Landing page shows app name', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FluttnBoilApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Look for FluttnBoil text
    expect(find.text('FluttnBoil'), findsWidgets);
  });
}
