import 'dart:convert';

import 'package:app/screens/DetailPage.dart';
import 'package:app/screens/HomeForm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Comm/constants.dart';
import 'HomePage.dart';

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

class _ProductFormState extends State<ProductForm> {
  List<ProductModel> list = [];

  Future getDataByType() async {
    var url = serverUrl + "/banhang/getDataType.php";
    var res = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "loai": widget.cate.id.toString(),
    });
    // print(res.body);
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
            // return ListTile(
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (_) => DetailForm(id: list[index].id)));
            //     },
                title: Container(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 3),
                            child: Center(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  height: 100.0,
                                  width: 100.0,
                                  child: Image.network(
                                    "${list[index].hinhanh}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${list[index].tensp}",
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "${list[index].mota}",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
