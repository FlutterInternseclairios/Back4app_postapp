import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:back4app_posts_app/screens/chat_screen.dart';

class UserProfile extends StatefulWidget {
  String username,
      emailAddress,
      fullname,
      dob,
      address,
      phonenumber,
      gender,
      url,
      userObjectId;

  UserProfile(
      {super.key,
      required this.username,
      required this.emailAddress,
      required this.fullname,
      required this.dob,
      required this.address,
      required this.phonenumber,
      required this.gender,
      required this.url,
      required this.userObjectId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ParseUser? currentUser;
  Future<ParseUser?> getUser() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;

    return currentUser;
  }

  // final loginuser = ParseUser.currentUser();
  // Future<List<ParseObject>> doUserQuery() async {
  //   QueryBuilder<ParseUser> queryUsers =
  //       QueryBuilder<ParseUser>(ParseUser.forQuery())
  //         ..orderByDescending('createdAt');
  //   final ParseResponse apiResponse = await queryUsers.query();

  //   if (apiResponse.success && apiResponse.results != null) {
  //     return apiResponse.results as List<ParseObject>;
  //   } else {
  //     return [];
  //   }
  // }

  Future<bool> _checkImageLoad() async {
    try {
      final response = await http.head(Uri.parse(widget.url.toString()));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: getUser(),
                    builder: (context, snapshot) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                FutureBuilder<bool>(
                                  future: _checkImageLoad(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        width: 150,
                                        height: 150,
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError ||
                                        !snapshot.data!) {
                                      return Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.blue),
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 65,
                                          color: Colors.black,
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.blue),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  widget.url.toString()),
                                              scale: 0.7),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.username,
                                  style: const TextStyle(
                                      fontSize: 28, color: Colors.purple),
                                ),
                                Text(
                                  widget.emailAddress,
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person, size: 30),
                                  subtitle: Text(widget.fullname),
                                  title: Text("Full name"),
                                ),
                                ListTile(
                                  title: Text("Date Of Birth"),
                                  leading:
                                      const Icon(Icons.date_range, size: 30),
                                  subtitle: Text(widget.dob
                                      //_dateOfBirthController!.text
                                      ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.phone, size: 30),
                                  title: const Text("Phone number"),
                                  subtitle: Text(widget.phonenumber
                                      //_phoneNumberController.text
                                      ),
                                ),
                                ListTile(
                                  leading:
                                      const Icon(Icons.location_on, size: 30),
                                  subtitle: Text(widget.address),
                                  title: const Text("Address"),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person, size: 30),
                                  subtitle: Text(widget.gender),
                                  title: const Text("Gender"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FloatingActionButton(
                                        onPressed: () {
                                          print(currentUser!.username);
                                          print(widget.username);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                        currentuser:
                                                            currentUser!,
                                                        otherUser: ParseUser(
                                                            widget.username,
                                                            '',
                                                            ''),
                                                        otheruserobjectid:
                                                            widget.userObjectId,
                                                      )));
                                        },
                                        child: Icon(Icons.chat),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }))
          ],
        ));
  }
}
