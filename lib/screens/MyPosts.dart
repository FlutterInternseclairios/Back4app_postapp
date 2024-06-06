import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:back4app_posts_app/screens/bottom_bar.dart';
import 'package:back4app_posts_app/screens/edit_posts.dart';
import 'package:back4app_posts_app/screens/posts_screen.dart';

import 'edit_posts.dart';

class MyPosts extends StatefulWidget {
  final String? userImageUrl;

  const MyPosts({super.key, this.userImageUrl});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  ParseUser? currentUser;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final user = await ParseUser.currentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   leading: IconButton(
      //       onPressed: () {
      //         setState(() {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => PostScreen()));
      //         });
      //       },
      //       icon: Icon(CupertinoIcons.back)),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "My Posts",
                    style: TextStyle(fontSize: 24),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<List<ParseObject>>(
                future: currentUser != null ? getuserposts() : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No Posts"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data![index];
                        final description = post.get<String>('description');
                        final imageUrl = post.get<ParseFile>('file')?.url;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text("$description" ??
                                                'No Description'),
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'Edit') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditScreen(
                                                    description: description,
                                                    imageUrl: imageUrl,
                                                    objectId: post.objectId,
                                                  ),
                                                ),
                                              );
                                            } else if (value == 'Delete') {
                                              // Show delete confirmation dialog
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Are you sure?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Dismiss the dialog
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        // Delete the post
                                                        deletepost(
                                                            post.objectId!);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return {'Edit', 'Delete'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: Text(choice),
                                              );
                                            }).toList();
                                          },
                                          icon: Icon(Icons.more_vert_outlined),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: Colors.black,
                                    ),
                                    FutureBuilder<ParseFile?>(
                                      future: _fetchProfileImage(post),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Error: ${snapshot.error}");
                                        } else if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          return Container(
                                            width: double.infinity,
                                            height: 250,
                                            child: Image.network(
                                              snapshot.data!.url!,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        } else {
                                          return Text("No Image");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ParseObject>> getuserposts() async {
    final querypost = QueryBuilder<ParseObject>(ParseObject('Posts'))
      ..whereEqualTo('userid', currentUser);

    final apiResponse = await querypost.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<ParseFile?> _fetchProfileImage(ParseObject post) async {
    return post.get<ParseFile>('file');
  }

  Future<void> deletepost(String id) async {
    var todo = ParseObject('Posts')..objectId = id;
    await todo.delete();
    setState(() {});
  }
}
