import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back4app_posts_app/components/round_button.dart';
import 'package:back4app_posts_app/screens/posts_screen.dart';
import 'package:back4app_posts_app/screens/search_users.dart';
import 'package:back4app_posts_app/sqlite/database_helper.dart';
import '../json/users.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  final Users? profile;
  const ProfileScreen({super.key, this.profile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ParseUser? currentUser;
  Future<ParseUser?> getUser() async {
    currentUser = await ParseUser.currentUser() as ParseUser?;

    return currentUser;
  }
  //final db = DatabaseHelper();

  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  // late String _originalDateOfBirth;
  // late String _originalPhoneNumber;
  // late String _originalAddress;

  bool _detailsEdited = false;

  // @override
  // void initState() {
  //   super.initState();

  //   _dateOfBirthController =
  //       TextEditingController(text: widget.profile?.dateOfBirth);
  //   _phoneNumberController =
  //       TextEditingController(text: widget.profile?.phoneNumber.toString());
  //   _addressController = TextEditingController(text: widget.profile?.address);

  //   // _originalDateOfBirth = widget.profile?.dateOfBirth ?? "";
  //   // _originalPhoneNumber = widget.profile?.phoneNumber ?? "";
  //   // _originalAddress = widget.profile?.address ?? "";
  //   // _image = null;
  // }

  // @override
  // void dispose() {
  //   _dateOfBirthController.dispose();
  //   _phoneNumberController.dispose();
  //   _addressController.dispose();
  //   super.dispose();
  // }

  // Future<void> _updateProfile() async {
  //   await db.updateUserProfile(widget.profile!.userName,
  //       dateOfBirth: _dateOfBirthController!.text,
  //       phoneNumber: int.tryParse(_phoneNumberController!.text) ?? 0,
  //       address: _addressController!.text,
  //       imagePath: _image != null ? _image!.path : null);
  //   setState(() {
  //     _detailsEdited = false;
  //   });
  // }

  // Future<void> _revertChanges() async {
  //   setState(() {
  //     _dateOfBirthController.text = _originalDateOfBirth;
  //     _phoneNumberController.text = _originalPhoneNumber.toString();
  //     _addressController.text = _originalAddress;
  //     _detailsEdited = false;
  //   });
  // }

  // File? _image;

  // final picker = ImagePicker();

  // Future getImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //       _detailsEdited = true;
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();

    if (response.success) {
      print("User was successfully logout!");
      setState(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    } else {
      print(response.error!.message);
    }
  }

  XFile? pickedFile;
  List<ParseObject> results = <ParseObject>[];
  double selectedDistance = 3000;
  bool isLoading = false;
  bool _imageUploaded = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "Profile Screen",
            //       style: TextStyle(fontSize: 24),
            //     )
            //   ],
            // ),
            Expanded(
              child: FutureBuilder(
                  future: getUser(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: const CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError || snapshot.data == null) {
                          return const Center(
                            child: Text('Error loading user data'),
                          );
                        } else {
                          final allusers = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 35),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child:
                                        //_buildProfilePicture(currentUser!),
                                        pickedFile != null
                                            ? Stack(
                                                alignment: AlignmentDirectional
                                                    .bottomEnd,
                                                children: [
                                                    Container(
                                                        height: 130,
                                                        width: 130,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blue)),
                                                        child: kIsWeb
                                                            ? ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  pickedFile!
                                                                      .path,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            : ClipOval(
                                                                child:
                                                                    Image.file(
                                                                  File(
                                                                    pickedFile!
                                                                        .path,
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )),
                                                    const Icon(Icons.edit),
                                                  ])
                                            : Stack(
                                                alignment: AlignmentDirectional
                                                    .bottomEnd,
                                                children: [
                                                    Container(
                                                      height: 130,
                                                      width: 130,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.blue)),
                                                      child: FutureBuilder<
                                                          ParseFile?>(
                                                        future:
                                                            _fetchProfileImage(
                                                                snapshot.data!),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const CircularProgressIndicator();
                                                          } else if (snapshot
                                                                  .hasData &&
                                                              snapshot.data !=
                                                                  null) {
                                                            return ClipOval(
                                                              child:
                                                                  Image.network(
                                                                snapshot
                                                                    .data!.url!,
                                                                // scale: 0.8,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            );
                                                          } else {
                                                            return const Icon(
                                                                Icons.person,
                                                                size: 65,
                                                                color: Colors
                                                                    .black);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    const Icon(Icons.edit),
                                                  ]),
                                    onTap: () async {
                                      XFile? image =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                      );

                                      if (image != null) {
                                        setState(() {
                                          pickedFile = image;
                                          _imageUploaded = false;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Container(
                                    child: _imageUploaded || pickedFile == null
                                        ? const SizedBox.shrink()
                                        : ElevatedButton(
                                            child:
                                                const Text("Save Profile Pic"),
                                            onPressed: isLoading ||
                                                    pickedFile == null ||
                                                    _imageUploaded
                                                ? null
                                                : () async {
                                                    print("hello1");
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    ParseFileBase? parseFile;

                                                    if (kIsWeb) {
                                                      //Flutter Web

                                                      parseFile = ParseWebFile(
                                                          await pickedFile!
                                                              .readAsBytes(),
                                                          name:
                                                              'shoesyellow.jpg');
                                                    } else {
                                                      parseFile = ParseFile(
                                                          File(pickedFile!
                                                              .path));
                                                    }
                                                    await parseFile.save();

                                                    // final imagefile = ParseObject(
                                                    //     "images")
                                                    //   ..set(
                                                    //       "profileimage", parseFile)
                                                    //   ..set(
                                                    //       "username", currentUser);

                                                    updateuser(
                                                        allusers.objectId!,
                                                        parseFile);

                                                    // final responce =
                                                    //     //await imagefile.save();
                                                  },
                                          ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    snapshot.data!.username ?? "",
                                    style: const TextStyle(
                                        fontSize: 28, color: Colors.purple),
                                  ),
                                  Text(
                                    snapshot.data!.emailAddress ?? "",
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  RoundButton(
                                      width: double.maxFinite,
                                      onpressed: () async {
                                        doUserLogout();
                                      },
                                      text: "Logout"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.person, size: 30),
                                    subtitle:
                                        Text(snapshot.data!["fullName"] ?? ""),
                                    title: const Text("Full name"),
                                  ),
                                  ListTile(
                                    title: const Text("Date Of Birth"),
                                    leading:
                                        const Icon(Icons.date_range, size: 30),
                                    subtitle: Text(snapshot.data!["DOB"] ?? ""
                                        //_dateOfBirthController!.text
                                        ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.phone, size: 30),
                                    title: const Text("Phone number"),
                                    subtitle:
                                        Text(snapshot.data!["phoneNumber"] ?? ""
                                            //_phoneNumberController.text
                                            ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            _phoneNumberController.text =
                                                snapshot.data!['phoneNumber'];
                                            return AlertDialog(
                                              title: const Text(
                                                  "Update Phone Number"),
                                              content: TextField(
                                                controller:
                                                    _phoneNumberController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        "Enter new phone number"),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    final oldnumber =
                                                        _phoneNumberController
                                                            .text;

                                                    Navigator.of(context).pop();
                                                    await updatePhone(
                                                        allusers.objectId!,
                                                        oldnumber);
                                                    setState(() {});
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    leading:
                                        const Icon(Icons.location_on, size: 30),
                                    subtitle:
                                        Text(snapshot.data!["address"] ?? ""
                                            //_addressController.text
                                            ),
                                    title: const Text("Address"),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Update Address"),
                                              content: TextField(
                                                controller: _addressController,
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        "Update Your Address"),
                                                onChanged: (value) {
                                                  setState(() {
                                                    updateAdress(
                                                        allusers.objectId!,
                                                        value);
                                                  });
                                                },
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.person, size: 30),
                                    subtitle:
                                        Text(snapshot.data!["gender"] ?? ""),
                                    title: const Text("Gender"),
                                  ),
                                  _detailsEdited
                                      ? RoundButton(
                                          width: double.maxFinite,
                                          onpressed: () async {
                                            setState(() {});
                                          },
                                          text: "SAVE",
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          );
                        }
                    }
                  }),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        //_dateOfBirthController!.text =
        String value = DateFormat('yyyy-MM-dd').format(pickedDate);
        updateDob(currentUser!.objectId!, value);
        // _detailsEdited = true;
      });
    }
  }

  Future<ParseFile?> _fetchProfileImage(ParseUser user) async {
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('_User'))
          ..whereEqualTo('objectId', user.objectId)
          ..includeObject(['profile']);

    ParseResponse apiResponse = await queryBuilder.query();

    if (apiResponse.success &&
        apiResponse.results != null &&
        apiResponse.results!.isNotEmpty) {
      ParseObject userData = apiResponse.results!.first;
      return userData.get<ParseFile>('profile');
    }

    return null;
  }

  Future<void> updateuser(String id, var value) async {
    var images = ParseObject("_User")
      ..objectId = id
      ..set('profile', value);
    final responce = await images.save();

    if (responce.success) {
      print('Profile picture saved successfully');
      setState(() {
        isLoading = false;
        _imageUploaded = true;
        // pickedFile = null;
        // _detailsEdited = true; // This line marks that details have been edited
      });

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text(
            'Save file with success on Back4app',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ));
    } else {
      print('Failed to save profile picture: ${responce.error!.message}');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePhone(String id, newPhone) async {
    var editPhone = ParseObject("_User")..objectId = id;
    editPhone.set('phoneNumber', newPhone);
    await editPhone.save();
  }

  Future<void> updateDob(String id, var value) async {
    var editDob = ParseObject("_User")
      ..objectId = id
      ..set('DOB', value);
    await editDob.save();
  }

  Future<void> updateAdress(String id, var value) async {
    var editAddress = ParseObject("_User")
      ..objectId = id
      ..set('address', value);
    await editAddress.save();
    setState(() {});
  }
}
