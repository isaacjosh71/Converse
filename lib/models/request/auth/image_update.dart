// To parse this JSON data, do
//
//     final profileUpdateReq = profileUpdateReqFromJson(jsonString);

import 'dart:convert';

ProfileImageReq profileImageReqFromJson(String str) => ProfileImageReq.fromJson(json.decode(str));

String profileImageReqToJson(ProfileImageReq data) => json.encode(data.toJson());

class ProfileImageReq {
  final String profile;

  ProfileImageReq({
    required this.profile,
  });

  factory ProfileImageReq.fromJson(Map<String, dynamic> json) => ProfileImageReq(
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "profile": profile,
  };
}
