import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/widgets/radial_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final placesProvider = StateProvider<List<Place>>((ref) {
  return ref.watch(inventoryStreamProvider).when(
        data: (data) => data,
        loading: () => [],
        error: (e, s) => [],
      );
});

class InventoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final places = watch(placesProvider);
    final inventory = watch(inventoryStreamProvider);
    final db = watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
      ),
      body: inventory.when(
        data: (data) {
          return DragAndDropLists(
            children: List.generate(places.state.length, (index) {
              return DragAndDropList(
                header: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text(
                            places.state[index].name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                children: List.generate(
                    places.state[index].items.length,
                    (innerIndex) => DragAndDropItem(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                child: Text(
                                  places.state[index].items[innerIndex].name,
                                ),
                              ),
                            ],
                          ),
                        )),
              );
            }),
            onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
              final placesCopy =
                  List<Place>.generate(places.state.length, (index) => Place.fromMap(places.state[index].toMap()));
              final movedItem = placesCopy[oldListIndex].items.removeAt(oldItemIndex);
              placesCopy[newListIndex].items.insert(newItemIndex, movedItem);

              for (var i = 0; i < placesCopy.length; i++) {
                final place = placesCopy[i];
                if (place.toString() != places.state[i].toString()) {
                  db.savePlace(place);
                }
              }

              places.state = placesCopy;
            },
            onListReorder: (int oldListIndex, int newListIndex) {
              final placesCopy =
                  List<Place>.generate(places.state.length, (index) => Place.fromMap(places.state[index].toMap()));
              final movedList = placesCopy.removeAt(oldListIndex);
              placesCopy.insert(newListIndex, movedList);
              places.state = placesCopy;
            },
            // listPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemDivider: const Divider(),
            itemDecorationWhileDragging: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3, // changes position of shadow
                ),
              ],
            ),
            dragHandle: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.menu,
                color: Colors.black26,
              ),
            ),
          );
        },
        loading: () => const Center(child: Text('Carregando...')),
        error: (error, stackTrace) => Center(
          child: Column(
            children: [
              const Text('Something went wrong...'),
              Text(
                error.toString(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: const RadialFab(),
    );
  }
}
