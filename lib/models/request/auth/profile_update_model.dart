// To parse this JSON data, do
//
//     final profileUpdateReq = profileUpdateReqFromJson(jsonString);

import 'dart:convert';

ProfileUpdateReq profileUpdateReqFromJson(String str) => ProfileUpdateReq.fromJson(json.decode(str));

String profileUpdateReqToJson(ProfileUpdateReq data) => json.encode(data.toJson());

class ProfileUpdateReq {
    final String username;
    final String email;

    ProfileUpdateReq({
        required this.username,
        required this.email,
    });

    factory ProfileUpdateReq.fromJson(Map<String, dynamic> json) => ProfileUpdateReq(
        username: json["username"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
    };
}
