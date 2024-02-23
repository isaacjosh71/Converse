import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/views/common/exports.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20.h),
    child: Column(
      children: [
        Image.asset('assets/images/optimized_search.png'),
        SizedBox(height: 30.h,),
        ReusableText(text: text, style: appstyle(18.sp, Color(kDark.value), FontWeight.w500))
      ],
    ),
    );
  }
}