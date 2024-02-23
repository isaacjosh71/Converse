// To parse this JSON data, do
//
//     final createJobsRequest = createJobsRequestFromJson(jsonString);

import 'dart:convert';

CreateJobsRequest createJobsRequestFromJson(String str) => CreateJobsRequest.fromJson(json.decode(str));

String createJobsRequestToJson(CreateJobsRequest data) => json.encode(data.toJson());

class CreateJobsRequest {
    final String title;
    final String location;
    final String company;
    final String description;
    final String level;
    final String salary;
    final String contract;
    final bool hiring;
    final String period;
    final String imageUrl;
    final String agentId;
    final String agentName;
    final String agentPic;
    final List<String> requirements;

    CreateJobsRequest({
        required this.title,
        required this.location,
        required this.company,
        required this.description,
        required this.level,
        required this.salary,
        required this.contract,
        required this.hiring,
        required this.period,
        required this.imageUrl,
        required this.agentId,
        required this.agentName,
        required this.agentPic,
        required this.requirements,
    });

    factory CreateJobsRequest.fromJson(Map<String, dynamic> json) => CreateJobsRequest(
        title: json["title"],
        location: json["location"],
        company: json["company"],
        description: json["description"],
        level: json["level"],
        salary: json["salary"],
        contract: json["contract"],
        hiring: json["hiring"],
        period: json["period"],
        imageUrl: json["imageUrl"],
        agentId: json["agentId"],
        agentName: json["agentName"],
        agentPic: json["agentPic"],
        requirements: List<String>.from(json["requirements"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "location": location,
        "company": company,
        "description": description,
        "level": level,
        "salary": salary,
        "contract": contract,
        "hiring": hiring,
        "period": period,
        "imageUrl": imageUrl,
        "agentId": agentId,
        "agentName": agentName,
        "agentPic": agentPic,
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
    };
}
