import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ProductForm.dart';

class CategoryModel {
  int id;
  String name;
  String image;

  CategoryModel(this.id, this.name, this.image);

  CategoryModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        image = json['image'],
        id = int.parse(json['id']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'id': id,
      };
}

class HomeForm extends StatefulWidget {
  const HomeForm({Key? key}) : super(key: key);

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  List<CategoryModel> list = [];

  Future getData() async {
    var url = "http://192.168.1.32/banhang/getData.php";
    var res = await http.get(Uri.parse(url));
    // print(res.body);
    if (res.statusCode == 200) {
      Iterable l = json.decode(res.body);
      List<CategoryModel> posts = List<CategoryModel>.from(
          l.map((model) => CategoryModel.fromJson(model)));
      setState(() {
        list.addAll(posts);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(list.length, (index) {
          return Padding(
              padding: const EdgeInsets.all(1),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProductForm(cate: list[index])));
                    },
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              height: 150.0,
                              width: 160.0,
                              child: Image.network(
                                "${list[index].image}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "${list[index].name}",
                              style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }
}
