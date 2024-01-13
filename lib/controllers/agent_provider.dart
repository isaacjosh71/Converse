import 'package:flutter/cupertino.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/services/helpers/agent_helper.dart';

import '../models/request/agents/agents.dart';
import '../models/response/agent/getAgent.dart';

class AgentNotifier extends ChangeNotifier {
  late List<Agents> allAgents;
  late Future<List<JobsResponse>> agentJobs;
  late Map<String, dynamic> chat;

  Agents? agents;

  Future<List<Agents>> getAgents (){
    var allAgents = AgentHelper.getAgents();
    return allAgents;
  }


  Future<GetAgent> getAgentInfo (String uid){
    var getAgent = AgentHelper.getAgentInfo(uid);
    return getAgent;
  }


  Future<List<JobsResponse>> getAgentJobs(String uid){
    var agentJobs = AgentHelper.getAgentJobs(uid);
    return agentJobs;
  }
}