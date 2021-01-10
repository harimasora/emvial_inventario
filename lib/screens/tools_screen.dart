import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/screens/add_tool.dart';
import 'package:emival_inventario/screens/edit_tool.dart';
import 'package:emival_inventario/screens/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolsScreen extends ConsumerWidget {
  final Place place;
  const ToolsScreen({@required this.place, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final places = watch(placesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ferramentas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder: (context) => AddToolScreen(place: place),
                  fullscreenDialog: true,
                ),
              );
            },
          )
        ],
      ),
      body: place.items.isEmpty
          ? const Center(
              child: Text('Não há ferramentas nesta obra'),
            )
          : ListView.separated(
              itemCount: place.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    place.items[index].name ?? '',
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                        builder: (context) => EditToolScreen(
                          item: place.items[index],
                          place: place,
                          places: places.state,
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
    );
  }
}
