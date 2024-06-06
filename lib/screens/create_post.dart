import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:back4app_posts_app/screens/bottom_bar.dart';
import 'package:back4app_posts_app/screens/posts_screen.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController descriptionController = TextEditingController();
  ParseUser? currentUser;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    final user = await ParseUser.currentUser();
    currentUser = user;
  }

  XFile? pickedFile;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: pickedFile != null
                  ? Container(
                      width: double.maxFinite,
                      height: 250,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: kIsWeb
                          ? Image.network(pickedFile!.path)
                          : Image.file(
                              File(pickedFile!.path),
                              fit: BoxFit.cover,
                            ))
                  : Container(
                      width: double.maxFinite,
                      height: 250,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: Center(
                        child: Text('Click here to pick image from Gallery'),
                      ),
                    ),
              onTap: () async {
                XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  setState(() {
                    pickedFile = image;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                  hintText: "Your Thoughts",
                  prefixIcon: Icon(Icons.description_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
              maxLength: 200,
            ),
            SizedBox(height: 16),
            Container(
                height: 50,
                child: ElevatedButton(
                  child: Text(
                    'Upload file',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: isLoading || pickedFile == null
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          ParseFileBase? parseFile;

                          if (kIsWeb) {
                            //Flutter Web
                            parseFile = ParseWebFile(
                                await pickedFile!.readAsBytes(),
                                name:
                                    'shoesyellow.jpg'); //Name for file is required
                          } else {
                            //Flutter Mobile/Desktop
                            parseFile = ParseFile(File(pickedFile!.path));
                          }
                          await parseFile.save();

                          final posts = ParseObject('Posts')
                            ..set('file', parseFile)
                            ..set('description', descriptionController.text)
                            ..set('likes', 0)
                            ..set('comments', [])
                            ..set(
                                'userid',
                                ParseObject('_User')
                                  ..objectId = currentUser!.objectId);
                          // ..set('username', currentUser!.username);
                          await posts.save();

                          setState(() {
                            isLoading = false;
                            // pickedFile = null;
                          });

                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                              content: Text(
                                'Post Added Successfully',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.blue,
                            ));
                          // Handlelikes(, currentUser!.objectId!);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavigationMenu()));
                        },
                ))
          ],
        ),
      ),
    );
  }

  // Future<void> Handlelikes(String postId, String userId) async {
  //   final ParseObject postLike = ParseObject('PostLike')
  //     ..set<String>('post_id', postId)
  //     ..set<String>('user_id', userId)
  //     ..set<bool>('liked', false);

  //   final response = await postLike.save();
  //   if (!response.success) {
  //     print('Failed to like post: ${response.error!.message}');
  //     // Handle error
  //   }
  // }
}
