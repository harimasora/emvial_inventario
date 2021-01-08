import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      home: DragHandleExample(title: 'Flutter Demo Home Page'),
    );
  }
}

class DragHandleExample extends StatefulWidget {
  const DragHandleExample({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DragHandleExample createState() => _DragHandleExample();
}

class _DragHandleExample extends State<DragHandleExample> {
  List<DragAndDropList> _contents;

  @override
  void initState() {
    super.initState();

    _contents = [
      DragAndDropList(
        header: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    'Park Way Quadra 26',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Marreta',
                  ),
                ),
              ],
            ),
          ),
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Maquita',
                  ),
                ),
              ],
            ),
          ),
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Nível laser',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      DragAndDropList(
        header: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    'Lago Sul QE 11',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Marreta',
                  ),
                ),
              ],
            ),
          ),
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Britadeira',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      DragAndDropList(
        header: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    'Park Way Quadra 12',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Pá',
                  ),
                ),
              ],
            ),
          ),
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Maquita',
                  ),
                ),
              ],
            ),
          ),
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Marreta',
                  ),
                ),
              ],
            ),
          ),
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Nível laser',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      DragAndDropList(
        header: Column(
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    'Lago Norte QI 5',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: <DragAndDropItem>[
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Marreta',
                  ),
                ),
              ],
            ),
          ),
          DragAndDropItem(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'Nível laser',
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
      ),
      body: DragAndDropLists(
        children: _contents,
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      final movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  void _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      final movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }
}
