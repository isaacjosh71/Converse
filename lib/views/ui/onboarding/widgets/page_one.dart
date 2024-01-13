import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/views/common/exports.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Color(kDarkPurple.value),
        child: Column(
          children: [
            SizedBox(height: 75.h,),
            Image.asset('assets/images/page1.png'),
            SizedBox(height: 40.h,),
            Column(
              children: [
                ReusableText(text: 'Find Your Dream Job',
                    style: appstyle(30, Color(kLight.value), FontWeight.w500)),
                SizedBox(height: 15.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text('We help you find your dream job according to your skills and experience',
                  textAlign: TextAlign.center,
                  style: appstyle(14, Color(kLight.value), FontWeight.normal),),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}