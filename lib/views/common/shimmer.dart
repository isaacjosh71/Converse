import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/app_constants.dart';


class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.rectangular({
    Key? key, required this.height, required this.width,
  }) : super(key: key);
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      width: width,
      height: height,
        decoration: BoxDecoration(
            color: Color(kLightGrey.value),
            borderRadius: BorderRadius.all(Radius.circular(9.r))
        )
    ),
  );
}
