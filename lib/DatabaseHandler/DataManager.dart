import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static final DataManager _singleton = DataManager._internal();

  factory DataManager() {
    return _singleton;
  }

  DataManager._internal();

  late List<int> favProducts;

  Future<void> saveFavProducts() async {
    List<String> listFav = <String>[];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < favProducts.length; i++) {
      listFav.add(favProducts[i].toString());
    }
    await prefs.setStringList('favourite', listFav);
  }

  Future<void> loadFavProducts() async {
    favProducts = <int>[];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList('favourite');
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        favProducts.add(int.parse(list[i]));
      }
    }
  }

  bool checkFavourite(int id) {
    if (favProducts.contains(id)) {
      return true;
    }
    return false;
  }

  Future<void> removeFavourite(int id) async {
    favProducts.remove(id);
    await saveFavProducts();
    print('removeFavourite $favProducts' );
  }

  Future<void> addFavourite(int id) async {
    if (!favProducts.contains(id)) {
      favProducts.add(id);
      await saveFavProducts();
      print('addFavourite $favProducts' );
    }
  }

  Future<void> init() async {
    await loadFavProducts();
  }
}
