// To parse this JSON data, do
//
//     final skills = skillsFromJson(jsonString);

import 'dart:convert';

List<Skills> skillsFromJson(String str) => List<Skills>.from(json.decode(str).map((x) => Skills.fromJson(x)));

String skillsToJson(List<Skills> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Skills {
  final String id;
  final String userId;
  final String skill;
  final DateTime updatedAt;

  Skills({
    required this.id,
    required this.userId,
    required this.skill,
    required this.updatedAt,
  });

  factory Skills.fromJson(Map<String, dynamic> json) => Skills(
    id: json["_id"],
    userId: json["userId"],
    skill: json["skill"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "skill": skill,
    "updatedAt": updatedAt.toIso8601String(),
  };
}
