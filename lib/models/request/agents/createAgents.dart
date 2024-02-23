// To parse this JSON data, do
//
//     final beAgent = beAgentFromJson(jsonString);

import 'dart:convert';

BeAgent beAgentFromJson(String str) => BeAgent.fromJson(json.decode(str));

String beAgentToJson(BeAgent data) => json.encode(data.toJson());

class BeAgent {
  final String id;
  final String company;
  final String hqAddress;
  final String workingHrs;

  BeAgent({
    required this.id,
    required this.company,
    required this.hqAddress,
    required this.workingHrs,
  });

  factory BeAgent.fromJson(Map<String, dynamic> json) => BeAgent(
    id: json["id"],
    company: json["company"],
    hqAddress: json["hqAddress"],
    workingHrs: json["workingHrs"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company": company,
    "hqAddress": hqAddress,
    "workingHrs": workingHrs,
  };
}
