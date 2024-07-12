import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../models/item.dart';
import 'item_form_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Item Tracker'),
      ),
      body: ListView.builder(
        itemCount: itemProvider.items.length,
        itemBuilder: (context, index) {
          final item = itemProvider.items[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTap: () {
                    final renderBox = context.findRenderObject() as RenderBox;
                    final size = renderBox.size;
                    final position = renderBox.localToGlobal(Offset.zero);
                    print('Size: $size, Position: $position');

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ItemFormScreen(
                          item: item,
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.blue.shade100),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          itemProvider.removeItem(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ItemFormScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
