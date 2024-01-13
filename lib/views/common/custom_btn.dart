import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/views/common/app_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, this.onTap});
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h, width: 60.w,
        decoration: BoxDecoration(
          color: Color(kOrange.value),
          borderRadius: BorderRadius.all(Radius.circular(12.r))
        ),
        child: Center(
          child: Text(text, style: appstyle(14.sp, Color(kLight.value), FontWeight.normal),),
        ),
      ),
    );
  }
}