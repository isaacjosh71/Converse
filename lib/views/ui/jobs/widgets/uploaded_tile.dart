import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub/models/response/jobs/get_job.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/views/common/custom_outline_btn.dart';

import '../../../../constants/app_constants.dart';
import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../job_page.dart';

class UploadedTile extends StatelessWidget {
  const UploadedTile({super.key, required this.job, required this.text});
  final JobsResponse job;
  final String text;

  @override
  Widget build(BuildContext context) {
    return  FittedBox(
      child: GestureDetector(
        onTap: (){Get.to(()=> JobPage(title: job.title, id: job.id, agentName: job.agentName));},
        child: Padding(padding: EdgeInsets.only(bottom: 8.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
            height: height*0.1, width: width,
            decoration: BoxDecoration(
                color: const Color(0x09000000),
                borderRadius: BorderRadius.all(Radius.circular(9.r))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: NetworkImage(job.imageUrl),
                        ),
                        SizedBox(width: 10.w,),
                        Column(
                          children: [
                            ReusableText(text: job.company, style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
                            SizedBox(width: width*0.5,
                                child: ReusableText(text: job.title, style: appstyle(12.sp, Color(kDarkGrey.value), FontWeight.w500))),
                            ReusableText(text: '${job.salary} per ${job.period}', style: appstyle(12.sp, Color(kDark.value), FontWeight.w500)),
                          ],
                        ),
                        text == 'popular' ?
                            CustomOutlineBtn(
                              width: 90.w, height: 36.h,
                                text: 'View', color: Color(kLightBlue.value))
                            :
                        CustomOutlineBtn(
                            width: 90.w, height: 36.h,
                            text: 'Applied', color: Color(kLightBlue.value))
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}