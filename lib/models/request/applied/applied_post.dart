import 'dart:convert';

AppliedPost appliedPostFromJson(String str) => AppliedPost.fromJson(json.decode(str));

String appliedPostToJson(AppliedPost data) => json.encode(data.toJson());

class AppliedPost {
  AppliedPost({
    required this.job,
  });

  final String job;

  factory AppliedPost.fromJson(Map<String, dynamic> json) => AppliedPost(
    job: json["job"],
  );

  Map<String, dynamic> toJson() => {
    "job": job,

  };
}
