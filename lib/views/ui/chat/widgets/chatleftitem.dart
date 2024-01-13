import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/views/common/app_style.dart';
import 'package:jobhub/views/ui/auth/profile.dart';

Widget chatLeftItem(String type, String message, String profile){
  return Stack(
    children: [
      Container(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 0.w, 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 40.h, maxWidth: 230.w
                ),
            child: Container(
              margin: EdgeInsets.only(top: 10.h, right: 10.w),
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 0.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 106, 185, 231),
                  Color.fromARGB(255, 140, 185, 229),
                  Color.fromARGB(255, 106, 185, 231),
                ], transform: GradientRotation(120))
              ),
              child: Text(message, style: appstyle(12.sp, Colors.white, FontWeight.normal),),
            ),
            )
          ],
        ),
      ),
      Positioned(
          left: 4.w,
          child: CircularProfileAvatar(image: profile, w: 20.w, h: 20.h))
    ],
  );
}