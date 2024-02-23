import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jobhub/models/response/auth/profile_model.dart';
import '../models/response/jobs/get_job.dart';
import 'package:get/get.dart';

//Responsive with GetX
class Dimensions{
  static double height = Get.context!.height;
  static double width = Get.context!.width;

// double height = 812.h;
// double width = 375.w;
  //MediaQuery.of(context).size.height
}

const kDark = Color(0xFF000000);
const kLight = Color(0xFFFFFFFF);
const kLightGrey = Color(0x95D1CECE);
const kDarkGrey = Color(0xFF9B9B9B);
const kOrange = Color(0xfff55631);
const kLightBlue = Color(0xff3663e3);
const kDarkBlue = Color(0xff1c153e);
const kDarkPurple = Color(0xff6352c5);
const kNewBlue = Color(0xFF3281E3);
const kGreen = Color(0xFFEFFFFC);


String userName = '';
String pdf = '';
String mySkills = '';
String pdfUrlFromProfile = '';
String email = '';
String userUid = '';
String profileImage = '';
String token = '';
String imagePath = '';
bool isAgent = false;
bool isApplied = false;
GetJobRes? jobUpdate;
ProfileRes? profileUpdate;