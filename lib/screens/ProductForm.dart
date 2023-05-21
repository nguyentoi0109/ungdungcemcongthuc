import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:screen_loader/screen_loader.dart';

import '../Comm/constants.dart';
import '../Model/CategoryModel.dart';
import '../Model/ProductModel.dart';

class ProductForm extends StatefulWidget {
  final CategoryModel cate;

  const ProductForm({super.key, required this.cate});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> with ScreenLoader {
  List<ProductModel> list = [];
  int page = 1;
  final ScrollController _controller = ScrollController();
  bool isLoading1 = true;
  bool canLoadingMore = true;
  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 20;

  Future getDataByType() async {
    // print('loading page $page');
    print('${widget.cate.id}');
    int cate_id = int.tryParse('${widget.cate.id}')!;
    isLoading1 = true;

    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final recipeRef = ref.child('recipe').orderByChild('loai').equalTo(cate_id);
    final snapshot = await recipeRef.get();
    if (snapshot.value != null) {
      print(snapshot.value);
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> snapshotMap =
            snapshot.value as Map<dynamic, dynamic>;

        List<ProductModel> products = [];

        // Lặp qua từng entry của Map
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
          page++;
          canLoadingMore = products.length >= _itemsPerPage;
          isLoading1 = false;
        });
      } else {
        print('Not a map.');
      }
    } else {
      print('No data available.');
    }
  }

  Future<void> _refresh() async {
    canLoadingMore = true;
    list.clear();
    page = 0;
    await getDataByType();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    getDataByType();
  }

  void _onScroll() {
    if (!_controller.hasClients || isLoading1 || canLoadingMore == false) {
      return;
    }

    final thresholdReached =
        _controller.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      getDataByType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
      ),
      body: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          CupertinoSliverRefreshControl(onRefresh: _refresh),
          SliverPadding(
              padding: EdgeInsets.all(3),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: list.length, _buildColorItem))),
          SliverToBoxAdapter(
            child: canLoadingMore
                ? Container(
                    padding: EdgeInsets.only(bottom: 16),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorItem(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: SizedBox(
              height: 90.0,
              width: 90.0,
              child: Image.network(
                "${list[index].hinhanh}",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${list[index].tensp}",
                      style: TextStyle(fontSize: 20),
                      maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Text(
                    "${list[index].mota}",
                    style: TextStyle(fontSize: 15),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
