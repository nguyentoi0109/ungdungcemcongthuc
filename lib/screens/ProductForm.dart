import 'dart:convert';

import 'package:app/screens/HomeForm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductModel {
  int id;
  String tensp;
  int giasp;
  String hinhanh;
  String mota;
  int loai;

  ProductModel(
      this.id, this.tensp, this.giasp, this.hinhanh, this.mota, this.loai);

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        tensp = json['tensp'],
        giasp = int.parse(json['giasp']),
        hinhanh = json['hinhanh'],
        mota = json['mota'],
        loai = int.parse(json['loai']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'tensp': tensp,
        'giasp': giasp,
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

class _ProductFormState extends State<ProductForm> {
  List<ProductModel> list = [];

  Future getDataByType() async {
    var url = "http://192.168.1.32/banhang/getDataType.php";
    var res = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "loai": widget.cate.id.toString(),
    });
    print(res.body);
    if (res.statusCode == 200) {
      Iterable l = json.decode(res.body);
      List<ProductModel> posts = List<ProductModel>.from(
          l.map((model) => ProductModel.fromJson(model)));
      setState(() {
        list.addAll(posts);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDataByType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(5.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          child: Image(
                            image: NetworkImage("${list[index].hinhanh}"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            child: Align(

                                alignment: Alignment.centerLeft,
                                child: Text("${list[index].tensp}")),
                          ),
                          Container(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("${list[index].giasp}")),
                          ),
                          Text(
                            "${list[index].mota}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                      )
                    ]),
              ),
            );
          }),
    );
  }
}
