import 'dart:convert';

import 'package:app/screens/DetailPage.dart';
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
  final scrollController = ScrollController();
  int page = 0;
  bool isLoadingMore = false;

  Future<void> getDataByType() async {
    var url = serverUrl + "/banhang/getAllData.php?page=$page";
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
    scrollController.addListener(_scrollLitener);
    getDataByType();
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
      body: Column(
        children: [
          Autocomplete<Product>(
            optionsBuilder: (TextEditingValue textValue) {
              if (textValue.text.isEmpty) {
                return List.empty();
              }
              return list
                  .where((product) => product.tensp
                      .toLowerCase()
                      .contains(textValue.text.toLowerCase()))
                  .toList();
            },
            displayStringForOption: (Product p) => p.tensp,
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) =>
                    Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            optionsViewBuilder: (BuildContext context, Function onSelected,
                Iterable<Product> list) {
              return Material(
                child: Expanded(
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: isLoadingMore ? list.length + 1 : list.length,
                      itemBuilder: (context, index) {
                        if (index < list.length) {
                          var product = list.elementAt(index);
                          return InkWell(
                            child: ProductWidget(product: product),
                          );
                          // ProductWidget(product: product);
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: isLoadingMore ? list.length + 1 : list.length,
                itemBuilder: (context, index) {
                  if (index < list.length) {
                    var product = list[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailForm(
                                      cate: list[index],
                                    )));
                      },
                      child: ProductWidget(product: product),
                    );
                    // ProductWidget(product: product);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
