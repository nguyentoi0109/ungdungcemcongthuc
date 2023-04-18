import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:screen_loader/screen_loader.dart';

import '../Comm/constants.dart';
import '../Model/CategoryModel.dart';
import 'ProductForm.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ScreenLoader {
  List<CategoryModel> list = [];

  Future getData() async {
    var url = serverUrl + "/banhang/getData.php";
    // var res = await this.performFuture(() => http.get(Uri.parse(url)));
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
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return loadableWidget(
      child: Scaffold(
        body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(list.length, (index) {
            return Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ProductForm(cate: list[index])));
                      },
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 150.0,
                                width: 150.0,
                                child: Image.network(
                                  "${list[index].image}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "${list[index].name}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
