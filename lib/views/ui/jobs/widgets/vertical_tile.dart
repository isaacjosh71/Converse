import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/ui/jobs/job_page.dart';

class JobVerticalTile extends StatelessWidget {
  const JobVerticalTile({super.key, required this.job});
  final JobsResponse job;

  @override
  Widget build(BuildContext context) {
    return  FittedBox(
      child: GestureDetector(
        onTap: (){Get.to(()=> JobPage(title: job.title, id: job.id, agentName: job.agentName, agentPic: job.agentPic));},
        child: Padding(padding: EdgeInsets.only(bottom: 10.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
          height: Dimensions.height*0.12, width: Dimensions.width,
          decoration: BoxDecoration(
            color: Color(kLightGrey.value),
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
                        radius: 25.r,
                        backgroundImage: NetworkImage(job.imageUrl),
                      ),
                      SizedBox(width: 10.w,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(text: job.company, style: appstyle(17.sp, Color(kDark.value), FontWeight.w500)),
                          SizedBox(height: 6.h,),
                          SizedBox(width: Dimensions.width*0.5,
                              child: ReusableText(text: job.title, style: appstyle(15.sp, Color(kDark.value), FontWeight.w500))),
                          SizedBox(height: 6.h,),
                          Row(
                            children: [
                              ReusableText(text: '${job.salary} ', style: appstyle(14.sp, Color(kDark.value), FontWeight.normal)),
                              ReusableText(text: 'per ${job.period}', style: appstyle(14.sp, Color(kDarkGrey.value), FontWeight.normal)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Color(kLight.value),
                    child: const Icon(Ionicons.chevron_forward),
                  )
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
