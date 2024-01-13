import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
    LoginResponseModel({
        required this.id,
        required this.userToken,
        this.userName, this.uid, this.profile, this.isAgent,
    });

    final String id;
    final String userToken;
    final String? userName;
    final String? uid;
    final String? profile;
    final bool? isAgent;

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        id: json["_id"],
        userToken: json["userToken"],
        userName: json["userName"],
        uid: json["uid"],
        profile: json["profile"],
        isAgent: json["isAgent"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userToken": userToken,
        "isAgent": isAgent,
        "userName": userName,
        "profile": profile,
        "uid": uid,
    };
}
