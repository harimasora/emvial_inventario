import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final sampleReorderProvider = StateProvider<List<String>>((ref) {
  return ['Item 1', 'Item 2', 'Item 3'];
});

class HelpScreen extends ConsumerWidget {
  const HelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final overtextStyle = Theme.of(context).textTheme.overline.copyWith(color: Theme.of(context).primaryColor);
    final sampleList = watch(sampleReorderProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('COMO UTILIZAR', style: overtextStyle),
                const SizedBox(height: 16),
                const Text('Primeiramente, crie um local'),
                const SizedBox(height: 4),
                const Text('Depois, crie as ferramentas e as adicione nos locais criados.'),
                const SizedBox(height: 16),
                Text('COMO ORGANIZAR', style: overtextStyle),
                const SizedBox(height: 16),
                const Text('Segure em um item na lista para reorganizá-lo.'),
                const SizedBox(height: 4),
                SizedBox(
                  height: 402,
                  child: DragAndDropLists(
                    disableScrolling: true,
                    children: [
                      DragAndDropList(
                        canDrag: false,
                        contentsWhenEmpty: const Text('Não há ferramentas nesta obra'),
                        header: ListTile(
                          tileColor: Colors.grey[300],
                          title: const Text('Nome da obra'),
                        ),
                        children: List.generate(
                          sampleList.state.length,
                          (innerIndex) => DragAndDropItem(
                            child: Slidable(
                              actionPane: const SlidableDrawerActionPane(),
                              actionExtentRatio: 0.20,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: 'Editar',
                                  color: Colors.black45,
                                  icon: Icons.edit,
                                  onTap: () {},
                                ),
                                IconSlideAction(
                                  caption: 'Apagar',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {},
                                ),
                              ],
                              child: ListTile(
                                title: Text(
                                  sampleList.state[innerIndex],
                                ),
                                subtitle: const Text('Deslize para esquerda para mais opções'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    onItemReorder: (int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
                      final sampleListCopy =
                          List<String>.generate(sampleList.state.length, (index) => sampleList.state[index]);
                      final movedItem = sampleListCopy.removeAt(oldItemIndex);
                      sampleListCopy.insert(newItemIndex, movedItem);

                      sampleList.state = sampleListCopy;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
