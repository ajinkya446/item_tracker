import 'package:flutter_test/flutter_test.dart';
import 'package:item_tracker/models/item.dart';
import 'package:item_tracker/providers/item_provider.dart';

void main() {
  group('ItemProvider', () {
    late ItemProvider itemProvider;

    setUp(() {
      itemProvider = ItemProvider();
    });

    test('Initial items list is empty', () {
      expect(itemProvider.items, isEmpty);
    });

    test('Add item to the list', () {
      final item = Item(name: 'Test', description: 'Description');
      itemProvider.addItem(item);

      expect(itemProvider.items, contains(item));
    });

    test('Edit item in the list', () {
      final item = Item(name: 'Test', description: 'Description');
      itemProvider.addItem(item);

      final newItem = Item(name: 'New Test', description: 'New Description');
      itemProvider.editItem(0, newItem);

      expect(itemProvider.items[0], equals(newItem));
    });

    test('Remove item from the list', () {
      final item = Item(name: 'Test', description: 'Description');
      itemProvider.addItem(item);
      itemProvider.removeItem(0);

      expect(itemProvider.items, isEmpty);
    });
  });
}
