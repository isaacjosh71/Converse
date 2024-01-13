import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/services/helpers/auth_helper.dart';
import 'package:jobhub/views/common/backBtn.dart';
import 'package:jobhub/views/common/page_loader.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/auth/skills.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/app_constants.dart';
import '../../../models/response/auth/profile_model.dart';
import '../../common/app_bar.dart';
import '../../common/app_style.dart';
import '../../common/custom_outline_btn.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/reusable_text.dart';
import '../jobs/add_jobs_profile.dart';
import 'non_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.drawer});
  final bool drawer;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ProfileRes> userProfile;
  String username = '';
  String profilePic = '';
  late  ProfileRes? profile;
  String image = 'https://d326fntlu7tb1e.cloudfront.net/uploads/b8bac89b-b85d-4ead-bb9e-57c96e03a08b-vinci_02.jpg';

  @override
  void initState(){
    super.initState();
    getProfile();
    getName();
  }

  getProfile(){
    var loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    if(widget.drawer == false && loginNotifier.loggedIn == true){
      userProfile = AuthHelper.getProfile();
    } else if(widget.drawer == true && loginNotifier.loggedIn == true){
      userProfile = AuthHelper.getProfile();
    }else{}
  }

  getName() async{
    var loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(widget.drawer == false && loginNotifier.loggedIn == true){
      username = prefs.getString('username')??'';
      profilePic = prefs.getString('profile')??'';
    } else if(widget.drawer == true && loginNotifier.loggedIn == true){
      username = prefs.getString('username')??'';
      profilePic = prefs.getString('profile')??'';
    }else{}
  }



  @override
  Widget build(BuildContext context) {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            color: Color(kNewBlue.value),
            text: loginNotifier.loggedIn ? username.toUpperCase() : '',
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: widget.drawer == false ? const BackBtn() : DrawerWidget(color: Color(kLight.value),),
              ))),
          body: loginNotifier.loggedIn == false ? const NonUser() :
          Stack(
            children: [
              Positioned(
                  top: 0, right: 0, bottom: 0, left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                    height: 80.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                        color: Color(kLightBlue.value)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProfileAvatar(image: profilePic ==''?  image: profilePic,
                                w: 50.w, h: 50.h),
                            SizedBox(width: 10.w,),
                            SizedBox(
                              height: 50.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(7.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white30,
                                          borderRadius: BorderRadius.all(Radius.circular(20.r))
                                      ),
                                      child: ReusableText(text: profile == null ?'User email':profile!.email,
                                          style: appstyle(14.sp, Color(kDarkGrey.value), FontWeight.w400))),
                                ],
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){},
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Icon(Feather.edit, color: Color(kLight.value),),
                          ),
                        )
                      ],
                    ),
                  )),
              Positioned(
                right: 0, left: 0, bottom: 0, top: 90.w,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                    color: Color(kLight.value)
                  ),
                  child: FutureBuilder(future: userProfile,
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const PageLoader();
                        } else if(snapshot.hasError){
                          return Text('Error: ${snapshot.error}');
                        }else{
                          profile = snapshot.data;
                        return buildStyleContainer(
                          context,
                          ListView(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            children: [
                              SizedBox(height: 30.h),
                              ReusableText(text: 'Profile', style: appstyle(15.sp, Color(kDark.value), FontWeight.bold)),
                              SizedBox(height: 10.h),
                              Stack(
                                children: [
                                  Container(
                                    width: width,
                                    height: height*0.12,
                                    decoration: BoxDecoration(
                                        color: Color(kLightGrey.value), borderRadius: BorderRadius.all(Radius.circular(12.r))
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 12.w),
                                          width: 60.w, height: 70.h,
                                          color: Color(kLight.value),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(12.r))
                                          ),
                                          child: Icon(FontAwesome5Regular.file_pdf, color: Colors.red, size: 40.sp,),
                                        ),
                                        SizedBox(width: 20.w,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ReusableText(text: 'Upload your resume', style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
                                            FittedBox(
                                              child: Text('Please make sure you upload your resume in PDF format',
                                                style: appstyle(8.sp, Color(kDarkGrey.value), FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 1.w,)
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      width: 0.w,
                                      child: EditButton(
                                          onTap:(){}
                                      ))
                                ],
                              ),
                              SizedBox(height: 20.h,),
                              const SkillsWidget(),
                              SizedBox(height: 20.h,),
                              profile!.isAgent? /////
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(text: 'Agent Section',
                                      style: appstyle(14.sp, Color(kDark.value), FontWeight.w600)),
                                  SizedBox(height: 10.h),
                                  CustomOutlineBtn(text: 'Upload Job',
                                    onTap: (){
                                    Get.to(()=> const AddJobsFromProfile());
                                    },
                                    color: Color(kOrange.value), width: width, height: 40.h,),
                                  SizedBox(height: 10.h),
                                  CustomOutlineBtn(text: 'Update Information',
                                    onTap: (){},
                                    color: Color(kOrange.value), width: width, height: 40.h,),
                                ],
                              )
                                  :
                              CustomOutlineBtn(text: 'Apply to become an agent', color: Color(kOrange.value)),
                              SizedBox(height: 20.h),
                              CustomOutlineBtn(text: 'Proceed to logout',
                                onTap: (){
                                  zoomNotifier.currentIndex = 0;
                                  loginNotifier.logOut();
                                  Get.to(()=> const MainScreen());
                                },
                                color: Color(kOrange.value), width: width, height: 40.h,)
                            ],
                          ),
                        );
                        }
                      }),
                ),
              ),
            ]
          )
    );
  }
}

class CircularProfileAvatar extends StatelessWidget {
  const CircularProfileAvatar({super.key, required this.image, required this.w, required this.h});
  final String image;
  final double w; final double h;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(99.r)),
      child: CachedNetworkImage(imageUrl: image, width: w, height: h, fit: BoxFit.cover,
      placeholder: (context, url)=> const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
        errorWidget: (context, url, error)=> const Icon(Icons.error),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Color(kOrange.value),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(9.r), bottomLeft: Radius.circular(9.r),
          )
        ),
        child: ReusableText(text: 'Edit', style: appstyle(12.sp, Color(kLight.value), FontWeight.w500)),
      ),
    );
  }
}

