import 'dart:convert';

import 'package:app/DatabaseHandler/UserPreferences.dart';
import 'package:app/Model/CommentModel.dart';
import 'package:app/Model/DetailModel.dart';
import 'package:app/Model/Product.dart';
import 'package:app/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:screen_loader/screen_loader.dart';
import 'package:toast/toast.dart';

import '../Comm/constants.dart';
import '../Model/ProductModel.dart';

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
    var url = serverUrl + "/banhang/getAllComment.php";
    // var res = await http.get(Uri.parse(url));
    var res = await this.performFuture(() => http.get(Uri.parse(url)));
    // print(res.body);
    if (res.statusCode == 200) {
      Iterable l = json.decode(res.body);
      List<CommentModel> posts = List<CommentModel>.from(
          l.map((model) => CommentModel.fromJson(model)));
      setState(() {
        list.addAll(posts);
        page++;
        canLoadingMore = posts.length >= _itemsPerPage;
        isLoading1 = false;
      });
    }
  }

  Future getDetail() async {
    var url = serverUrl + "/banhang/getAllDetail.php?id=${widget.cate.id}";
    // var res = await http.get(Uri.parse(url));
    var res = await this.performFuture(() => http.get(Uri.parse(url)));
    // print(res.body);
    if (res.statusCode == 200) {
      Iterable l = json.decode(res.body);
      List<DetailModel> posts =
          List<DetailModel>.from(l.map((model) => DetailModel.fromJson(model)));
      setState(() {
        detail.addAll(posts);
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
          child: SizedBox(
              child: Scrollbar(
            thumbVisibility: true,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(top: 10),
                  child: const Align(
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
                // Container(
                //   margin: EdgeInsets.only(top: 10),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                //     child: Container(
                //       height: 150.0,
                //       width: 300.0,
                //       child: Image.asset(
                //         'assets/images/img.png',
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 10),
                  child: const Align(
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
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${detail[0].nguyenlieu}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(top: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Các bước làm',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(5),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       'Bước 1:',
                //       style:
                //           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Align(
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
                      child: const Align(
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
                              title: Text('user${list[index].username}'),
                              subtitle: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${list[index].title}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                    TextField(
                      onChanged: (String value) {
                        setState(() {
                          title = value;
                        });
                      },
                      decoration:
                          const InputDecoration(hintText: "Viết bình luận"),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: checkLogin,
                  child: const Text('Đăng bình luận'),
                ),
              ],
            ),
          )),
        ));
  }

  checkLogin() async {
    final bool checkCredentials = await UserPreferences.checkCredentials();
    if (checkCredentials) {
      //   if (!containsLinkOrBadWords()) {
      setState(() {
        _insertData();
      });
      // } else {
      //   Toast.show("Nôi dung không hợp lệ");
      // }
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

  // bool containsLink() {
  //   RegExp linkRegex = new RegExp(
  //       r"(http(s)?:\/\/)?(www\.)?[a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
  //   return linkRegex.hasMatch(title);
  // }

  // bool containsBadWords() {
  //   RegExp badWordsRegex =
  //       new RegExp(r"\b(shit|fuck|fu)\b", caseSensitive: false);
  //   return badWordsRegex.hasMatch(title);
  // }

  _insertData() async {
    String uname = await UserPreferences.getUname();
    String url = "$serverUrl/banhang/insertData.php";
    await http.post(Uri.parse(url), body: {"title": title, "u_name": uname});
  }
}
