import 'dart:convert';

List<AllBookmarks> allBookmarksFromJson(String str) => List<AllBookmarks>.from(json.decode(str).map((x) => AllBookmarks.fromJson(x)));

String allBookmarksToJson(List<AllBookmarks> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllBookmarks {
  AllBookmarks({
    required this.id,
    required this.job,
    required this.userId,
  });

  final String id;
  final Job job;
  final String userId;

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

class Job{
  final String id;
  final String title;
  final String location;
  final String company;
  final bool hiring;
  final String salary;
  final String period;
  final String contract;
  final String imageUrl;
  final String agentId;
  final String agentName;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.hiring,
    required this.salary,
    required this.period,
    required this.contract,
    required this.imageUrl,
    required this.agentId,
    required this.agentName,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json["_id"],
    title: json["title"],
    location: json["location"],
    agentName: json["agentName"],
    company: json["company"],
    hiring: json["hiring"],
    salary: json["salary"],
    period: json["period"],
    contract: json["contract"],
    imageUrl: json["imageUrl"],
    agentId: json["agentId"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "location": location,
    "agentName": agentName,
    "company": company,
    "hiring": hiring,
    "salary": salary,
    "period": period,
    "contract": contract,
    "imageUrl": imageUrl,
    "agentId": agentId,
  };
}
