import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub/constants/app_constants.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FittedBox(
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Color(kLightGrey.value),
            borderRadius: BorderRadius.all(Radius.circular(10.r))
          ),
          child: Row(
            children: [
              SizedBox(
                width: width*0.84,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 30.w, height: 30.h,
                      decoration: BoxDecoration(
                        color: Color(kOrange.value),
                        borderRadius: BorderRadius.all(Radius.circular(9.r))
                      ),
                      child: Icon(
                        Feather.search, color: Color(kLight.value),
                        size: 20.h,
                      ),
                    ),
                    SizedBox(width: 20.w,)
                  ],
                ),
              ),
              Icon(FontAwesome.sliders, color: Color(kDark.value), size: 29.sp,)
            ],
          ),
        ),
      ),
    );
  }
}