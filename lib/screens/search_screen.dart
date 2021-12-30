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

  for (final place in places) {
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

  return placesItems.where((v) => v.item.name.toLowerCase().contains(subject.toLowerCase())).toList();
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final places = ref.watch(placesProvider);
        final searchResults = ref.watch(searchResultsProvider);
        final subject = ref.watch(searchTextProvider.state);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Buscar'),
          ),
          body: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nome da ferramenta',
                  prefixIcon: const Icon(Icons.search),
                  suffix: subject.state.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            subject.state = '';
                            searchController.text = '';
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Icon(Icons.close),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                controller: searchController,
                onChanged: (value) {
                  subject.state = value;
                },
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(searchResults[index].item.name),
                    subtitle: Text(searchResults[index].place.name),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      subject.state = '';
                      searchController.text = '';
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                          builder: (context) => EditToolScreen(
                            item: searchResults[index].item,
                            place: searchResults[index].place,
                            places: places,
                          ),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (context, index) => const Divider(height: 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
