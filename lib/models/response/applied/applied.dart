// To parse this JSON data, do
//
//     final applied = appliedFromJson(jsonString);

import 'dart:convert';

List<Applied> appliedFromJson(String str) => List<Applied>.from(json.decode(str).map((x) => Applied.fromJson(x)));

String appliedToJson(List<Applied> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Applied {
  final String id;
  final String user;
  final Job job;

  Applied({
    required this.id,
    required this.user,
    required this.job,
  });

  factory Applied.fromJson(Map<String, dynamic> json) => Applied(
    id: json["_id"],
    user: json["user"],
    job: Job.fromJson(json["job"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "job": job.toJson(),
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
