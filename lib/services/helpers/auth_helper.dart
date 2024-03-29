import 'package:http/http.dart' as https;
import 'package:jobhub/models/response/auth/login_res_model.dart';
import 'package:jobhub/models/response/auth/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/response/auth/sign_up_res.dart';
import '../../models/response/skills/skills.dart';
import '../../constants/url_config.dart';

class AuthHelper {
  static var client = https.Client();

  static Future<bool> signup(String model) async{
    try{
    Map<String, String> requestHeaders = {
      'Content-Type':'application/json'
    };
    var url = Uri.https(Config.apiUrl, Config.signupUrl);
    print(url);

    var response = await client.post(url, headers: requestHeaders, body: model);
    if(response.statusCode == 201){
      var user = signupResponseModelFromJson(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      await prefs.setString('token', user.userToken);
      await prefs.setString('userId', user.id);
      await prefs.setString('userUid', user.uid);
      // await prefs.setString('profile', user.profile);
      //await prefs.setBool('agent', user.isAgent);
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);
      print('Successful Registration');
      return true;
    } else {return false;}
    } catch(e){
      return false;
    }
  }

  static Future<bool> login(String model) async{
    Map<String, String> requestHeaders = {
      'Content-Type':'application/json'
    };
    var url = Uri.https(Config.apiUrl, Config.loginUrl);
    print(url);

    var response = await client.post(url, headers: requestHeaders, body: model);
    if(response.statusCode == 200){
      print('Successful Login');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = loginResponseModelFromJson(response.body);
      await prefs.setBool('loggedIn', true);
      await prefs.setString('token', user.userToken);
      await prefs.setString('userId', user.id);
      await prefs.setString('userUid', user.uid);
      await prefs.setString('profile', user.profile);
      await prefs.setString('username', user.username);
      await prefs.setString('email', user.email);
      return true;
    } else {return false;}
  }

  static Future<ProfileRes> getProfile() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if (token==null){throw  Exception('Authentication token not found');}

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    try{
      var url = Uri.https(Config.apiUrl, Config.profileUrl);

      var response = await client.get(url, headers: requestHeaders);
      if(response.statusCode == 200){
        var profile = profileResFromJson(response.body);
        return profile;
      } else {throw Exception('Failed to load profile');}
    } catch (e){throw Exception('Failed to load profile $e');}
  }


  static Future<bool> updateProfile(var model) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
//user profile
    if (token==null){throw  Exception('Authentication token not found');}

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    try{
      var url = Uri.https(Config.apiUrl, Config.profileUrl);

      var response = await client.put(url, headers: requestHeaders, body: model);
      if(response.statusCode == 200){
        return true;
      } else {return false;}
    } catch (e){return false;}
  }

  static Future<bool> updateImage(var model) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if (token==null){throw  Exception('Authentication token not found');}

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    try{
      var url = Uri.https(Config.apiUrl, Config.profileUrl);

      var response = await client.put(url, headers: requestHeaders, body: model);
      if(response.statusCode == 200){
        return true;
      } else {return false;}
    } catch (e){return false;}
  }

  // static Future<bool> updatePassword(var model) async{
  //
  //   Map<String, String> requestHeaders = {
  //     'Content-Type':'application/json',
  //   };
  //   try{
  //     var url = Uri.https(Config.apiUrl, Config.passwordUrl);
  //
  //     var response = await client.put(url, headers: requestHeaders, body: model);
  //     if(response.statusCode == 200){
  //       return true;
  //     } else {return false;}
  //   } catch (e){return false;}
  // }

  static Future<List<Skills>> getSkills() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if (token==null){throw  Exception('Authentication token not found');}

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    try{
      var url = Uri.https(Config.apiUrl, Config.skills);
      print(url);

      var response = await client.get(url, headers: requestHeaders);
      if(response.statusCode == 200){
        var skills = skillsFromJson(response.body);
        return skills;
      } else {throw Exception('Failed to load skills');}
    } catch (e){throw Exception('Failed to load skills $e');}
  }

  static Future<bool> addSkills(String model) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if (token==null){throw  Exception('Authentication token not found');}

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    try{
      var url = Uri.https(Config.apiUrl, Config.skills);
      print(url);

      var response = await client.post(url, headers: requestHeaders, body: model);
      if(response.statusCode == 200){
        return true;
      } else {return false;}
    } catch (e){return false;}
  }

  static Future<bool> deleteSkills(String id) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    if (token==null){throw  Exception('Authentication token not found');}

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    try{
      var url = Uri.https(Config.apiUrl, "${Config.skills}/$id");
      print(url);

      var response = await client.delete(url, headers: requestHeaders);
      if(response.statusCode == 200){
        return true;
      } else { return false;}
    } catch (e){return false;}
  }

}
