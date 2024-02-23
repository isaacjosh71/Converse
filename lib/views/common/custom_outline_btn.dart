import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/views/common/exports.dart';

class CustomOutlineBtn extends StatelessWidget {
  const CustomOutlineBtn({super.key, this.width, this.height, required this.text, this.onTap, required this.color, this.color2});

  final double? width;
  final double? height;
  final String text;
  final void Function()? onTap;
  final Color color;
  final Color? color2;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width, height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(0)),
              color: color2,
          border: Border.all(
            width: 1, color: color,
          )
        ),
        child: Center(
          child: ReusableText(text: text,
          style: appstyle(14.sp, color, FontWeight.normal),
          ),
        ),
      ),
    );
  }
}