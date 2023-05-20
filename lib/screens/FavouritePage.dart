import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Comm/constants.dart';
import '../DatabaseHandler/DataManager.dart';
import '../Model/Product.dart';
import 'DetailPage.dart';
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
  final scrollController = ScrollController();
  int page = 0;
  bool isLoadingMore = false;


  @override
  void initState() {
    super.initState();
    favProduct = DataManager().favProducts;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  // controller: scrollController,
                  itemCount: favProduct.length,
                  itemBuilder: (context, index) {
                      var product = favProduct[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailForm(
                                        cate: favProduct[index],
                                      )));
                        },
                        child: ProductWidget(product: product),
                      );
                      // ProductWidget(product: product);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
