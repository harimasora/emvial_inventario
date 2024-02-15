import 'package:emival_inventario/screens/add_tool.dart';
import 'package:emival_inventario/screens/edit_tool.dart';
import 'package:emival_inventario/screens/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolsScreen extends ConsumerWidget {
  final String placeId;
  const ToolsScreen({Key? key, required this.placeId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);
    final place = places.firstWhere((element) => element.id == placeId);
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
                    place.items[index].name,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                        builder: (context) => EditToolScreen(
                          item: place.items[index],
                          place: place,
                          places: places,
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
