// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focus/main.dart';

void main() {
  testWidgets('checking click', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('There are no Todos'),
      ),
    ));
    // Find a widget that displays the letter 'There are no Todos'.
    expect(find.text('There are no Todos'), findsOneWidget);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: const [
            Icon(Icons.add_circle_rounded),
          ],
        ),
      ),
    ));

    expect(find.byIcon(Icons.add_circle_rounded), findsOneWidget);
  });
}
