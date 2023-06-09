import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../Model/ProductModel.dart';

class DataManager {
  static final DataManager _singleton = DataManager._internal();

  factory DataManager() {
    return _singleton;
  }

  DataManager._internal();

  late List<ProductModel> favProducts;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/favProduct.txt');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return File('$path/favProduct.txt');
  }

  Future<void> saveFavProducts() async {
    try {
      final file = await _localFile;

      String l = jsonEncode(favProducts);

      // Write the file
      file.writeAsString('$l');
      // print("them thanh cong");
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadFavProducts() async {

    favProducts = <ProductModel>[];
    try {
      // print("bat dau load");
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();


      Iterable l = json.decode(contents);
      List<ProductModel> posts =
          List<ProductModel>.from(l.map((model) => ProductModel.fromJson(model)));
      favProducts.addAll(posts);
      // print("load thanh cong ${favProducts.length}");
    } catch (e) {
      print(e);
    }
  }

  bool checkFavourite(int id) {
    return favProducts.any((element) => element.id == id);
  }

  Future<void> removeFavourite(int id) async {
    favProducts.removeWhere((x) => x.id == id);
    await saveFavProducts();
    // print('removeFavourite $favProducts');
  }

  Future<void> addFavourite(ProductModel p) async {
    if (!checkFavourite(p.id)) {
      favProducts.add(p);
      await saveFavProducts();
      // print('addFavourite $favProducts');
    }
  }

  Future<void> init() async {
    await loadFavProducts();
  }
}
