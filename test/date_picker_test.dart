import 'package:digi_witch/ui/numerology_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calendar button fills the date field without a keyboard', (
    t,
  ) async {
    final c = TextEditingController(text: '29.05.1975');
    await t.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextField(
              controller: c,
              decoration: InputDecoration(
                suffixIcon: datePickerButton(context, c),
              ),
            ),
          ),
        ),
      ),
    );
    await t.tap(find.byIcon(Icons.calendar_month_outlined));
    await t.pumpAndSettle();
    await t.tap(find.text('1980')); // opens on the year list, at the typed date
    await t.pumpAndSettle();
    await t.tap(find.text('OK'));
    await t.pumpAndSettle();
    expect(c.text, '29.05.1980');
  });
}
