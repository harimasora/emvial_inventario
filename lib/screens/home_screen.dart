import 'package:emival_inventario/screens/places_screen.dart';
import 'package:emival_inventario/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TabItem { inventory, search }

final homeTabProvider = StateProvider<TabItem>((ref) {
  return TabItem.inventory;
});

final navigatorKeysProvider = Provider<Map<TabItem, GlobalKey<NavigatorState>>>((ref) {
  return {
    TabItem.inventory: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
  };
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(homeTabProvider.state);
    final navigatorKeys = ref.watch(navigatorKeysProvider);
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[currentTab.state].currentState.maybePop(),
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(
              TabItem.inventory,
              currentTab.state,
              {
                '/': (context) => const PlacesScreen(),
              },
              navigatorKeys,
            ),
            _buildOffstageNavigator(
              TabItem.search,
              currentTab.state,
              {
                '/': (context) => const SearchScreen(),
              },
              navigatorKeys,
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentTab.state.index,
          onTap: (index) => _onItemTapped(index, currentTab),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Obras',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Busca',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem, TabItem currentTab, Map<String, WidgetBuilder> routes,
      Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: Navigator(
        key: navigatorKeys[tabItem],
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (routes[settings.name] == null) {
            throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute<dynamic>(builder: routes[settings.name], settings: settings);
        },
      ),
    );
  }

  void _onItemTapped(int index, StateController<TabItem> currentTab) {
    currentTab.state = TabItem.values[index];
  }
}
