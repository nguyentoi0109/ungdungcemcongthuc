import 'package:app/Comm/comHelper.dart';
import 'package:app/DatabaseHandler/DBHelper.dart';
import 'package:app/Model/UserModel.dart';
import 'package:app/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../Comm/genTextFromField.dart';

class SignupFrom extends StatefulWidget {
  @override
  State<SignupFrom> createState() => _SignupFromState();
}

class _SignupFromState extends State<SignupFrom> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  signUp() {
    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String password = _conPassword.text;
    String c_password = _conCPassword.text;

    if (_formKey.currentState!.validate()) {
      if (password != c_password) {
        alerDialog(context, 'Password Mismatch');
      } else {
        _formKey.currentState?.save();

        UserModel userModel = UserModel(uid, uname, email, password);
        // dbHelper.saveData(userModel).then((userData) {
        //   alerDialog(context, "Successfully Save");
        // }).catchError((error) {
        //   alerDialog(context, "Save: fail");
        // });
        dbHelper.saveData(userModel);
        alerDialog(context, "Successfully Save");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginFrom()),
                (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(title: Text('Login with signup')),
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
                    'SignUp',
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
                      controller: _conUserName,
                      iconData: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'User Name'),
                  SizedBox(
                    height: 10,
                  ),
                  getTextFormField(
                      controller: _conEmail,
                      iconData: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  SizedBox(
                    height: 10,
                  ),
                  getTextFormField(
                    controller: _conPassword,
                    iconData: Icons.lock,
                    hintName: 'Password',
                    isobscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  getTextFormField(
                    controller: _conCPassword,
                    iconData: Icons.lock,
                    hintName: 'Confirm Password',
                    isobscureText: true,
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: signUp,
                      child: Text(
                        'Sign Up',
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
                        Text('Does have account ?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginFrom()),
                                (Route<dynamic> route) => false);
                          },
                          child: Text('Sign In'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
