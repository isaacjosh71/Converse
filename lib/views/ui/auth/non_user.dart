import 'package:cached_network_image/cached_network_image.dart';
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
    String imageUrl = 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTAxL3JtNjA5LXNvbGlkaWNvbi13LTAwMi1wLnBuZw.png';
    return  buildStyleContainer(
      context,
      Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(99.w)),
            child: CachedNetworkImage(
                height: 30.h, width: 30.w,
                imageUrl: imageUrl,
                fit: BoxFit.cover
            ),
          ),
          SizedBox(height: 10.h,),
          ReusableText(text: 'To access content, kindly login',
              style: appstyle(12.sp, Color(kDark.value), FontWeight.normal)),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
          child: CustomOutlineBtn(text: 'Proceed to login',
            onTap: (){Get.to(()=> const LoginPage());},
            color: Color(kOrange.value), width: Dimensions.width, height: 40.h,),
          )
        ],
      )
    );
  }
}
