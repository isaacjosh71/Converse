import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub/views/common/custom_outline_btn.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/auth/login.dart';

class NonUser extends StatelessWidget {
  const NonUser({super.key});

  @override
  Widget build(BuildContext context) {
    return  buildStyleContainer(
      context,
      Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(99.w)),
            child: Image.asset('assets/images/profile.webp', fit: BoxFit.cover,
            width: 70.w, height: 70.w,
            ),
          ),
          SizedBox(height: 10.h,),
          ReusableText(text: 'To access content please login',
              style: appstyle(12.sp, Color(kDark.value), FontWeight.normal)),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
          child: CustomOutlineBtn(text: 'Proceed to login',
            onTap: (){Get.to(()=> const LoginPage());},
            color: Color(kOrange.value), width: width, height: 40.h,),
          )
        ],
      )
    );
  }
}
