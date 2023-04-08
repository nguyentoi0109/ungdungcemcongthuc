import 'dart:convert';

import 'package:app/screens/ProductWidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Comm/constants.dart';
import '../Model/Product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> list = [];
  List<Product> _foundProduct = [];
  final scrollController = ScrollController();
  int page = 1;
  bool isLoadingMore = false;

  Future<void> getDataByType() async {
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
    _foundProduct = list;
    scrollController.addListener(_scrollLitener);
    getDataByType();
  }

  void _runFilter(String enterKey) {
    List<Product> result = [];
    if (enterKey.isEmpty) {
      result = _foundProduct;
    } else {
      result = list
          .where((product) =>
              product.tensp.toLowerCase().contains(enterKey.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundProduct = result;
    });
  }

  Future<void> _scrollLitener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await getDataByType();
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: isLoadingMore
                      ? _foundProduct.length + 1
                      : _foundProduct.length,
                  itemBuilder: (context, index) {
                    if (index < _foundProduct.length) {
                      var product = _foundProduct[index];
                      return ProductWidget(product: product);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
