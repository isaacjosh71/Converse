// To parse this JSON data, do
//
//     final signupResponseModel = signupResponseModelFromJson(jsonString);

import 'dart:convert';

SignupResponseModel signupResponseModelFromJson(String str) => SignupResponseModel.fromJson(json.decode(str));

String signupResponseModelToJson(SignupResponseModel data) => json.encode(data.toJson());

class SignupResponseModel {
  final String username;
  final String email;
  final String uid;
  final bool updated;
  final bool isAgent;
  final bool skills;
  final String profile;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String userToken;

  SignupResponseModel({
    required this.username,
    required this.email,
    required this.uid,
    required this.updated,
    required this.isAgent,
    required this.skills,
    required this.profile,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.userToken,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) => SignupResponseModel(
    username: json["username"],
    email: json["email"],
    uid: json["uid"],
    updated: json["updated"],
    isAgent: json["isAgent"],
    skills: json["skills"],
    profile: json["profile"],
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    userToken: json["userToken"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "uid": uid,
    "updated": updated,
    "isAgent": isAgent,
    "skills": skills,
    "profile": profile,
    "_id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "userToken": userToken,
  };
}
