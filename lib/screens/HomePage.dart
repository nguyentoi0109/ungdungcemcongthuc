import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
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
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('home').get();
    if (snapshot.value != null) {
      print(snapshot.value);

      List<CategoryModel> categories = [];
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> snapshotMap =
            snapshot.value as Map<dynamic, dynamic>;
        snapshotMap.entries.forEach((entry) {
          int id = int.tryParse(entry.value['id'].toString()) ?? 0;
          String name = entry.value['name'] as String;
          String image = entry.value['image'] as String;

          CategoryModel categoryModel = new CategoryModel(id, name, image);
          categories.add(categoryModel);
        });
      } else {
        List<dynamic> values = snapshot.value as List;
        values.forEach((entry) {
          if (entry != null) {
            int id = int.tryParse(entry['id'].toString()) ?? 0;
            String name = entry['name'] as String;
            String image = entry['image'] as String;

            CategoryModel categoryModel = new CategoryModel(id, name, image);
            categories.add(categoryModel);
          }
        });
      }
      setState(() {
        // Thêm dữ liệu mới vào danh sách
        list.addAll(categories);
      });
    } else {
      print('No data available.');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(list.length, (index) {
          return Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
                              list[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            list[index].name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }
}
