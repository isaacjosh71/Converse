import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/agent_provider.dart';
import 'package:jobhub/models/request/agents/agents.dart';
import 'package:jobhub/services/firebase_services.dart';
import 'package:jobhub/views/common/date.dart';
import 'package:jobhub/views/common/loader.dart';
import 'package:jobhub/views/common/page_loader.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:jobhub/views/ui/chat/conversation.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../controllers/login_provider.dart';
import '../../common/app_style.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/reusable_text.dart';
import '../agents/agent_details.dart';
import '../auth/non_user.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with TickerProviderStateMixin{
  late TabController tabs = TabController(length: 3, vsync: this);
  String imageUrl = 'https://d326fntlu7tb1e.cloudfront.net/uploads/b8bac89b-b85d-4ead-bb9e-57c96e03a08b-vinci_02.jpg'; //get a network image

  FirebaseServices services = FirebaseServices();

  final Stream<QuerySnapshot> _chat = FirebaseFirestore.instance.collection('chats')
  .where('users', arrayContains: userUid)
  .snapshots();

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        leading: Padding(padding: EdgeInsets.all(12.w),
          child: DrawerWidget(color: Color(kLight.value)),
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
              text: 'ONLINE',
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
                 Stack(
                   children: [
                     Positioned(
                         top: 20.h, left: 0.w, right: 0.w,
                         child: Container(
                           padding: EdgeInsets.only(left: 25.w, top: 15.h, right: 0.w),
                           height: 220.h,
                           decoration: BoxDecoration(
                             color: Color(kNewBlue.value),
                             borderRadius: BorderRadius.only(
                               topRight: Radius.circular(20.r),
                               topLeft: Radius.circular(20.r)
                             )
                           ),
                           child: Column(
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   ReusableText(text: 'Agents and Companies',
                                       style: appstyle(12.sp, Color(kLight.value), FontWeight.normal)),
                                   IconButton(onPressed: (){}, icon: Icon(AntDesign.ellipsis1, color: Color(kLight.value),))
                                 ],
                               ),
                               Consumer<AgentNotifier>(builder: (context, agentsNotifier, child){
                                 var agents = agentsNotifier.getAgents();
                                 return FutureBuilder<List<Agents>>(future: agents,
                                     builder: (context, snapshot){
                                   if(snapshot.connectionState == ConnectionState.waiting){
                                     return SizedBox(height: 90.h,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 7,
                                              itemBuilder: (context, index){
                                                return GestureDetector(
                                                    onTap: (){},
                                                    child: buildAgentAvatar(
                                                        'Agent $index',
                                                        imageUrl
                                                    )
                                                );
                                              }),);
                                   }else if(snapshot.hasError){
                                     return Text('Error: ${snapshot.error}');
                                   }else{
                                     return SizedBox(
                                       height: 90.h,
                                       child: ListView.builder(
                                         scrollDirection: Axis.horizontal,
                                           itemCount: snapshot.data!.length,
                                           itemBuilder: (context, index){
                                             var agent = snapshot.data![index];
                                         return GestureDetector(
                                           onTap: (){
                                             agentsNotifier.agents = agent;
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
                               })
                             ],
                           ),
                         )),
                     Positioned(
                         top: 150.h, left: 0.w, right: 0.w,
                         child: Container(
                           height: height, width: width,
                           decoration: BoxDecoration(
                               color: Color(kLight.value),
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
                                   return const PageLoader();
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
                                               chats['profile'],
                                               chats['read'] == true ? 0 : 1,
                                               lastChatDateTime
                                           ),
                                         );
                                       });
                                   });
                                 }
                               }),
                         ))
                   ],
                 ),
                 Container(
                   height: height, width: width,
                   color: Colors.black,
                 ),
                 Container(
                   height: height, width: width,
                   color: Colors.black,
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
        SizedBox(height: 5.h,),
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
                          width: width*0.65,
                          child: ReusableText(text: msgCount.toString(), style: appstyle(12.sp, Colors.grey, FontWeight.w400))),
                    ],
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(right: 10.w, left: 15.w, top: 5.h),
               child: Column(
                children: [
                  ReusableText(text: timeLineFormat(time), style: appstyle(10.sp, Colors.black, FontWeight.normal)),
                  const SizedBox(height: 15,),
                  if(msgCount>0)
                    CircleAvatar(
                      radius: 7.r,
                      backgroundColor: Color(kNewBlue.value),
                      child: ReusableText(text: name, style: appstyle(12.sp, Colors.grey, FontWeight.w400)),
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