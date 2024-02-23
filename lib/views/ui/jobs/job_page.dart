import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/models/request/applied/applied_post.dart';
import 'package:jobhub/models/request/bookmarks/bookmarks_model.dart';
import 'package:jobhub/models/response/jobs/get_job.dart';
import 'package:jobhub/services/firebase_services.dart';
import 'package:jobhub/services/helpers/applied_helper.dart';
import 'package:jobhub/services/helpers/jobs_helper.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/backBtn.dart';
import 'package:jobhub/views/common/custom_outline_btn.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/auth/login.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:jobhub/views/ui/jobs/agent_update_job.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/skills_provider.dart';
import '../../../models/response/auth/profile_model.dart';
import '../../../models/response/skills/skills.dart';
import '../../../services/helpers/auth_helper.dart';
import '../../common/loader.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key, required this.title, required this.id, required this.agentName, required this.agentPic});
  final String  title;
  final String id;
  final String agentName;
  final String agentPic;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  FirebaseServices services = FirebaseServices();
  late Future<GetJobRes> job;
  late Future<ProfileRes> userProfile;
  ProfileRes? profile;
  late Future<List<Skills>> userSkills;

  @override
  void initState() {
   getJob();
   getPrefs();
    super.initState();
  }

  getJob(){
    job = JobsHelper.getJob(widget.id);
    userProfile = AuthHelper.getProfile();
    userSkills = AuthHelper.getSkills();
  }
  getPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUid = prefs.getString('userUid') ?? '';
    userName = prefs.getString('username') ?? '';
    email = prefs.getString('email') ?? '';
    pdf = prefs.getString('pdfFromProfile') ?? '';
    print('pdf file = $pdf');
    mySkills = prefs.getString('ski') ?? '';
  }

  createChatFromJobPage(Map<String, dynamic> jobDetails, List<String> users, String chatRoomId, String profilePic, String messageType){
    Map<String, dynamic> chatData = {
      'users':users,
      'chatRoomId':chatRoomId,
      'read':false,
      'job':jobDetails,
      'profile':profilePic,
      'sender':userUid,
      'name':userName,
      'email':email,
      'agentName':widget.agentName,
      'agentPic':widget.agentPic,
      'messageType':messageType,
      'skills': mySkills,
      'pdf':pdf,
      'lastChat':'Start a conversation',
      'lastChatTime':Timestamp.now()
    };
    services.createChatRoom(chatData);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(builder: (context, jobNotifier, child){
      jobNotifier.getJob(widget.id);
      var loginNotifier = Provider.of<LoginNotifier>(context);
      var zoomNotifier = Provider.of<ZoomNotifier>(context);
      return Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(50.h),
            child: CustomAppBar(
              actions: [
                loginNotifier.loggedIn != false ?
                    Consumer<BookMarkNotifier>(builder: (context, bookmarkNotifier, child){
                      bookmarkNotifier.getBookmark(widget.id);
                      return GestureDetector(
                        onTap: (){
                          if(bookmarkNotifier.bookmarked == true){
                            bookmarkNotifier.deleteBookMark(bookmarkNotifier.bookmarkId);
                          } else {
                            BookmarkReqModel model = BookmarkReqModel(job: widget.id);
                            var newModel = bookmarkReqModelToJson(model);
                            bookmarkNotifier.addBookmark(newModel);
                          }
                        },
                        child: Padding(padding: EdgeInsets.only(right: 12.w),
                          child: Icon(bookmarkNotifier.bookmarked == false ?
                          Fontisto.bookmark : Fontisto.bookmark_alt),
                        ),
                      );
                    })
                    : const SizedBox.shrink(),
              ],
              child: const BackBtn(),
            )),
        body: buildStyleContainer(context,
            FutureBuilder(
                future: job,
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: Loader(text: 'Fetching job..'),);
                  } else if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final job = snapshot.data;
                    return Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Container(
                              width: Dimensions.width, height: Dimensions.height*0.27,
                              decoration: BoxDecoration(
                                color: Color(kLightGrey.value),
                                image: const DecorationImage(image: AssetImage('assets/images/job.png'), opacity: 0.2),
                                borderRadius: BorderRadius.all(Radius.circular(9.r)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30.r, backgroundImage: NetworkImage(job!.imageUrl),
                                  ),
                                  SizedBox(height: 10.h,),
                                  ReusableText(text: job.title,
                                      style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
                                  SizedBox(height: 5.h,),
                                  ReusableText(text: job.level,
                                      style: appstyle(15.sp, Colors.black54, FontWeight.w400)),
                                  SizedBox(height: 5.h,),
                                  ReusableText(text: job.location,
                                      style: appstyle(15.sp, Colors.black54, FontWeight.w400)),
                                  SizedBox(height: 5.h,),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 50.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomOutlineBtn(
                                          width: Dimensions.width*.26, height: Dimensions.height*.04,
                                          text: job.contract, color: Color(kOrange.value)),
                                      Row(
                                        children: [
                                          ReusableText(text: job.salary,
                                              style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
                                          ReusableText(text: "/${job.period}",
                                              style: appstyle(15.sp, Colors.black54, FontWeight.w400)),
                                        ],
                                      )
                                    ],
                                  ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            ReusableText(text: 'Description',
                                style: appstyle(15.sp, Color(kDark.value), FontWeight.w600)),
                            SizedBox(height: 10.h,),
                            Text(job.description,
                            textAlign: TextAlign.justify,
                              maxLines: 9,
                              style: appstyle(13.sp, Colors.black87, FontWeight.w400),
                            ),
                            SizedBox(height: 10.h,),
                            ReusableText(text: 'Requirements', style: appstyle(15.sp, Color(kDark.value), FontWeight.w600)),
                            SizedBox(height: 10.h,),
                            SizedBox(height: Dimensions.height*0.25,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                                itemCount: job.requirements.length,
                                itemBuilder: (context, index){
                                var requirement = job.requirements[index];
                              return Padding(padding: EdgeInsets.only(bottom: 12.h),
                              child: Text(requirement,
                              style: appstyle(13.sp, Colors.black87, FontWeight.w400),
                              ),
                              );
                            }),
                            ),
                          ],
                        ),
                        loginNotifier.loggedIn != false ?
                        FutureBuilder(
                          future: userProfile,
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return CustomOutlineBtn(
                                onTap: (){},
                                width: Dimensions.width*0.8,
                                text: 'Loading..',
                                height: Dimensions.height*0.06, color: Color(kLight.value), color2: Color(kLight.value),);
                            } else if(snapshot.hasError){
                              return Text('Error: ${snapshot.error}');
                            } else{
                              profile = snapshot.data;
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(padding: EdgeInsets.only(bottom: 20.h),
                                  child:
                                  profile!.isAgent ?
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomOutlineBtn(
                                        onTap: (){
                                          if(job.agentName==profile!.username){
                                            jobUpdate = job;
                                            Get.off(()=> const AgentUpdateJob());
                                          }else{
                                            Get.snackbar('Denied', 'You did not upload this job',
                                                backgroundColor: Color(kOrange.value), colorText: Color(kLight.value)
                                            );
                                          }},
                                        width: Dimensions.width*0.4,
                                        text: 'Edit Job',
                                        height: Dimensions.height*0.06, color: Color(kLight.value), color2: Color(kOrange.value),),
                                      CustomOutlineBtn(
                                        onTap: (){
                                          showDialog(context: context,
                                              barrierColor: context.theme.backgroundColor,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.transparent,
                                                  content: Center(
                                                    child: Column(
                                                      children: [
                                                        ReusableText(text: 'Are you sure?', style: appstyle(12.sp, Color(kDark.value), FontWeight.w500)),
                                                        SizedBox(height: 10.h,),
                                                        InkWell(
                                                          onTap: () {
                                                            if(job.agentName==profile!.username){
                                                              JobsHelper.deleteJob(job.id);
                                                              zoomNotifier.currentIndex = 0;
                                                              Get.offAll(()=> const MainScreen());
                                                            } else{
                                                              Get.snackbar('Denied', 'You did not upload this job',
                                                                  backgroundColor: Color(kOrange.value), colorText: Color(kLight.value)
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 20.h,
                                                            width: 70.w,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(10.r),
                                                              color: Color(kOrange.value),
                                                            ),
                                                            child: Center(
                                                              child: ReusableText(text: 'Yes', style: appstyle(12.sp, Color(kLight.value), FontWeight.w500)),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                          },
                                        width: Dimensions.width*0.4,
                                        text: 'Delete Job',
                                        height: Dimensions.height*0.06, color: Color(kOrange.value), color2: Color(kLight.value),),
                                    ],
                                  )
                                      :
                                  Consumer<SkillNotifier>(
                                          builder: (context, skillNotifier, child) {
                                            return CustomOutlineBtn(
                                              onTap: () async{
                                                Map<String, dynamic> jobDetails = {
                                                  'job_id':job.id,
                                                  'image_url':job.imageUrl,
                                                  'salary':'${job.salary} per ${job.period}',
                                                  'title':job.title,
                                                  'company':job.company,
                                                };

                                                List<String> users = [job.agentId, userUid];

                                                String chatRoomId = '${job.id}.$userUid';

                                                String messageType ='text';

                                                String profilePic = profile!.profile;

                                                bool doesChatExist = await services.chatRoomExist(chatRoomId);

                                                if(doesChatExist == false){

                                                  createChatFromJobPage(jobDetails, users, chatRoomId, profilePic, messageType,);

                                                  AppliedPost model = AppliedPost(job: job.id);
                                                  var newModel = appliedPostToJson(model);

                                                  AppliedHelper.applyJob(newModel);

                                                  zoomNotifier.currentIndex = 2;
                                                  Get.to(()=> const MainScreen());
                                                  print(mySkills);
                                                } else{
                                                  Get.snackbar('Applied', 'You already applied',
                                                      backgroundColor: Color(kOrange.value), colorText: Color(kLight.value)
                                                  );
                                                }
                                              },
                                              width: Dimensions.width*0.8,
                                              text: 'Apply',
                                              height: Dimensions.height*0.06, color: Color(kLight.value), color2: Color(kOrange.value),);
                                          },
                                        ),
                              ),
                            );
                            }
                          },
                        )
                            :
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(padding: EdgeInsets.only(bottom: 20.h),
                            child:
                            CustomOutlineBtn(
                                onTap: (){
                                  Get.to(()=> const LoginPage());},
                                text:'Sign up', width: Dimensions.width*0.8,
                                height: Dimensions.height*0.06, color: Color(kLight.value), color2: Color(kOrange.value))
                            ,
                          ),
                        )
                      ],
                    ),
                    );
                  }
                })),
      );
    });
  }
}