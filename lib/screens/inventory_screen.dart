import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:emival_inventario/models/place.dart';
import 'package:emival_inventario/screens/edit_place.dart';
import 'package:emival_inventario/screens/edit_tool.dart';
import 'package:emival_inventario/screens/help_screen.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/widgets/radial_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final placesProvider = StateProvider<List<Place>>((ref) {
  return ref.watch(inventoryStreamProvider).when(
        data: (data) {
          data.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          return data;
        },
        loading: () => [],
        error: (e, s) => [],
      );
});

class InventoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider.state);
    final inventory = ref.watch(inventoryStreamProvider);
    final db = ref.watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                builder: (context) => const HelpScreen(),
                fullscreenDialog: true,
              ));
            },
          )
        ],
      ),
      body: inventory.when(
        data: (data) {
          return DragAndDropLists(
            children: List.generate(
              places.state.length,
              (index) {
                return DragAndDropList(
                  canDrag: false,
                  contentsWhenEmpty: const Text('Não há ferramentas nesta obra'),
                  header: Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.2,
                      children: [
                        SlidableAction(
                          label: 'Editar',
                          backgroundColor: Colors.black45,
                          icon: Icons.edit,
                          onPressed: (context) {
                            Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                builder: (context) => EditPlaceScreen(
                                  place: places.state[index],
                                ),
                              ),
                            );
                          },
                        ),
                        SlidableAction(
                          label: 'Apagar',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            db.deletePlace(places.state[index]);
                          },
                        ),
                      ],
                    ),
                    child: ListTile(
                      tileColor: Colors.grey[300],
                      title: Text(places.state[index].name),
                      subtitle: Text('${places.state[index].items.length} ferramenta(s)'),
                    ),
                  ),
                  children: List.generate(
                    places.state[index].items.length,
                    (innerIndex) => DragAndDropItem(
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.2,
                          children: [
                            SlidableAction(
                              label: 'Editar',
                              backgroundColor: Colors.black45,
                              icon: Icons.edit,
                              onPressed: (context) {
                                Navigator.of(context).push<dynamic>(
                                  MaterialPageRoute<dynamic>(
                                    builder: (context) => EditToolScreen(
                                      item: places.state[index].items[innerIndex],
                                      place: places.state[index],
                                      places: places.state,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SlidableAction(
                              label: 'Apagar',
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              onPressed: (context) {
                                db.removeItemFromPlace(places.state[index], places.state[index].items[innerIndex]);
                              },
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            places.state[index].items[innerIndex].name,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
              final placesCopy =
                  List<Place>.generate(places.state.length, (index) => Place.fromJson(places.state[index].toJson()));
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
                  List<Place>.generate(places.state.length, (index) => Place.fromJson(places.state[index].toJson()));
              final movedList = placesCopy.removeAt(oldListIndex);
              placesCopy.insert(newListIndex, movedList);
              places.state = placesCopy;
            },
            itemDivider: const Divider(height: 1),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Obras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Busca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
      floatingActionButton: const RadialFab(),
    );
  }
}
