import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:emival_inventario/services/db_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

final contentProvider = StateProvider<List<DragAndDropListInterface>>((ref) {
  final provider = ref.watch(inventoryProvider);

  return provider.when(
    data: (inventory) {
      return List.generate(inventory.length, (index) {
        return DragAndDropList(
          header: Column(
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      inventory[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: List.generate(
              inventory[index].items.length,
              (innerIndex) => DragAndDropItem(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Text(
                            inventory[index].items[innerIndex].name,
                          ),
                        ),
                      ],
                    ),
                  )),
        );
      });
    },
    loading: () => [],
    error: (e, s) => [],
  );
});

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DragHandleExample(),
    );
  }
}

class DragHandleExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final content = watch(contentProvider);
    final inventory = watch(inventoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
      ),
      body: inventory.when(
        data: (data) {
          return DragAndDropLists(
            children: content.state,
            onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
              final contentCopy = List<DragAndDropListInterface>.from(content.state);
              final movedItem = contentCopy[oldListIndex].children.removeAt(oldItemIndex);
              contentCopy[newListIndex].children.insert(newItemIndex, movedItem);
              content.state = contentCopy;
            },
            onListReorder: (int oldListIndex, int newListIndex) {
              final contentCopy = List<DragAndDropListInterface>.from(content.state);
              final movedList = contentCopy.removeAt(oldListIndex);
              contentCopy.insert(newListIndex, movedList);
              content.state = contentCopy;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
