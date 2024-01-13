import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/views/common/exports.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    Key? key,
    required this.controller,
    this.validator,
    this.keyboard,
    this.suffixIcon,
    this.obscureText, this.onEditingComplete, this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, height: 45.h,
      padding: EdgeInsets.only(bottom: 5.h),
      color: Color(kLightGrey.value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5.w,),
              GestureDetector(
                onTap: (){Get.back();},
                child: Icon(Ionicons.chevron_back, size: 30.sp, color: Color(kOrange.value),),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.h),
                width: width*0.65,
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Search job',
                      // suffixIcon: ,
                      hintStyle: appstyle(14.sp, Color(kDarkGrey.value), FontWeight.w500),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.red, width: 0.5.w)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.transparent, width: 0)
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.red, width: 0.5.w)
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Color(kDarkGrey.value), width: 0.5.w)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.transparent, width: 0.5.w)
                      ),
                      border: InputBorder.none
                  ),
                  controller: controller,
                  cursorHeight: 25.h,
                  style: appstyle(14.sp, Color(kDark.value), FontWeight.w500),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(Ionicons.search_circle_outline, size: 35.sp, color: Color(kOrange.value),),
          ),
          SizedBox(width: 1.5.w,)
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class CustomField extends StatelessWidget {
//   const CustomField({
//     Key? key,
//     required this.hintText,
//     required this.controller,
//     this.validator,
//     this.keyboard,
//     this.suffixIcon,
//     this.obscureText, this.onEditingComplete,
//   }) : super(key: key);
//
//   final TextEditingController controller;
//   final String hintText;
//   final TextInputType? keyboard;
//   final String? Function(String?)? validator;
//   final Widget? suffixIcon;
//   final void Function()? onEditingComplete;
//   final bool? obscureText;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Color(kOrange.value),
//       child: TextField(
//           keyboardType: keyboard,
//           obscureText: obscureText ?? false,
//           onEditingComplete: onEditingComplete,
//           decoration: InputDecoration(
//               hintText: hintText.toUpperCase(),
//               suffixIcon: suffixIcon,
//               suffixIconColor: Color(kLight.value),
//               hintStyle: appstyle(16, Color(kLight.value), FontWeight.w500),
//               // contentPadding: EdgeInsets.only(left: 24),
//               errorBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.zero,
//                 borderSide: BorderSide(color: Colors.white, width: 0.5),
//               ),
//               focusedBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.zero,
//                 borderSide: BorderSide(color: Colors.transparent, width: 0),
//               ),
//               focusedErrorBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.zero,
//                 borderSide: BorderSide(color: Colors.red, width: 0.5),
//               ),
//               disabledBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.zero,
//                 borderSide: BorderSide(color: Colors.grey, width: 0),
//               ),
//               enabledBorder: const OutlineInputBorder(
//                 borderRadius: BorderRadius.zero,
//                 borderSide: BorderSide(color: Colors.transparent, width: 0),
//               ),
//               border: InputBorder.none),
//           controller: controller,
//           cursorHeight: 25,
//           style: appstyle(14, Color(kLight.value), FontWeight.w500),
//           onSubmitted: validator),
//     );
//   }
// }

