import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:back4app_posts_app/screens/user_profile.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({Key? key});

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  final TextEditingController searchingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Users"),
        centerTitle: true,
        backgroundColor: Colors.purple.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) => setState(() {}),
              controller: searchingController,
              decoration: InputDecoration(
                hintText: "Search Users",
                label: Text("Users"),
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "All Users",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: FutureBuilder<List<ParseObject>>(
                future: doUserQuery(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error.toString()}"),
                        );
                      } else {
                        if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Text("None user Found"),
                          );
                        }

                        // Filter users based on search criteria
                        final filteredUsers = snapshot.data!.where((user) {
                          final username = user['username'] as String;
                          final dob = user['DOB'] as String;
                          return username.toLowerCase().contains(
                                  searchingController.text.toLowerCase()) ||
                              dob.toLowerCase().contains(
                                  searchingController.text.toLowerCase());
                        }).toList();

                        return ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index] as ParseUser;
                            final email = user.emailAddress ?? "";
                            final dob = user["DOB"] ?? "";

                            return FutureBuilder<ParseFile?>(
                              future: _fetchProfileImage(user),
                              builder: (context, imageSnapshot) {
                                String imageUrl = '';
                                if (imageSnapshot.hasData &&
                                    imageSnapshot.data != null) {
                                  imageUrl = imageSnapshot.data!.url!;
                                }

                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserProfile(
                                              username:
                                                  user.username.toString(),
                                              emailAddress:
                                                  user.emailAddress.toString(),
                                              fullname:
                                                  user['fullName'].toString(),
                                              dob: dob.toString(),
                                              address:
                                                  user['address'].toString(),
                                              phonenumber: user['phoneNumber']
                                                  .toString(),
                                              gender: user['gender'].toString(),
                                              url: imageUrl.toString(),
                                              userObjectId:
                                                  user.objectId.toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        child: ListTile(
                                          title: Text('${user.username}'),
                                          subtitle: Text('${dob}'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ParseObject>> doUserQuery() async {
    QueryBuilder<ParseUser> queryUsers =
        QueryBuilder<ParseUser>(ParseUser.forQuery())
          ..orderByDescending('createdAt');
    final ParseResponse apiResponse = await queryUsers.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
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
}
