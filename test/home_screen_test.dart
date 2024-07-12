import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:item_tracker/providers/item_provider.dart';
import 'package:item_tracker/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays items and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ItemProvider(),
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Verify that there are no items initially
    expect(find.byType(ListTile), findsNothing);

    // Add an item
    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    final nameField = find.byType(TextFormField).first;
    final descriptionField = find.byType(TextFormField).last;
    final saveButton = find.text('Add');

    await tester.enterText(nameField, 'Test');
    await tester.enterText(descriptionField, 'Description');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Verify that the item is added
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
  });
}
