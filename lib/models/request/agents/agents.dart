// To parse this JSON data, do
//
//     final agents = agentsFromJson(jsonString);

import 'dart:convert';

List<Agents> agentsFromJson(String str) => List<Agents>.from(json.decode(str).map((x) => Agents.fromJson(x)));

String agentsToJson(List<Agents> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Agents {
  final String id;
  final String username;
  final String email;
  final String password;
  final String uid;
  final bool updated;
  final bool isAdmin;
  final bool isAgent;
  final bool skills;
  final String profile;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Agents({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.uid,
    required this.updated,
    required this.isAdmin,
    required this.isAgent,
    required this.skills,
    required this.profile,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Agents.fromJson(Map<String, dynamic> json) => Agents(
    id: json["_id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    uid: json["uid"],
    updated: json["updated"],
    isAdmin: json["isAdmin"],
    isAgent: json["isAgent"],
    skills: json["skills"],
    profile: json["profile"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "email": email,
    "password": password,
    "uid": uid,
    "updated": updated,
    "isAdmin": isAdmin,
    "isAgent": isAgent,
    "skills": skills,
    "profile": profile,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
