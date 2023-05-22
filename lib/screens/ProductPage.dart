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
    final String startAt = ((page) * pageSize).toString();
    final String endAt = ((page) * pageSize + pageSize).toString();

    print(startAt);
    print(endAt);
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final recipeRef =
        ref.child('recipe').orderByKey().startAt(startAt).endAt(endAt);
    final snapshot = await recipeRef.get();

    if (snapshot.value != null) {
      print(snapshot.value);
      List<ProductModel> products = [];
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> snapshotMap =
            snapshot.value as Map<dynamic, dynamic>;
        snapshotMap.entries.forEach((entry) {
          int id = int.tryParse(entry.value['id'].toString()) ?? 0;
          String tensp = entry.value['tensp'] as String;
          String hinhanh = entry.value['hinhanh'] as String;
          String mota = entry.value['mota'] as String;
          int loai = int.tryParse(entry.value['loai'].toString()) ?? 0;

          // Tạo đối tượng ProductModel từ các thông tin chi tiết
          ProductModel product = ProductModel(id, tensp, hinhanh, mota, loai);
          // Thêm sản phẩm vào danh sách
          products.add(product);
        });

        setState(() {
          // Thêm dữ liệu mới vào danh sách
          list.addAll(products);
        });
      } else {
        List<dynamic> values = snapshot.value as List;
        values.forEach((entry) {
          if (entry != null) {
            int id = int.tryParse(entry['id'].toString()) ?? 0;
            String tensp = entry['tensp'] as String;
            String hinhanh = entry['hinhanh'] as String;
            String mota = entry['mota'] as String;
            int loai = int.tryParse(entry['loai'].toString()) ?? 0;

            // Tạo đối tượng ProductModel từ các thông tin chi tiết
            ProductModel product = ProductModel(id, tensp, hinhanh, mota, loai);
            // Thêm sản phẩm vào danh sách
            products.add(product);
          }
        });
        setState(() {
          // Thêm dữ liệu mới vào danh sách
          list.addAll(products);
        });
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
            optionsBuilder: (TextEditingValue textValue) async {
              if (textValue.text.isEmpty) {
                return List.empty();
              }
              String keyword = 'bánh tráng';
              String encodedKeyword = '';
              for (int i = 0; i < keyword.length; i++) {
                String char = keyword[i];
                if (char == ' ') {
                  encodedKeyword += '20'; // Mã hóa ký tự space
                } else if (char == 'á') {
                  encodedKeyword += '00E1'; // Mã hóa ký tự á
                } else if (char == 'ã') {
                  encodedKeyword += '00E3'; // Mã hóa ký tự ã
                } else {
                  encodedKeyword += char.codeUnitAt(0).toRadixString(16); // Mã hóa các ký tự khác
                }
              }
              String startValue = encodedKeyword;
              String endValue = encodedKeyword + '\uf8ff';
              DatabaseReference ref = FirebaseDatabase.instance.ref();
              final recipeRef = ref.child('recipe').orderByChild('tensp').startAt(startValue).endAt(endValue);
              final snapshot = await recipeRef.get();

              if (snapshot.value != null) {
                print(snapshot.value);
                List<ProductModel> products = [];
                if (snapshot.value is Map) {
                  Map<dynamic, dynamic> snapshotMap =
                      snapshot.value as Map<dynamic, dynamic>;
                  snapshotMap.entries.forEach((entry) {
                    int id = int.tryParse(entry.value['id'].toString()) ?? 0;
                    String tensp = entry.value['tensp'] as String;
                    String hinhanh = entry.value['hinhanh'] as String;
                    String mota = entry.value['mota'] as String;
                    int loai =
                        int.tryParse(entry.value['loai'].toString()) ?? 0;

                    // Tạo đối tượng ProductModel từ các thông tin chi tiết
                    ProductModel product =
                        ProductModel(id, tensp, hinhanh, mota, loai);
                    // Thêm sản phẩm vào danh sách
                    products.add(product);
                  });

                  return products;
                } else {
                  List<dynamic> values = snapshot.value as List;
                  values.forEach((entry) {
                    if (entry != null) {
                      int id = int.tryParse(entry['id'].toString()) ?? 0;
                      String tensp = entry['tensp'] as String;
                      String hinhanh = entry['hinhanh'] as String;
                      String mota = entry['mota'] as String;
                      int loai = int.tryParse(entry['loai'].toString()) ?? 0;

                      // Tạo đối tượng ProductModel từ các thông tin chi tiết
                      ProductModel product =
                          ProductModel(id, tensp, hinhanh, mota, loai);
                      // Thêm sản phẩm vào danh sách
                      products.add(product);
                    }
                  });
                  return products;
                }
              } else {
                print('No data available.');
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
