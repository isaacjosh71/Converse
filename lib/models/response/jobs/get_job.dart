// To parse this JSON data, do
//
//     final getJobRes = getJobResFromJson(jsonString);

import 'dart:convert';

GetJobRes getJobResFromJson(String str) => GetJobRes.fromJson(json.decode(str));

String getJobResToJson(GetJobRes data) => json.encode(data.toJson());

class GetJobRes {
    final String id;
    final String title;
    final String location;
    final String description;
    final String agentName;
    final String salary;
    final String period;
    final String contract;
    final bool hiring;
    final List<String> requirements;
    final String imageUrl;
    final String agentId;
    // final int v;
    final String company;
    final String level;

    GetJobRes({
        required this.id,
        required this.title,
        required this.location,
        required this.description,
        required this.agentName,
        required this.salary,
        required this.period,
        required this.contract,
        required this.hiring,
        required this.requirements,
        required this.imageUrl,
        required this.agentId,
        // required this.v,
        required this.company,
        required this.level,
    });

    factory GetJobRes.fromJson(Map<String, dynamic> json) => GetJobRes(
        id: json["_id"],
        title: json["title"],
        location: json["location"],
        description: json["description"],
        agentName: json["agentName"],
        salary: json["salary"],
        period: json["period"],
        contract: json["contract"],
        hiring: json["hiring"],
        requirements: List<String>.from(json["requirements"].map((x) => x)),
        imageUrl: json["imageUrl"],
        agentId: json["agentId"],
        // v: json["__v"],
        company: json["company"],
        level: json["level"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "location": location,
        "description": description,
        "agentName": agentName,
        "salary": salary,
        "period": period,
        "contract": contract,
        "hiring": hiring,
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
        "imageUrl": imageUrl,
        "agentId": agentId,
        // "__v": v,
        "company": company,
        "level": level,
    };
}
