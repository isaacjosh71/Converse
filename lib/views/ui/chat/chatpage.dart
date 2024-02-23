import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/agent_provider.dart';
import 'package:jobhub/models/request/agents/agents.dart';
import 'package:jobhub/services/firebase_services.dart';
import 'package:jobhub/services/helpers/agent_helper.dart';
import 'package:jobhub/services/notification_services.dart';
import 'package:jobhub/views/common/date.dart';
import 'package:jobhub/views/common/loader.dart';
import 'package:jobhub/views/common/vertical_tile.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:jobhub/views/ui/chat/conversation.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_constants.dart';
import '../../../controllers/login_provider.dart';
import '../../../models/response/auth/profile_model.dart';
import '../../../services/helpers/auth_helper.dart';
import '../../common/app_style.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/reusable_text.dart';
import '../agents/agent_details.dart';
import '../applications/applicant_details.dart';
import '../auth/non_user.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with TickerProviderStateMixin{
  late TabController tabs = TabController(length: 2, vsync: this);
  late Future<List<Agents>> agents;
  late Future<ProfileRes> userProfile;
  ProfileRes? profile;
  final notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    getAgents();
    getUserUid();
    notificationServices.firebaseNotification(context);
  }

  getAgents() {
    agents = AgentHelper.getAgents();
    userProfile = AuthHelper.getProfile();
  }

  getUserUid() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUid = prefs.getString('userUid') ?? '';
    userName = prefs.getString('username') ?? '';
  }

  FirebaseServices services = FirebaseServices();

  final Stream<QuerySnapshot> _chat = FirebaseFirestore.instance.collection('chats')
  .where('users', arrayContains: userUid)
  .snapshots();

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: !loginNotifier.loggedIn ? Color(kLight.value) : const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: loginNotifier.loggedIn == false ?
        Color(kLight.value)
        : const Color(0xFF171717),
        elevation: 0,
        leading: Padding(padding: EdgeInsets.all(12.w),
          child: DrawerWidget(color: !loginNotifier.loggedIn ? Color(kDark.value) : Color(kLight.value)),
      ),
        title: loginNotifier.loggedIn == false ? const SizedBox() :
        TabBar(
          indicator: BoxDecoration(
            color: const Color(0x00BABABA),
            borderRadius: BorderRadius.all(Radius.circular(25.r)),
          ), labelColor: Color(kLight.value),
        unselectedLabelColor: Colors.grey.withOpacity(.5),
        padding: EdgeInsets.all(3.w),
        labelStyle: appstyle(12.sp, Color(kLight.value), FontWeight.w500),
        controller: tabs,
          tabs: const [
            Tab(
              text: 'MESSAGE',
            ),
            Tab(
              text: 'GROUP',
            ),
          ],
        ),
      ),
       body: loginNotifier.loggedIn == false ? const NonUser() :
           TabBarView(
               controller: tabs,
               children: [
                 FutureBuilder(
                   future: userProfile,
                     builder: (context, snapshot) {
                       if(snapshot.connectionState == ConnectionState.waiting){
                         return const SizedBox.shrink();
                       } else if(snapshot.hasError){
                         return Text('Error: ${snapshot.error}');
                       } else{
                     profile = snapshot.data;
                   return Stack(
                     children: [
                       !profile!.isAgent ?
                       Positioned(
                           top: 10.h, left: 0.w, right: 0.w,
                           child: Container(
                             padding: EdgeInsets.only(left: 25.w, top: 15.h, right: 0.w),
                             height: 200.h,
                             decoration: BoxDecoration(
                               color: Color(kNewBlue.value),
                               borderRadius: BorderRadius.only(
                                 topRight: Radius.circular(20.r),
                                 topLeft: Radius.circular(20.r)
                               )
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 SizedBox(height: 2.h,),
                                 ReusableText(text: 'Agents and Companies',
                                     style: appstyle(12.sp, Color(kLight.value), FontWeight.normal)),
                                 SizedBox(height: 23.h,),
                                 Consumer<AgentNotifier>(
                                   builder: (context, agentNotifier, child) {
                                     return FutureBuilder<List<Agents>>(
                                         future: agents,
                                         builder: (context, snapshot){
                                           if(snapshot.connectionState == ConnectionState.waiting){
                                             return buildShimmer();
                                           }else if(snapshot.hasError){
                                             return Text('Error: ${snapshot.error}');
                                           }else{
                                             var data = snapshot.data;
                                             return SizedBox(
                                               height: 140.h,
                                               child: ListView.builder(
                                                   scrollDirection: Axis.horizontal,
                                                   itemCount: data!.length,
                                                   itemBuilder: (context, index){
                                                     var agent = snapshot.data![index];
                                                     return GestureDetector(
                                                         onTap: (){
                                                           agentNotifier.agents = agent;
                                                           Get.to(()=> const AgentDetails());
                                                         },
                                                         child: buildAgentAvatar(
                                                             agent.username,
                                                             agent.profile
                                                         )
                                                     );
                                                   }),
                                             );
                                           }
                                         });
                                   },
                                 )
                               ],
                             ),
                           ))
                       :
                       Positioned(
                           top: 10.h, left: 0.w, right: 0.w,
                           child: Container(
                             padding: EdgeInsets.only(left: 25.w, top: 15.h, right: 0.w),
                             height: 200.h,
                             decoration: BoxDecoration(
                                 color: Color(kNewBlue.value),
                                 borderRadius: BorderRadius.only(
                                     topRight: Radius.circular(20.r),
                                     topLeft: Radius.circular(20.r)
                                 )
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 SizedBox(height: 2.h,),
                                 ReusableText(text: 'Applicants',
                                     style: appstyle(12.sp, Color(kLight.value), FontWeight.normal)),
                                 SizedBox(height: 23.h,),
                             SizedBox(height: 140.h,
                                           child: StreamBuilder<QuerySnapshot>(
                                             stream: _chat,
                                             builder: (context, snapshot) {
                                                 if (snapshot.hasError){
                                                   return Text('Error: ${snapshot.error}');
                                                 } else if(snapshot.connectionState == ConnectionState.waiting){
                                                   return buildShimmer();
                                                 } else if(snapshot.data!.docs.isEmpty){
                                                   return Center(child: ReusableText(text: 'No Applicants Yet', style: appstyle(12.sp, Color(kLight.value), FontWeight.w500)),);
                                                 } else{
                                                   final chatList = snapshot.data!.docs;
                                               return Consumer<AgentNotifier>(
                                                 builder: (context, agentNotifier, child) {
                                                   return ListView.builder(
                                                       scrollDirection: Axis.horizontal,
                                                       itemCount: chatList.length,
                                                       itemBuilder: (context, index){
                                                         final chats = chatList[index].data() as Map<String, dynamic>;
                                                         return GestureDetector(
                                                             onTap: (){
                                                               agentNotifier.chat = chats;
                                                               Get.to(()=> const ApplicantDetails());
                                                             },
                                                             child: buildAgentAvatar(
                                                                 chats['name'],
                                                                 chats['profile']
                                                             )
                                                         );
                                                       });
                                                 },
                                               );
                                             }}
                                           ),
                                         )
                               ],
                             ),
                           )),
                       Positioned(
                           top: 150.h, left: 0.w, right: 0.w,
                           child: Container(
                             height: Dimensions.height, width: Dimensions.width,
                             decoration: BoxDecoration(
                                 color: Color(kGreen.value),
                                 borderRadius: BorderRadius.only(
                                     topRight: Radius.circular(20.r),
                                     topLeft: Radius.circular(20.r)
                                 )
                             ),
                             child: StreamBuilder<QuerySnapshot>(
                                 stream: _chat,
                                 builder: (context, snapshot){
                                   if (snapshot.hasError){
                                     return Text('Error: ${snapshot.error}');
                                   } else if(snapshot.connectionState == ConnectionState.waiting){
                                     return const Center(child: Loader(text: 'Fetching chats..'),);
                                   } else if(snapshot.data!.docs.isEmpty){
                                     return const Center(child: Loader(text: 'No chats found'),);
                                   } else{
                                     final chatList = snapshot.data!.docs;
                                     return ListView.builder(
                                       padding: EdgeInsets.only(left: 10.w, top: 10.h),
                                         shrinkWrap: true,
                                         itemCount: chatList.length,
                                         itemBuilder: (context, index){
                                         final chats = chatList[index].data() as Map<String, dynamic>;
                                         Timestamp lastChatTime = chats['lastChatTime'];
                                         DateTime lastChatDateTime = lastChatTime.toDate();
                                         return Consumer<AgentNotifier>(
                                             builder: (context, agentNotifier, child){
                                           return GestureDetector(
                                             onLongPress: (){
                                               showDialog(context: context,
                                                   barrierColor: context.theme.backgroundColor,
                                                   builder: (context) {
                                                     return AlertDialog(
                                                       backgroundColor: Colors.transparent,
                                                       content: Column(
                                                         children: [
                                                           ReusableText(text: 'Delete conversation?', style: appstyle(13.sp, Color(kDark.value), FontWeight.w600)),
                                                           SizedBox(height: 10.h,),
                                                           InkWell(
                                                             onTap: () {
                                                               setState(() {
                                                                 FirebaseFirestore.instance.collection('chats')
                                                                     .doc(chats['chatRoomId']).delete().
                                                                 then((value) =>
                                                                     Get.off(()=> const MainScreen())
                                                                 );
                                                               });
                                                             },
                                                             child: Container(
                                                               height: 30.h,
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
                                                     );
                                                   });
                                             },
                                             onTap: (){
                                               if(chats['sender'] != userUid){
                                                 services.updateCount(chats['chatRoomId']);
                                               }else{}
                                               agentNotifier.chat = chats;
                                               Get.to(()=> const ConversationPage());
                                             },
                                             child: buildChatRow(
                                                     userName == chats['name'] ? chats['agentName'] : chats['name'],
                                                     chats['lastChat'],
                                                     profile!.profile == chats['profile'] ? chats['agentPic'] : chats['profile'],//static
                                                     chats['sender'] != userUid ?
                                                     chats['read'] == false ? 1 : 0
                                                         : chats['read'] == false ? 0 : 0,
                                                     lastChatDateTime
                                                 ),
                                           );
                                         });
                                     });
                                   }
                                 }),
                           ))
                     ],
                   );}}
                 ),
                 Container(
                   height: Dimensions.height, width: Dimensions.width,
                   color: Colors.white,
                   child: Center(
                     child: ReusableText(text: 'Coming soon...', style: appstyle(17.sp, Colors.black87, FontWeight.normal)),
                   ),
                 ),
               ]),
    );
  }

  Padding buildAgentAvatar(String name, String imageName){
    return Padding(padding: EdgeInsets.only(right: 20.w),
    child: Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(99.r)),
              border: Border.all(
                width: 1.w, color: Color(kLight.value)
              )
            ),
            child: CircularProfileAvatar(image: imageName, w: 50.w, h: 50.h)),
        SizedBox(height: 3.h,),
        ReusableText(text: name, style: appstyle(11.sp, Color(kLight.value), FontWeight.normal))
      ],
    ),
    );
  }

  Column buildChatRow(String name, String message, String fileName, int msgCount, time){
    return Column(
      children: [
        FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircularProfileAvatar(image: fileName, w: 50.w, h: 50.h),
                  SizedBox(width: 15.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(text: name, style: appstyle(12.sp, Colors.grey, FontWeight.w400)),
                      const SizedBox(height: 5,),
                      SizedBox(
                          width: Dimensions.width*0.65,
                          child: ReusableText(text: message, style: appstyle(12.sp, Colors.grey, FontWeight.w400))),
                    ],
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 5.h),
               child: Column(
                children: [
                  ReusableText(text: timeLineFormat(time), style: appstyle(10.sp, Colors.black, FontWeight.normal)),
                  SizedBox(height: 15.h,),
                  if(msgCount>0)
                    CircleAvatar(
                      radius: 7.r,
                      backgroundColor: Color(kNewBlue.value),
                      child: ReusableText(text: msgCount.toString(), style: appstyle(8.sp, Color(kLight.value), FontWeight.w400)),
                    )
                ],
              ),
              )
            ],
          ),
        ),
        Divider(
          indent: 70.h, height: 20.h,
        )
      ],
    );
  }
}

Widget buildShimmer()=> SizedBox(
  height: 140.h,
  child:   ListView.builder(
    itemCount: 6,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index){
      return Padding(padding: EdgeInsets.only(right: 20.w),
        child: ShimmerChatWidget.circle(height: 7.h, width: 21.w),
      );
    },
  ),
);

// Widget buildChatShimmer()=> ListView.builder(
//   itemCount: 5,
//   scrollDirection: Axis.vertical,
//   itemBuilder: (context, index){
//     return Padding(padding: EdgeInsets.only(right: 20.w),
//       child: ShimmerChatBoxWidget.square(height: 40.h, width: Dimensions.width*0.65),
//     );
//   },
// );