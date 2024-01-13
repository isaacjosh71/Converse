import 'package:http/http.dart' as https;
import 'package:jobhub/models/response/applied/applied.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/url_config.dart';

class AppliedHelper {
  static var client = https.Client();

  //apply for a job
  static Future<bool> applyJob(String model) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if(token==null){
      return false;
    }

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };

    var url = Uri.https(Config.apiUrl, Config.appliedUrl);
    print(url);

    var response = await client.post(url, headers: requestHeaders, body: model);
    if(response.statusCode == 200){
      return true;
    } else {return false;}
  }

  //get all application list
  static Future<List<Applied>> getApplied() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if(token==null){
      throw Exception('failed to get token');
    }

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };

    var url = Uri.https(Config.apiUrl, Config.appliedUrl);
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var applied = appliedFromJson(response.body);
      return applied;
    } else {throw Exception('failed to get token');}
  }

}