// To parse this JSON data, do
//
//     final allBookmarks = allBookmarksFromJson(jsonString);

import 'dart:convert';

List<AllBookmarks> allBookmarksFromJson(String str) => List<AllBookmarks>.from(json.decode(str).map((x) => AllBookmarks.fromJson(x)));

String allBookmarksToJson(List<AllBookmarks> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllBookmarks {
  final String id;
  final Job job;
  final String userId;

  AllBookmarks({
    required this.id,
    required this.job,
    required this.userId,
  });

  factory AllBookmarks.fromJson(Map<String, dynamic> json) => AllBookmarks(
    id: json["_id"],
    job: Job.fromJson(json["job"]),
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "job": job.toJson(),
    "userId": userId,
  };
}

class Job {
  final String id;
  final String title;
  final String location;
  final String company;
  final String level;
  final String agentName;
  final String salary;
  final String period;
  final String contract;
  final bool hiring;
  final String imageUrl;
  final String agentId;
  final String agentPic;

  Job({
    required this.id,
    required this.title,
    required this.location,
    required this.company,
    required this.level,
    required this.agentName,
    required this.salary,
    required this.period,
    required this.contract,
    required this.hiring,
    required this.imageUrl,
    required this.agentId,
    required this.agentPic,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json["_id"],
    title: json["title"],
    location: json["location"],
    company: json["company"],
    level: json["level"],
    agentName: json["agentName"],
    salary: json["salary"],
    period: json["period"],
    contract: json["contract"],
    hiring: json["hiring"],
    imageUrl: json["imageUrl"],
    agentId: json["agentId"],
    agentPic: json["agentPic"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "location": location,
    "company": company,
    "level": level,
    "agentName": agentName,
    "salary": salary,
    "period": period,
    "contract": contract,
    "hiring": hiring,
    "imageUrl": imageUrl,
    "agentId": agentId,
    "agentPic": agentPic,
  };
}
