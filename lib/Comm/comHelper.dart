import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

alerDialog(BuildContext context, String mgs){
  Toast.show(mgs,
      duration: Toast.lengthShort, gravity: Toast.bottom);
}

validdateEmail(String email){
  final emailReg = new RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailReg.hasMatch(email);
}