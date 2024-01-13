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
    if(_bookmarked != newState){
      _bookmarked = newState;
      notifyListeners();
    }
  }

  String _bookmarkId = '';
  String get bookmarkId => _bookmarkId;

  set isBookMarkId(String newState){
    if(_bookmarkId != newState){
      _bookmarkId = newState;
      notifyListeners();
    }
  }

  addBookmark(String model) {
    BookMarkHelper.addBookMark(model).then((bookmark) {
      isBookMarked = true;
      isBookMarkId = bookmark.bookmarkId;
    });
  }

    getBookmark(String jobId){
    var bookMark = BookMarkHelper.getBookMark(jobId);
      bookMark.then((value){
        if(value == null){
          isBookMarked =  false;
          isBookMarkId = '';
        } else{
          isBookMarked = true;
          isBookMarkId = value.bookmarkId;
        }
      });
    }

    deleteBookMark(String jobId){
    BookMarkHelper.deleteBookMark(jobId).then((bookmark){
      if(bookmark){
        Get.snackbar('Bookmark successfully deleted', 'Visit bookmarks to see changes',
        backgroundColor: Color(kOrange.value), colorText: Color(kLight.value),
          icon: Icon(Icons.bookmark_remove_outlined, color: Color(kLight.value),)
        );
      }
      isBookMarked = false;
    });
    }

    Future<List<AllBookmarks>> getAllBookmarks(){
    bookmarks = BookMarkHelper.getAllBookMarks();
    return bookmarks;
    }
}
