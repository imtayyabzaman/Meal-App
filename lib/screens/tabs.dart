import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/filters_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({
    super.key,
  });

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'Filters') {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final avaliableMeal = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(
      avaliableMeals: avaliableMeal,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favourite Meal';
    }
    return Scaffold(
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.set_meal,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
            ),
            label: 'Favourite',
          ),
        ],
      ),
    );
  }
}
