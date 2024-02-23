import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/views/common/reusable_text.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_constants.dart';
import '../ui/auth/profile.dart';
import 'app_style.dart';


class ShimmerChatWidget extends StatelessWidget {
  const ShimmerChatWidget.circle({
    Key? key, required this.height, required this.width,
  }) : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(99.r)),
                border: Border.all(
                    width: 1.w,
                )
            ),
        child: CircleAvatar(
          radius: 20.r, backgroundColor: Color(kLightGrey.value),),),
        SizedBox(height: 3.h,),
        Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: Color(kLightGrey.value),
                borderRadius: BorderRadius.all(Radius.circular(7.r))
            )
        )
      ],
    ),
  );
}

class ShimmerChatBoxWidget extends StatelessWidget {
  const ShimmerChatBoxWidget.square({
    Key? key, required this.height, required this.width,
  }) : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: FittedBox(
      child: Row(
        children: [
         CircleAvatar(radius: 20.r,backgroundColor: Color(kLightGrey.value),),
          SizedBox(width: 15.w,),
          Container(height: height, width: width,
          decoration: BoxDecoration(
            color: Color(kLightGrey.value),
            borderRadius: BorderRadius.all(Radius.circular(5.r))
          ),
          )
        ],
      ),
    ),
  );
}