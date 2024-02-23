import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/views/common/exports.dart';

class JobHorizontalTile extends StatelessWidget {
  const JobHorizontalTile({super.key, this.onTap, required this.job});
  final void Function()? onTap;
  final JobsResponse job;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(padding: EdgeInsets.only(right:12.w),
       child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        child: Container(
          height: Dimensions.height*0.3, width: Dimensions.width*0.7,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Color(kLightGrey.value),
            image: const DecorationImage(image: AssetImage(
              'assets/images/job.png'), fit: BoxFit.contain, opacity: 0.2)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage: NetworkImage(job.imageUrl),
                  ),
                  SizedBox(width: 15.h,),
                  Container(
                    width: 140.w,
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Color(kLight.value),
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    ),
                    child: ReusableText(text: job.company, style: appstyle(18.sp, Color(kDark.value), FontWeight.w500)),
                  )
                ],
              ),
              SizedBox(height: 5.h,),
              ReusableText(text: job.title, style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
              SizedBox(height: 5.h,),
              ReusableText(text: job.level, style: appstyle(14.sp, Colors.black54, FontWeight.normal)),
              SizedBox(height: 5.h,),
              ReusableText(text: job.location, style: appstyle(14.sp, Colors.black54, FontWeight.normal)),
              SizedBox(height: 5.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ReusableText(text: job.salary, style: appstyle(15.sp, Color(kDark.value), FontWeight.w500)),
                      ReusableText(text: "/${job.period}", style: appstyle(15.sp, Colors.black54, FontWeight.w400)),
                    ],
                  ),
                  CircleAvatar(
                    radius: 15.r,
                    backgroundColor: Color(kLight.value),
                    child: const Icon(Ionicons.chevron_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}