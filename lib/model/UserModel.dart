// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String bio;
  String email;
  String uid;
  String username;
  String imgUrl;
  String instagram;
  String linkedin;

  UserModel({
    required this.bio,
    required this.email,
    required this.username,
    required this.uid,
    required this.imgUrl,
    required this.instagram,
    required this.linkedin ,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      bio: json["bio"],
      email: json["email"],
      username: json["username"],
      uid: json['uid'],
      instagram: json['instagram'],
      linkedin: json['linkedin'],
      imgUrl: json['imgUrl']);

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "email": email,
        "username": username,
        "uid": uid,
        'imgUrl': imgUrl,
        'instagram':instagram,
        'linkedin':linkedin
      };
}
