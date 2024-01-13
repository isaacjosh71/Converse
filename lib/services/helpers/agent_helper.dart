import 'package:http/http.dart' as https;
import 'package:jobhub/models/request/agents/agents.dart';
import 'package:jobhub/models/response/bookmarks/add_bookmark.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/response/agent/getAgent.dart';
import '../../models/response/bookmarks/all_bookmarks.dart';
import '../../constants/url_config.dart';

class AgentHelper {
  static var client = https.Client();

  //get all agents
  static Future<List<Agents>> getAgents() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if(token==null){
      throw Exception('Failed to get agents');
    }

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };

    var url = Uri.https(Config.apiUrl, Config.getAgents);
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var agents = agentsFromJson(response.body);
      return agents;
    } else {throw Exception('Failed to get agents');}
  }

  //get an agent info
  static Future<GetAgent> getAgentInfo(String uid) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if(token==null){
      throw Exception('Failed to get agents');
    }

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    var url = Uri.https(Config.apiUrl, "${Config.getAgents}/$uid");
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var agent = getAgentFromJson(response.body);
      return agent;
    } else {throw Exception('Failed to get agent');}
  }

  //get agent jobs

  static Future<List<JobsResponse>> getAgentJobs(String uid) async{

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json'
    };

    var url = Uri.https(Config.apiUrl, "${Config.jobs}/agent/$uid");
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var agents = jobsResponseFromJson(response.body);
      return agents;
    } else {throw Exception('Failed to get agents jobs');}
  }

}