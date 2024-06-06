import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  final int? userId;
  final String? fullName;
  final String? email;
  final String userName;
  final String password;
  final String? dateOfBirth;
  final String? gender;
  final String? phoneNumber;
  final String? imagePath;
  final String? address;

  Users({
    this.userId,
    this.fullName,
    this.email,
    required this.userName,
    required this.password,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.imagePath,
    this.address,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        userId: json["userId"],
        fullName: json["fullName"],
        email: json["email"],
        userName: json["userName"],
        password: json["password"],
        dateOfBirth: json["dateOfBirth"],
        gender: json["gender"],
        phoneNumber: json["phoneNumber"],
        imagePath: json['imagePath'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "fullName": fullName,
        "email": email,
        "userName": userName,
        "password": password,
        "dateOfBirth": dateOfBirth,
        "gender": gender,
        "phoneNumber": phoneNumber,
        'imagePath': imagePath,
        'address': address,
      };
}
