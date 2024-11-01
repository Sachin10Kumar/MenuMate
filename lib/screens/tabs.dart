import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:food_menu/data/dummy_data.dart';
import 'package:food_menu/screens/categories.dart';
import 'package:food_menu/screens/filters.dart';
import 'package:food_menu/screens/meals.dart';
import 'package:food_menu/models/meal.dart';
import 'package:food_menu/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree:false,
    Filter.lactoseFree:false,
    Filter.vegetarian:false,
    Filter.vegan:false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter,bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String meassge) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:Text(message),
        );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite.')
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as a favorite.')
      });
    }
  }

  void _seletPage(int index) {
    setState(() {
      __selectedPageIndex = index;
    });
  }
 
void _setScreen(String identifier) async{
  Navigator.of(context).pop();
  if(identifier == 'filters') {
    final result = await Navigator.of(context).push<Map<Filter,bool>>(
      MaterialPageRoute(
        builder: (ctx) => const FiltersScreen(currentFilters: _selectedFilters,),
    ),
    );
    setState(() {
       _selectedFilter =result ?? kInitialFilters;
    });
   } 
}

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      } 
      if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }  
      if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if(_selectedFilters[Filter.vegan]! && !meal.isVeganFree) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen,),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _seletPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
