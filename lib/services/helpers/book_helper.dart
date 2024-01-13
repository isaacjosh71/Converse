import 'package:http/http.dart' as https;
import 'package:jobhub/models/response/bookmarks/add_bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/response/bookmarks/all_bookmarks.dart';
import '../../constants/url_config.dart';

class BookMarkHelper {
  static var client = https.Client();

  //add a bookmark
  static Future<AddBookmark> addBookMark(String model) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

      Map<String, String> requestHeaders = {
        'Content-Type':'application/json',
        'authorization':'Bearer $token',
      };
      var url = Uri.https(Config.apiUrl, Config.bookmarkUrl);
      print(url);

      var response = await client.post(url, headers: requestHeaders, body: model);
      if(response.statusCode == 200){
        var bookMark = addBookmarkFromJson(response.body);
        return bookMark;
      } else { throw Exception('Failed to get bookmark');}
  }

  //get all bookmarks
  static Future<List<AllBookmarks>> getAllBookMarks() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    var url = Uri.https(Config.apiUrl, Config.bookmarkUrl);
    print(url);

    var response = await client.get(url, headers: requestHeaders);
    if(response.statusCode == 200){
      var bookMarks = allBookmarksFromJson(response.body);
      return bookMarks;
    } else {throw Exception('Failed to get bookmarks');}
  }

  //get a single bookmark
  static Future<AddBookmark?> getBookMark(String jobId) async{
    try{
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      if(token==null){
        return null;
      }

      Map<String, String> requestHeaders = {
        'Content-Type':'application/json',
        'authorization':'Bearer $token',
      };
      var url = Uri.https(Config.apiUrl, "${Config.singleBookmarkUrl}$jobId");
      print(url);

      var response = await client.get(url, headers: requestHeaders);
      if(response.statusCode == 200){
        var bookMark = addBookmarkFromJson(response.body);
        return bookMark;
      } else {return null;}
    } catch(e){
      return null;
    }
  }

  //delete a bookmark
  static Future<bool> deleteBookMark(String bookmarkId) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type':'application/json',
      'authorization':'Bearer $token',
    };
    var url = Uri.https(Config.apiUrl, "${Config.singleBookmarkUrl}/$bookmarkId");
    print(url);

    var response = await client.delete(url, headers: requestHeaders);
    if(response.statusCode ==200){
      return true;
    } else{return false;}
  }

}
