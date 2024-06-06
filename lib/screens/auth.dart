import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:back4app_posts_app/components/round_button.dart';
import 'package:back4app_posts_app/screens/login.dart';
import 'package:back4app_posts_app/screens/signup.dart';

import '../components/round_button.dart';
import 'login.dart';
import 'signup.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Authentication Screen",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Image.asset("assets/startup.jpg")),
                    RoundButton(
                      onpressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      text: "Login",
                      width: mq.width * 0.9,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RoundButton(
                        onpressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        text: "Singup",
                        width: mq.width * 0.9)
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
