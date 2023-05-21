import 'package:app/Model/ProductModel.dart';
import 'package:app/screens/DetailPage.dart';
import 'package:app/screens/ProductWidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> list = [];
  final scrollController = ScrollController();
  int page = 0;
  bool isLoadingMore = false;

  Future<void> getDataByType() async {
    final int pageSize = 20;
    final int startAt = (2 - 1) * pageSize;
    final int endAt = startAt + pageSize;
    print(52);
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final recipeRef = ref.child('recipe').orderByChild('id').startAt(startAt).endAt(endAt);
    final snapshot = await recipeRef.get();print(snapshot.value);

    if (snapshot.value != null) {
      print(snapshot.value);
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> snapshotMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<ProductModel> products = [];
        snapshotMap.entries.forEach((entry) {
          int id = int.tryParse(entry.key.toString()) ?? 0;
          String tensp = entry.value['tensp'] as String;
          String hinhanh = entry.value['hinhanh'] as String;
          String mota = entry.value['mota'] as String;
          int loai = int.tryParse(entry.value['loai'].toString()) ?? 0;

          // Tạo đối tượng ProductModel từ các thông tin chi tiết
          ProductModel product = ProductModel(id, tensp, hinhanh, mota, loai);
          print(product.toString());
          // Thêm sản phẩm vào danh sách
          products.add(product);
        });

        setState(() {
          // Thêm dữ liệu mới vào danh sách
          list.addAll(products);
        });
      } else {
        print('Not a map.');
      }
    } else {
      print('No data available.');
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
          Autocomplete<ProductModel>(
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
            displayStringForOption: (ProductModel p) => p.tensp,
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
                Iterable<ProductModel> list) {
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
