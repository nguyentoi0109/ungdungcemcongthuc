import 'package:app/Comm/comHelper.dart';
import 'package:flutter/material.dart';

class getTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  IconData iconData;
  bool isobscureText;
  TextInputType inputType;

  getTextFormField(
      {required this.controller,
      required this.hintName,
      required this.iconData,
      this.isobscureText = false,this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: isobscureText,
        keyboardType: inputType,
        validator: (value){
          if(value == null || value.isEmpty){
            return 'Please enter $hintName';
          }
          if(hintName == "Email" && !validdateEmail(value)){
            return 'Please Enter Valid Email';
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: Icon(iconData),
          hintText: hintName,
          label: Text(hintName) ,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
}
