import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhub/models/response/jobs/get_job.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/views/common/custom_outline_btn.dart';

import '../../../../constants/app_constants.dart';
import '../../../../models/request/bookmarks/bookmarks_model.dart';
import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../../jobs/job_page.dart';
// import '../job_page.dart';

class BookmarkTile extends StatelessWidget {
  const BookmarkTile({super.key, required this.bookmark});
  final AllBookmarks bookmark;

  @override
  Widget build(BuildContext context) {
    return  FittedBox(
      child: Padding(padding: EdgeInsets.only(bottom: 8.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
          height: Dimensions.height*0.1, width: Dimensions.width,
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
                        radius: 25.r,
                        backgroundImage: NetworkImage(bookmark.job.imageUrl),
                      ),
                      SizedBox(width: 10.w,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(text: bookmark.job.company, style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
                          SizedBox(height: 5.h,),
                          SizedBox(width: Dimensions.width*0.5,
                              child: ReusableText(text: bookmark.job.title, style: appstyle(14.sp, Color(kDarkGrey.value), FontWeight.w500))),
                          Row(
                            children: [
                              ReusableText(text: '${bookmark.job.salary} ', style: appstyle(12.sp, Color(kDark.value), FontWeight.normal)),
                              ReusableText(text: 'per ${bookmark.job.period}', style: appstyle(12.sp, Color(kDarkGrey.value), FontWeight.normal)),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: (){
                            Get.to(()=> JobPage(title: bookmark.job.title, id: bookmark.job.id, agentName: bookmark.job.agentName, agentPic: bookmark.job.agentPic));
                          },
                        child: CustomOutlineBtn(
                            width: 70.w, height: 35.h,
                            text: 'View', color: Color(kLightBlue.value)),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
