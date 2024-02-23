// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    final String id;
    final String username;
    final String email;
    final String uid;
    // final bool updated;
    final bool isAgent;
    final String profile;
    final String userToken;

    LoginResponseModel({
        required this.id,
        required this.username,
        required this.email,
        required this.uid,
        // required this.updated,
        required this.isAgent,
        required this.profile,
        required this.userToken,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        uid: json["uid"],
        // updated: json["updated"],
        isAgent: json["isAgent"],
        profile: json["profile"],
        userToken: json["userToken"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "uid": uid,
        // "updated": updated,
        "isAgent": isAgent,
        "profile": profile,
        "userToken": userToken,
    };
}
