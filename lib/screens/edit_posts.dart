import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:back4app_posts_app/screens/MyPosts.dart';
import 'package:back4app_posts_app/screens/bottom_bar.dart';

import 'bottom_bar.dart';

class EditScreen extends StatefulWidget {
  final String? description;
  final String? imageUrl;
  final String? objectId;

  const EditScreen({Key? key, this.description, this.imageUrl, this.objectId})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController descriptionController = TextEditingController();
  XFile? pickedFile;
  bool isLoading = false;
  bool _imageUploaded = false;

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Description',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  pickedFile != null
                      ? Container(
                          height: 250,
                          width: double.maxFinite,
                          child: Image.file(
                            File(pickedFile!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.imageUrl != null
                          ? Container(
                              height: 250,
                              width: double.maxFinite,
                              child: Image.network(
                                widget.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text('No Image'),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      _pickImage();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _imageUploaded ||
                        descriptionController.text != widget.description
                    ? () {
                        updatePost(
                          widget.objectId!,
                        );
                      }
                    : null,
                child: Text('Save Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        this.pickedFile = pickedFile;
        _imageUploaded = true;
      });
    }
  }

  Future<void> updatePost(
    String id,
  ) async {
    setState(() {
      isLoading = true;
    });

    var updatedPost = ParseObject('Posts')..objectId = id;
    if (descriptionController.text != widget.description) {
      updatedPost.set('description', descriptionController.text);
    }

    if (_imageUploaded) {
      ParseFileBase? parseFile;

      if (kIsWeb) {
        parseFile = ParseWebFile(await pickedFile!.readAsBytes(),
            name: 'shoesyellow.jpg');
      } else {
        parseFile = ParseFile(File(pickedFile!.path));
      }
      final response = await parseFile.save();

      if (response.success) {
        updatedPost.set('file', parseFile);
      } else {
        print('Failed to save image: ${response.error!.message}');
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    final response = await updatedPost.save();

    if (response.success) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            'Post Edited Successfully',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ));
      setState(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavigationMenu()),
            (route) => false);
      });
    } else {
      print('Failed to save post: ${response.error!.message}');
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(
            'Failed to edit post: ${response.error!.message}',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ));
    }

    setState(() {
      isLoading = false;
    });
  }
}
