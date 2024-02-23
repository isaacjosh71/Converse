import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/services/helpers/jobs_helper.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/response/auth/profile_model.dart';
import '../../../models/response/jobs/jobs_response.dart';
import '../../../services/helpers/auth_helper.dart';
import '../jobs/joblist.dart';
import '../jobs/recent_joblist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<JobsResponse>> recentJobs;
  late Future<List<JobsResponse>> getAllJobs;
  String img = '';
  late Future<ProfileRes> userProfile;
  ProfileRes? profile;

  getProfile(){
      userProfile = AuthHelper.getProfile();
  }

  @override
  void initState(){
    super.initState();
    getJobs();
    getProfile();
  }

  Future getJobs() async{
    recentJobs = JobsHelper.getRecent();
    getAllJobs = JobsHelper.getJobs();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ski', mySkills);
    await prefs.setString('pdfFromProfile', pdfUrlFromProfile);
    print('skills profile $mySkills');
    print('skills pdf $pdfUrlFromProfile');
  }

  String imageUrl = 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTAxL3JtNjA5LXNvbGlkaWNvbi13LTAwMi1wLnBuZw.png';
  
  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    loginNotifier.getPref();
    return Scaffold(
      backgroundColor: Color(kLight.value),
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
                      child: loginNotifier.loggedIn ?
                      FutureBuilder(
                        future: userProfile,
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return const CircularProgressIndicator.adaptive();
                          } else if(snapshot.hasError){
                          return Text('Error: ${snapshot.error}');
                          }else{
                          profile = snapshot.data;
                          return ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50.r)),
                          child: CachedNetworkImage(
                          height: 35.h, width: 30.w,
                          imageUrl: profile!.profile,
                          fit: BoxFit.cover
                          ),
                          );
                          }
                          },
                          )
                              :
                          ClipRRect(
                           borderRadius: BorderRadius.all(Radius.circular(50.r)),
                           child: CachedNetworkImage(
                           height: 30.h, width: 30.w,
                           imageUrl: imageUrl,
                            fit: BoxFit.cover
                        ),
                      )
                  ),
                )
              ],
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: DrawerWidget(color: Color(kDark.value),),
              ))),
      body: RefreshIndicator(
        onRefresh: getJobs,
        child: SafeArea(
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
                    Get.to(()=> const PopularJobList());
                  }),
                  SizedBox(height: 10.h,),
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      child: const PopularJobs()),
                  SizedBox(height: 15.h,),
                  HeadingWidget(text: 'Recently Posted', onTap: (){
                    Get.to(()=> const RecentJobList());
                  }),
                  SizedBox(height: 10.h,),
                  const RecentJob()
                ],
              ),
              ),
            )
        ),
      ),
    );
  }
}