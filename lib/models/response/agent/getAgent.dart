import 'dart:convert';

GetAgent getAgentFromJson(String str) => GetAgent.fromJson(json.decode(str));

String getAgentToJson(GetAgent data) => json.encode(data.toJson());

class GetAgent {
  final String company;
  final String hqAddress;
  final String workingHrs;

  GetAgent({
    required this.company,
    required this.hqAddress,
    required this.workingHrs,
  });

  factory GetAgent.fromJson(Map<String, dynamic> json) => GetAgent(
    company: json['company'],
    hqAddress: json['hqAddress'],
    workingHrs: json['workingHrs'],
  );

  Map<String, dynamic> toJson() => {
    "company": company,
    "hqAddress": hqAddress,
    "workingHrs": workingHrs,

  };
}
