// To parse this JSON data, do
//
//     final updateUser = updateUserFromJson(jsonString);

import 'dart:convert';

UpdateUser updateUserFromJson(String str) => UpdateUser.fromJson(json.decode(str));

String updateUserToJson(UpdateUser data) => json.encode(data.toJson());

class UpdateUser {
  final bool status;

  UpdateUser({
    required this.status,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) => UpdateUser(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
