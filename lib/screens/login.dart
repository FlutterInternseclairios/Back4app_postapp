import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:back4app_posts_app/components/mytextfeild.dart';
import 'package:back4app_posts_app/components/round_button.dart';
import 'package:back4app_posts_app/json/users.dart';
import 'package:back4app_posts_app/screens/bottom_bar.dart';
import 'package:back4app_posts_app/screens/profile_screen.dart';
//import 'package:sqlite_profile_app/screens/profile_screen.dart';
import 'package:back4app_posts_app/screens/signup.dart';

import '../components/mytextfeild.dart';
import '../components/round_button.dart';
import 'bottom_bar.dart';
import 'signup.dart';
//import 'package:sqlite_profile_app/sqlite/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordvisibilty = true;
  final TextEditingController controllerusername = TextEditingController();
  final TextEditingController controllerpassword = TextEditingController();
  bool islogintrue = false;

  //final db = DatabaseHelper();

  // login() async {
  //   Users? userDetails = await db.getUser(username.text);
  //   var res = await db
  //       .authenticate(Users(userName: username.text, password: password.text));
  //   if (res == true) {
  //     if (!mounted) return;
  //     username.clear();
  //     password.clear();
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => ProfileScreen(
  //                   profile: userDetails,
  //                 )));
  //   } else {
  //     setState(() {
  //       islogintrue = true;

  //       Timer(Duration(seconds: 5), () {
  //         setState(() {
  //           islogintrue = false;
  //         });
  //       });
  //     });
  //   }
  // }

  void doUserLogin() async {
    final username = controllerusername.text.trim();
    final password = controllerpassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("User Successfully Login"),
        backgroundColor: Colors.purple.shade200,
        duration: Duration(seconds: 3),
        dismissDirection: DismissDirection.up,
      ));
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NavigationMenu()));
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(response.error!.message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.purple),
                  ),
                  Image.asset("assets/background.jpg"),
                  SizedBox(
                    height: 15,
                  ),
                  MyTextFeild(
                    controller: controllerusername,
                    hinttext: "Username",
                    prefixicon: Icon(Icons.account_circle),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextFeild(
                    controller: controllerpassword,
                    hinttext: "Password",
                    obsecuretext: passwordvisibilty,
                    prefixicon: Icon(Icons.lock),
                    suffixicon: IconButton(
                      onPressed: () {
                        passwordvisibilty = !passwordvisibilty;
                        setState(() {});
                      },
                      icon: passwordvisibilty
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RoundButton(
                    onpressed: () async {
                      // SharedPreferences sp =
                      //     await SharedPreferences.getInstance();
                      // sp.setString('username', controllerusername.text);

                      //login();
                      doUserLogin();
                    },
                    text: "Login",
                    width: double.maxFinite,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dont Have an Account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Text("Signup"))
                    ],
                  ),
                  islogintrue
                      ? Text(
                          "Username or Password is incorrect",
                          style: TextStyle(color: Colors.red.shade300),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
