import 'package:app/Comm/comHelper.dart';
import 'package:app/Comm/genTextFromField.dart';
import 'package:app/screens/Signup.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../DatabaseHandler/DBHelper.dart';
import 'HomeForm.dart';

class LoginFrom extends StatefulWidget {
  @override
  State<LoginFrom> createState() => _LoginFromState();
}

class _LoginFromState extends State<LoginFrom> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  login() async {
    String uid = _conUserId.text;
    String password = _conPassword.text;

    if (uid.isEmpty) {
      alerDialog(context, "Please Enter User ID");
    } else if (password.isEmpty) {
      alerDialog(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(uid, password).then((UserData) {
        if (UserData != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => HomeForm()),
              (Route<dynamic> route) => false);
        }
      }).catchError((error) {
        alerDialog(context, "Error: Login Fail");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Login with Signup'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 40),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      height: 150,
                      width: 150,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Sample Code',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                          fontSize: 30),
                    ),
                    getTextFormField(
                        controller: _conUserId,
                        iconData: Icons.person,
                        hintName: 'User ID'),
                    SizedBox(
                      height: 10,
                    ),
                    getTextFormField(
                      controller: _conPassword,
                      iconData: Icons.lock,
                      hintName: 'Password',
                      isobscureText: true,
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: login,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Does not have account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignupFrom()));
                            },
                            child: Text('Signup'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
