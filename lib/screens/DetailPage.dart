import 'dart:convert';

import 'package:app/DatabaseHandler/UserPreferences.dart';
import 'package:app/Model/CommentModel.dart';
import 'package:app/Model/DetailModel.dart';
import 'package:app/Model/ProductModel.dart';
import 'package:app/screens/Login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:screen_loader/screen_loader.dart';
import 'package:toast/toast.dart';

import '../Comm/constants.dart';

class DetailForm extends StatefulWidget {
  ProductModel cate;

  DetailForm({Key? key, required this.cate}) : super(key: key);

  @override
  State<DetailForm> createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> with ScreenLoader {
  String title = "";
  List<CommentModel> list = [];
  int page = 0;
  final ScrollController _controller = ScrollController();
  bool isLoading1 = true;
  bool canLoadingMore = true;
  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 20;
  List<DetailModel> detail = [];

  Future getDataByType() async {
    isLoading1 = true;
    int cate_id = int.tryParse('${widget.cate.id}')!;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final recipeRef =
        ref.child('comment').orderByChild('idRecipe').equalTo(cate_id);
    final snapshot = await recipeRef.get();
    if (snapshot.value != null) {
      print(snapshot.value);
      List<CommentModel> comments = [];
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> snapshotMap =
            snapshot.value as Map<dynamic, dynamic>;
        snapshotMap.entries.forEach((entry) {
          String content = entry.value['content'] as String;
          String username = entry.value['username'] as String;

          CommentModel commentModel = new CommentModel(content, username);
          comments.add(commentModel);
        });

        setState(() {
          list.addAll(comments);
          page++;
          canLoadingMore = comments.length >= _itemsPerPage;
          isLoading1 = false;
        });
      } else {
        List<dynamic> values = snapshot.value as List;
        values.forEach((entry) {
          if (entry != null) {
            String content = entry['content'] as String;
            String username = entry['username'] as String;

            CommentModel commentModel = new CommentModel(content, username);
            comments.add(commentModel);
          }
        });
        setState(() {
          list.addAll(comments);
          page++;
          canLoadingMore = comments.length >= _itemsPerPage;
          isLoading1 = false;
        });
      }
    } else {
      print('No data available.');
    }
  }

  Future getDetail() async {
    print('${widget.cate.id}');

    int cate_id = int.tryParse('${widget.cate.id}')!;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final recipeRef = ref.child('detail').orderByChild('id').equalTo(cate_id);
    final snapshot = await recipeRef.get();

    if (snapshot.value != null) {
      print(snapshot.value);
      List<DetailModel> details = [];
      if (snapshot.value is Map) {
        Map<dynamic, dynamic> snapshotMap =
            snapshot.value as Map<dynamic, dynamic>;
        snapshotMap.entries.forEach((entry) {
          int id = int.tryParse(entry.value['id'].toString()) ?? 0;
          String mota = entry.value['mota'] as String;
          String name = entry.value['name'] as String;
          String nguyenlieu = entry.value['nguyenlieu'] as String;

          DetailModel detailModel = new DetailModel(id, name, nguyenlieu, mota);
          details.add(detailModel);
        });

        setState(() {
          // Thêm dữ liệu mới vào danh sách
          detail.addAll(details);
        });
      } else {
        List<dynamic> values = snapshot.value as List;
        values.forEach((entry) {
          if (entry != null) {
            int id = int.tryParse(entry['id'].toString()) ?? 0;
            String mota = entry['mota'] as String;
            String name = entry['name'] as String;
            String nguyenlieu = entry['nguyenlieu'] as String;

            DetailModel detailModel =
                new DetailModel(id, name, nguyenlieu, mota);
            details.add(detailModel);
          }
        });
        setState(() {
          // Thêm dữ liệu mới vào danh sách
          detail.addAll(details);
        });
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
    // _controller.addListener(_onScroll);
    getDataByType();
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Product'),
        ),
        body: SingleChildScrollView(
          controller: _controller,
          child: SizedBox(
              child: Scrollbar(
            controller: _controller,
            thumbVisibility: true,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${detail[0].name}',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nguyên liệu',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${detail[0].nguyenlieu}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Các bước làm',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${detail[0].mota}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Bình luận: ",
                            style: TextStyle(fontSize: 25),
                          )),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              title: Text('user ${list[index].username}'),
                              subtitle: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${list[index].title}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                    Container(
                      child: TextField(
                        onChanged: (String value) {
                          setState(() {
                            title = value;
                          });
                        },
                        decoration: InputDecoration(hintText: "Viết bình luận"),
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: checkLogin,
                  child: Text('Đăng bình luận'),
                ),
              ],
            ),
          )),
        ));
  }

  checkLogin() async {
    final bool checkCredentials = await UserPreferences.checkCredentials();
    if (checkCredentials) {
      if (!containsLinkOrBadWords(title)) {
        setState(() {
          _insertData();
        });
      } else {
        Toast.show("Nôi dung không hợp lệ");
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginFrom()),
          (Route<dynamic> route) => false);
    }
  }

  bool containsLinkOrBadWords(String text) {
    RegExp linkRegex = new RegExp(
        r"(http(s)?:\/\/)?(www\.)?[a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    RegExp badWordsRegex =
        new RegExp(r"\b(shit|fuck|fu)\b", caseSensitive: false);

    return linkRegex.hasMatch(text) || badWordsRegex.hasMatch(text);
  }

  _insertData() async {
    int cate_id = int.tryParse('${widget.cate.id}')!;
    String uname = await UserPreferences.getUname();
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    ref.child('comment').push().set({
      'idRecipe': cate_id,
      'username': uname,
      'content': title,
    });
  }
}
