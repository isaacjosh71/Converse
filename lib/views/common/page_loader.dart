
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_constants.dart';

class PageLoader extends StatelessWidget {
  const PageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kLight.value),
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Center(
          child: Image.asset('assets/images/page_load.png'),
        ),
      ),
    );
  }
}
