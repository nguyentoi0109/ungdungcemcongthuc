import 'dart:convert';

import 'package:app/DatabaseHandler/DataManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Comm/constants.dart';
import '../Model/Product.dart';
import 'ProductWidget.dart';

class FavouitePage extends StatefulWidget {
  FavouitePage({
    Key? key,
  }) : super(key: key);

  @override
  State<FavouitePage> createState() => _FavouitePageState();
}

class _FavouitePageState extends State<FavouitePage> {
  List<Product> favProduct = [];
  List<Product> list = [];

  Future getAllData() async {
    var url = serverUrl + "/banhang/getAllData.php";
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      Iterable l = json.decode(res.body);
      List<Product> posts =
          List<Product>.from(l.map((model) => Product.fromJson(model)));
      setState(() {
        list.addAll(posts);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  void getFavProduct() {
    for(int i = 0; i< list.length; i++) {
        if(DataManager().checkFavourite(list[i].id)){
          favProduct.add(list[i]);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // TextField(
            //   onChanged: (value) => _runFilter(value),
            //   decoration: InputDecoration(
            //       labelText: 'Search', suffixIcon: Icon(Icons.search)),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            Expanded(
              child: ListView.builder(
                  itemCount: favProduct.length,
                  itemBuilder: (context, index) {
                    var product = favProduct[index];
                    return ProductWidget(product: product);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
