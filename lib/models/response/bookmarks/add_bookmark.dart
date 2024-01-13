import 'dart:convert';

AddBookmark addBookmarkFromJson(String str) => AddBookmark.fromJson(json.decode(str));

String addBookmarkToJson(AddBookmark data) => json.encode(data.toJson());

class AddBookmark {
  final bool status;
  final String bookmarkId;

  AddBookmark({
    required this.status,
    required this.bookmarkId
});

  factory AddBookmark.fromJson(Map<String, dynamic> json) => AddBookmark(
      status: json['status'],
      bookmarkId: json['bookmarkId']
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "bookmarkId": bookmarkId,

  };
}
