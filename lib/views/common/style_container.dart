import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildStyleContainer(BuildContext context, Widget child){
  return Container(
    decoration: BoxDecoration(
      image: const DecorationImage(image: AssetImage('assets/images/job.png'),
      fit: BoxFit.cover, opacity: 0.35
      ), borderRadius: BorderRadius.all(Radius.circular(9.r))
    ),
    child: child,
  );
}