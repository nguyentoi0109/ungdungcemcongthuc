import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:screen_loader/screen_loader.dart';

import '../Comm/constants.dart';
import '../Model/CategoryModel.dart';

class ProductModel {
  int id;
  String tensp;
  String hinhanh;
  String mota;
  int loai;

  ProductModel(this.id, this.tensp, this.hinhanh, this.mota, this.loai);

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        tensp = json['tensp'],
        hinhanh = json['hinhanh'],
        mota = json['mota'],
        loai = int.parse(json['loai']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'tensp': tensp,
        'hinhanh': hinhanh,
        'mota': mota,
        'loai': loai,
      };
}

class ProductForm extends StatefulWidget {
  final CategoryModel cate;

  const ProductForm({super.key, required this.cate});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> with ScreenLoader {
  List<ProductModel> list = [];
  int page = 0;
  final ScrollController _controller = ScrollController();
  bool isLoading1 = true;
  bool canLoadingMore = true;
  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 20;

  Future getDataByType() async {
    print('loading page $page');
    isLoading1 = true;
    var url = serverUrl +
        "/banhang/getDataType.php?loai=${widget.cate.id}&page=$page";
    // var res = await http.get(Uri.parse(url));
    var res = await this.performFuture(() => http.get(Uri.parse(url)));
    // print(res.body);
    if (res.statusCode == 200) {
      Iterable l = json.decode(res.body);
      List<ProductModel> posts = List<ProductModel>.from(
          l.map((model) => ProductModel.fromJson(model)));
      setState(() {
        list.addAll(posts);
        page++;
        canLoadingMore = posts.length >= _itemsPerPage;
        isLoading1 = false;
      });
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
