import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/views/common/app_style.dart';

class buildTextField extends StatelessWidget {
  const buildTextField({super.key, required this.controller, required this.hintText, this.initialValue, this.keyboard, this.onSubmitted, this.onTap, this.onChanged, this.maxLines=1, this.label, this.height, this.suffixIcon});
  final TextEditingController controller;
  final String hintText;
  final String? initialValue;
  final TextInputType? keyboard;
  final String? Function(String?)? onSubmitted;
  final void Function()? onTap;
  final Function(String)? onChanged;
  final int maxLines;
  final Widget? label;
  final double? height;
  final Widget? suffixIcon;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: SizedBox(
        height: height ?? 60.h,
        child: TextFormField(
          validator: onSubmitted,
          initialValue: initialValue,
            keyboardType: keyboard,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            isDense: true,
            hintText: hintText,
            label: label,
            hintStyle: appstyle(12.sp, Colors.grey.shade600, FontWeight.w600),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 0.5.w),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 0.5.w),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue.shade600, width: 0.5.w),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5.w),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0.5.w),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue.shade600, width: 0.5.w),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
            ),
          ),
          cursorHeight: 25.h,
          controller: controller,
          style: appstyle(11, Colors.black, FontWeight.normal),
        ),
      ),
    );
  }
}
