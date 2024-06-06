import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextFeild extends StatelessWidget {
  final TextEditingController controller;
  final bool obsecuretext;
  final TextInputType? inputType;
  final Widget? prefixicon;
  final String hinttext;
  final Widget? suffixicon;
  const MyTextFeild(
      {super.key,
      required this.controller,
      this.inputType,
      this.obsecuretext = false,
      this.prefixicon,
      this.suffixicon,
      required this.hinttext});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obsecuretext,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.purple.shade100,
          prefixIcon: prefixicon,
          suffixIcon: suffixicon,
          hintText: hinttext,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.purple.shade200,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Colors.purple.shade200,
              ))),
    );
  }
}
