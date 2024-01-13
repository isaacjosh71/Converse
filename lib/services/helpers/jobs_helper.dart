import 'package:http/http.dart' as https;
import 'package:jobhub/models/response/jobs/get_job.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/constants/url_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobsHelper {
  static var client = https.Client();

  static Future<List<JobsResponse>> getJobs() async{
    Map<String, String> requestHeaders = {
      'Content-Type':'application/json'
    };
    var url = Uri.https(Config.apiUrl, Config.jobs);
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Failed to load jobs');
    }
  }


  static Future<GetJobRes> getJob(String jobId) async{
    Map<String, String> requestHeaders = {
      'Content-Type':'application/json'
    };
    var url = Uri.https(Config.apiUrl, "${Config.jobs}/$jobId");
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var job = getJobResFromJson(response.body);
      return job;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  static Future<List<JobsResponse>> getRecent() async{
    Map<String, String> requestHeaders = {
      'Content-Type':'application/json'
    };
    var url = Uri.https(Config.apiUrl, Config.jobs, {'new':'true'});
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  static Future<List<JobsResponse>> searchJobs(String query) async{
    Map<String, String> requestHeaders = {
      'Content-Type':'application/json'
    };
    var url = Uri.https(Config.apiUrl, "${Config.search}/$query");
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var jobList = jobsResponseFromJson(response.body);
      return jobList;
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  static Future<bool> createJob(String model) async{
    try{
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      if(token==null){
        return false;
      }

      Map<String, String> requestHeaders = {
        'Content-Type':'application/json',
        'authorization':'Bearer $token',
      };
      var url = Uri.https(Config.apiUrl, Config.jobs);
      print(url);

      var response = await client.post(url, headers: requestHeaders, body: model);
      if(response.statusCode == 200){
        return true;
      } else {return false;}
    } catch(e){
      return false;
    }
  }

  static Future<bool> updateJob(String model, String jobId) async{
    try{
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      if(token==null){
        return false;
      }

      Map<String, String> requestHeaders = {
        'Content-Type':'application/json',
        'authorization':'Bearer $token',
      };
      var url = Uri.https(Config.apiUrl, "${Config.jobs}/$jobId");
      print(url);

      var response = await client.put(url, headers: requestHeaders, body: model);
      if(response.statusCode == 200){
        return true;
      } else {return false;}
    } catch(e){
      return false;
    }
  }

}
