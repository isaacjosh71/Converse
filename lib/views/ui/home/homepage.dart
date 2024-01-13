import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/drawer/drawer_widget.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/heading_widget.dart';
import 'package:jobhub/views/common/search.dart';
import 'package:jobhub/views/ui/auth/login.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jobhub/views/ui/jobs/widgets/popular_job_list.dart';
import 'package:jobhub/views/ui/jobs/widgets/popular_jobs.dart';
import 'package:jobhub/views/ui/jobs/widgets/recent_jobs.dart';
import 'package:jobhub/views/ui/search/searchpage.dart';
import 'package:provider/provider.dart';

import '../jobs/joblist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageUrl = 'https://d326fntlu7tb1e.cloudfront.net/uploads/b8bac89b-b85d-4ead-bb9e-57c96e03a08b-vinci_02.jpg';
  
  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    loginNotifier.getPref();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            actions: [
              Padding(
                padding: EdgeInsets.all(12.h),
                child: GestureDetector(
                  onTap: (){
                    loginNotifier.loggedIn == true ?
                    Get.to(()=> const ProfilePage(drawer: false)) :
                        Get.to(()=> const LoginPage());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50.r)),
                    child: CachedNetworkImage(
                        height: 25.h, width: 25.w,
                        imageUrl: imageUrl,
                        fit: BoxFit.cover
                    ),
                  ),
                ),
              )
            ],
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: DrawerWidget(color: Color(kDark.value),),
              ))),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Search\nFind and Apply',
                style: appstyle(30.sp, Color(kDark.value), FontWeight.bold),
                ),
                SizedBox(height: 20.h,),
                SearchWidget(onTap: (){
                  Get.to(()=> const SearchPage());
                },),
                SizedBox(height: 15.h,),
                HeadingWidget(text: 'Popular Jobs', onTap: (){
                  Get.to(()=> const JobList());
                }),
                SizedBox(height: 10.h,),
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                    child: const PopularJobs()),
                SizedBox(height: 15.h,),
                HeadingWidget(text: 'Recently Posted', onTap: (){
                  Get.to(()=> const JobList());
                  //work on recent joblistpage
                }),
                SizedBox(height: 10.h,),
                const RecentJob()
              ],
            ),
            ),
          )
      ),
    );
  }
}