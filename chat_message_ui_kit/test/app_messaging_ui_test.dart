import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('image message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Material()));
  });
}
