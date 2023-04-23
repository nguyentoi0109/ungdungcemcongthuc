import 'package:app/DatabaseHandler/UserPreferences.dart';
import 'package:app/screens/Login.dart';
import 'package:flutter/material.dart';

import 'FavouritePage.dart';
import 'HomePage.dart';
import 'ProductPage.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({Key? key}) : super(key: key);

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  int _selectedIndex = 0;
  var _pageController = PageController();
  List<Widget> pages = [HomePage(), ProductPage(), FavouitePage()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          FutureBuilder<bool>(
            future: islogged(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                // Nếu có tài khoản đăng nhập
                return IconButton(
                  onPressed: () async {
                    final prefs = await UserPreferences.removeCredentials();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomeForm()),
                        (Route<dynamic> route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Đã đăng xuất!'),
                    ));
                  },
                  icon: Icon(Icons.logout),
                );
              } else {
                // Nếu không có tài khoản đăng nhập
                return IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginFrom()),
                        (Route<dynamic> route) => false);
                    // Chuyển đến màn hình đăng nhập
                  },
                  icon: Icon(Icons.login),
                );
              }
            },
          ),
        ],
      ),
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.backup_table),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp),
            label: 'Favourite',
          ),
        ],
        onTap: (int index) {
          setState(() {
            this._selectedIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  Future<bool> islogged() async {
    bool isLog = await UserPreferences.checkCredentials();
    if (isLog) {
      return true;
    }
    return false;
  }
}
