import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/app_constants.dart';
import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Dimensions.height,
        width: Dimensions.width,
        color: Color(kDarkBlue.value),
        child: Column(
          children: [
            SizedBox(height: 70.h,),
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Image.asset('assets/images/page2.png'),
            ),
            SizedBox(height: 20.h,),
            Column(
              children: [
                Text('Get Stabled With\nYour Abilities',
                    textAlign: TextAlign.center,
                    style: appstyle(25.sp, Color(kLight.value), FontWeight.w500)),
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