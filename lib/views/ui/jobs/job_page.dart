import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:jobhub/views/common/page_loader.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:jobhub/views/ui/jobs/agent_update_job.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key, required this.title, required this.id, required this.agentName});
  final String  title;
  final String id;
  final String agentName;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  FirebaseServices services = FirebaseServices();
  late Future<GetJobRes> job;
  bool isAgent = false;

  @override
  void initState() {
   getJob();
   getPrefs();
    super.initState();
  }

  getJob(){
    job = JobsHelper.getJob(widget.id);
  }
  getPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool('isAgent') ?? false;
  }

  createChatFromJobPage(Map<String, dynamic> jobDetails, List<String> users, String chatRoomId,
      String messageType
      ){
    Map<String, dynamic> chatData = {
      'users':users,
      'chatRoomId':chatRoomId,
      'read':false,
      'job':jobDetails,
      'profile':profile,
      'sender':userUid,
      'name':userName,
      'agentName':widget.agentName,
      'messageType':messageType,
      'lastChat':'Hello, I\'m interested in this job',
      'lastChatTime':Timestamp.now()
    };
    services.createChatRoom(chatData);
  }

  @override
  Widget build(BuildContext context) {
    print(isAgent);
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
                          child: Icon(bookmarkNotifier.bookmarked ? Fontisto.bookmark : Fontisto.bookmark_alt),
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
                    return const PageLoader();
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
                              width: width, height: height*0.27,
                              decoration: BoxDecoration(
                                color: Color(kLightGrey.value),
                                image: const DecorationImage(image: AssetImage('assets/images/job.png'), opacity: 0.35),
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
                                      style: appstyle(16.sp, Color(kDark.value), FontWeight.w600)),
                                  SizedBox(height: 5.h,),
                                  ReusableText(text: job.location,
                                      style: appstyle(15.sp, Color(kDarkGrey.value), FontWeight.w600)),
                                  SizedBox(height: 5.h,),
                                  Padding(padding: EdgeInsets.symmetric(horizontal: 50.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomOutlineBtn(
                                          width: width*.26, height: height*.04,
                                          text: job.contract, color: Color(kOrange.value)),
                                      Row(
                                        children: [
                                          ReusableText(text: job.salary,
                                              style: appstyle(15.sp, Color(kDark.value), FontWeight.w600)),
                                          ReusableText(text: "/${job.period}",
                                              style: appstyle(15.sp, Color(kDarkGrey.value), FontWeight.w600)),
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
                                style: appstyle(16.sp, Color(kDark.value), FontWeight.w600)),
                            SizedBox(height: 10.h,),
                            Text(job.description,
                            textAlign: TextAlign.justify,
                              maxLines: 9,
                              style: appstyle(12.sp, Color(kDarkGrey.value), FontWeight.normal),
                            ),
                            SizedBox(height: 10.h,),
                            ReusableText(text: 'Requirements', style: appstyle(16.sp, Color(kDark.value), FontWeight.w600)),
                            SizedBox(height: 10.h,),
                            SizedBox(height: 6.h,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                                itemCount: job.requirements.length,
                                itemBuilder: (context, index){
                                var requirement = job.requirements[index];
                                String bullet = '\u2022';
                              return Padding(padding: EdgeInsets.only(bottom: 12.h),
                              child: Text('$bullet $requirement',
                              style: appstyle(12.sp, Color(kDarkGrey.value), FontWeight.normal),
                              ),
                              );
                            }),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(padding: EdgeInsets.only(bottom: 20.h),
                          child:
                          !isAgent ?
                          CustomOutlineBtn(
                              onTap: () async{
                                Map<String, dynamic> jobDetails = {
                                  'job_id':job.id,
                                  'image_url':job.imageUrl,
                                  'salary':'${job.salary} per ${job.period}',
                                  'title':job.title,
                                  'company':job.company,
                                };
                                List<String> users = [
                                  job.agentId, userUid
                                ];
                                String chatRoomId = '${job.id}.$userUid';
                                String messageType ='text';

                                bool doesChatExist = await services.chatRoomExist(chatRoomId);

                                if(doesChatExist == false){
                                  createChatFromJobPage(jobDetails, users, chatRoomId, messageType);

                                  AppliedPost model = AppliedPost(job: job.id);
                                  var newModel = appliedPostToJson(model);

                                  AppliedHelper.applyJob(newModel);

                                  zoomNotifier.currentIndex = 1;
                                  Get.to(()=> const MainScreen());
                                } else{

                                }
                              },
                              text: !loginNotifier.loggedIn ? 'Please login' : 'Apply',
                              height: height*0.06, color: Color(kOrange.value))
                            :
                          CustomOutlineBtn(
                              onTap: (){
                                jobUpdate = job;
                                Get.off(()=> const AgentUpdateJob());},
                              text:'Edit Job',
                              height: height*0.06, color: Color(kOrange.value))
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