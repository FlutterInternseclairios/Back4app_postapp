import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:back4app_posts_app/screens/profile_screen.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> hasUserLogged() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

    if (parseResponse?.success == null || !parseResponse!.success) {
      //Invalid session. Logout
      await currentUser.logout();
      return false;
    } else {
      return true;
    }
  }
  //final db = DatabaseHelper();

  // @override
  // void initState() {
  //   islogin();
  //   super.initState();
  // }

  // void islogin() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   String? username = sp.getString('username') ?? "";
  //   // print('HI');
  //   // print(username);

  //   if (username.isEmpty || username.isNotEmpty) {
  //     // print("heelo 1");
  //     Users? userDetails = await db.getUser(username);
  //     if (userDetails != null) {
  //       print("hello");
  //       Timer(Duration(seconds: 3), () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => ProfileScreen(profile: userDetails)),
  //         );
  //       });
  //     } else {
  //       Timer(Duration(seconds: 3), () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => LoginScreen()),
  //         );
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Expanded(
          child: FutureBuilder<bool>(
              future: hasUserLogged(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Column(
                        children: [
                          Image(
                              width: double.maxFinite,
                              fit: BoxFit.fitHeight,
                              image: AssetImage("assets/background.jpg")),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Profile App",
                            style: TextStyle(
                                fontSize: 28, color: Colors.blue.shade500),
                          )
                        ],
                      ),
                    );
                  default:
                    if (snapshot.hasData && snapshot.data!) {
                      return ProfileScreen();
                    } else {
                      return LoginScreen();
                    }
                }
              }),
        )

        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image(
        //           width: double.maxFinite,
        //           fit: BoxFit.fitHeight,
        //           image: AssetImage("assets/background.jpg")),
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Text(
        //         "Profile App",
        //         style: TextStyle(fontSize: 28, color: Colors.blue.shade500),
        //       )
        //     ],
        //   ),
        );
  }
}
