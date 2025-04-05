import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paysync/src/app.dart';

void main() {
  testWidgets('Initial app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
  });
}
