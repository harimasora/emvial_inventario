import 'package:emival_inventario/screens/add_place.dart';
import 'package:emival_inventario/screens/edit_place.dart';
import 'package:emival_inventario/screens/inventory_screen.dart';
import 'package:emival_inventario/screens/tools_screen.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:emival_inventario/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final places = watch(placesProvider);
    final db = watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder: (context) => const AddPlaceScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
          )
        ],
      ),
      body: ListView.separated(
        itemCount: places.state.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: const SlidableDrawerActionPane(),
            actionExtentRatio: 0.20,
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Editar',
                color: Colors.black45,
                icon: Icons.edit,
                onTap: () {
                  Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                      builder: (context) => EditPlaceScreen(
                        place: places.state[index],
                      ),
                    ),
                  );
                },
              ),
              IconSlideAction(
                caption: 'Apagar',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  final isDelete = await NotificationService.confirm(context, 'Apagar',
                      'Deseja realmente apagar esta obra? Todas as ferramentas desta obra também serão apagadas.');
                  if (isDelete == true) {
                    db.deletePlace(places.state[index]);
                  }
                },
              ),
            ],
            child: ListTile(
              title: Text(
                places.state[index].name ?? '',
              ),
              subtitle: Text('Ferramentas ${places.state[index].items.length}' ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                    builder: (context) => ToolsScreen(place: places.state[index]),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
      ),
    );
  }
}
