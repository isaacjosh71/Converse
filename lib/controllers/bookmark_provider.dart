import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhub/services/helpers/book_helper.dart';


class BookMarkNotifier extends ChangeNotifier {

  late Future<List<AllBookmarks>> bookmarks;

  bool _bookmarked = false;
  bool get bookmarked => _bookmarked;

  set isBookMarked(bool newState){
    // if(_bookmarked != newState){
      _bookmarked = newState;
      notifyListeners();
    // }
  }

  String _bookmarkId = '';
  String get bookmarkId => _bookmarkId;

  set isBookMarkId(String newState){
    // if(_bookmarkId != newState){
      _bookmarkId = newState;
      notifyListeners();
    // }
  }

  addBookmark(String model) {
    BookMarkHelper.addBookMark(model).then((bookmark) {
      _bookmarked = bookmark.status;
      _bookmarkId = bookmark.bookmarkId;
      Get.snackbar('Bookmark successfully added', 'Visit bookmarks to see changes',
          backgroundColor: Color(kOrange.value), colorText: Color(kLight.value),
          icon: Icon(Icons.bookmark_add_outlined, color: Color(kLight.value),)
      );
    });
  }

    getBookmark(String jobId){
    var bookMark = BookMarkHelper.getBookMark(jobId);
      bookMark.then((value){
        if(value == null){
          print(value);
          _bookmarked =  false;
          _bookmarkId = '';
        } else{
          print(value);
          _bookmarked = value.status;
          _bookmarkId = value.bookmarkId;
        }
      });
    }

    deleteBookMark(String bookmarkId){
    BookMarkHelper.deleteBookMark(bookmarkId).then((bookmark){
      if(bookmark==true){
        Get.snackbar('Bookmark successfully deleted', 'Visit bookmarks to see changes',
        backgroundColor: Color(kOrange.value), colorText: Color(kLight.value),
          icon: Icon(Icons.bookmark_remove_outlined, color: Color(kLight.value),)
        );
      }
      _bookmarked = false;
    });
    }

    Future<List<AllBookmarks>> getAllBookmarks(){
    bookmarks = BookMarkHelper.getAllBookMarks();
    return bookmarks;
    }
}
