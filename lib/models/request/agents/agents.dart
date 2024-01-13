
import 'dart:convert';

List<Agents> agentsFromJson(String str) => List<Agents>.from(json.decode(str).map((x)=> Agents.fromJson(x)));

class Agents {
  final String username;
  final String uid;
  final String profile;

  Agents({
    required this.profile,
    required this.username,
    required this.uid
});

  factory Agents.fromJson(Map<String, dynamic> json) => Agents(
      profile: json['profile'],
      username: json['username'],
      uid: json['uid']
  );
}