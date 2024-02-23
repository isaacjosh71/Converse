import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub/views/common/custom_outline_btn.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/app_constants.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.height,
        width: Dimensions.width,
        color: Color(kLightBlue.value),
        child: Column(
          children: [
            Image.asset('assets/images/page3.png'),
            SizedBox(height: 20.h,),
            ReusableText(text: 'Welcome To Converse',
                style: appstyle(25.sp, Color(kLight.value), FontWeight.w500)),
            SizedBox(height: 20.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text('We help you find your dream job according to your skills and experience',
                textAlign: TextAlign.center,
                style: appstyle(14, Color(kLight.value), FontWeight.normal),),
            ),
            SizedBox(height: 20.h,),
            CustomOutlineBtn(text: 'Get Started',
              color: Color(kLight.value),
              height: Dimensions.height*0.05, width: Dimensions.width*0.7,
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('entryPoint', true);
              Get.to(()=> const MainScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}