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
      child: GestureDetector(
        onTap: (){
          Get.to(()=> JobPage(title: bookmark.job.title, id: bookmark.job.id, agentName: bookmark.job.agentName));
          },
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
                          backgroundImage: NetworkImage(bookmark.job.imageUrl),
                        ),
                        SizedBox(width: 10.w,),
                        Column(
                          children: [
                            ReusableText(text: bookmark.job.title, style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
                            SizedBox(width: width*0.5,
                                child: ReusableText(text: bookmark.job.title, style: appstyle(12.sp, Color(kDarkGrey.value), FontWeight.w500))),
                            ReusableText(text: '${bookmark.job.salary} per ${bookmark.job.period}', style: appstyle(12.sp, Color(kDark.value), FontWeight.w500)),
                          ],
                        ),
                        CustomOutlineBtn(
                            width: 90.w, height: 36.h,
                            text: 'View', color: Color(kLightBlue.value))
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
