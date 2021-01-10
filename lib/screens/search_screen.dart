import 'package:emival_inventario/models/place_item.dart';
import 'package:emival_inventario/screens/edit_tool.dart';
import 'package:emival_inventario/screens/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTextProvider = StateProvider<String>((ref) {
  return '';
});

final placesItemsProvider = Provider<List<PlaceItem>>((ref) {
  final places = ref.watch(placesProvider);
  final List<PlaceItem> placeItems = [];

  for (final place in places.state) {
    for (final item in place.items) {
      placeItems.add(PlaceItem(place: place, item: item));
    }
  }

  placeItems.sort((a, b) => a.item.name.compareTo(b.item.name));

  return placeItems;
});

final searchResultsProvider = Provider<List<PlaceItem>>((ref) {
  final placesItems = ref.watch(placesItemsProvider);
  final subject = ref.watch(searchTextProvider);

  return placesItems.where((v) => v.item.name.toLowerCase().contains(subject.state.toLowerCase())).toList();
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final places = watch(placesProvider);
    final searchResults = watch(searchResultsProvider);
    final subject = watch(searchTextProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Nome da ferramenta',
              prefixIcon: Icon(Icons.search),
            ),
            initialValue: subject.state,
            onChanged: (value) {
              subject.state = value;
            },
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: searchResults.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(searchResults[index].item.name),
              subtitle: Text(searchResults[index].place.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                    builder: (context) => EditToolScreen(
                      item: searchResults[index].item,
                      place: searchResults[index].place,
                      places: places.state,
                    ),
                  ),
                );
              },
            ),
            separatorBuilder: (context, index) => const Divider(height: 1),
          ),
        ],
      ),
    );
  }
}
