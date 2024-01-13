import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/controllers/agent_provider.dart';
import 'package:jobhub/services/firebase_services.dart';
import 'package:jobhub/views/common/backBtn.dart';
import 'package:jobhub/views/common/date.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:jobhub/views/ui/chat/widgets/chatleftitem.dart';
import 'package:jobhub/views/ui/chat/widgets/chatrightitem.dart';
import 'package:jobhub/views/ui/chat/widgets/messaging_textfield.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  FirebaseServices services = FirebaseServices();
  TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  final itemController = ItemScrollController();
  var uuid = Uuid();

  String imageUrl = 'https://d326fntlu7tb1e.cloudfront.net/uploads/b8bac89b-b85d-4ead-bb9e-57c96e03a08b-vinci_02.jpg';

  sendMessage(){
    var chat = Provider.of<AgentNotifier>(context, listen: false).chat;

    Map<String, dynamic> message = {
      'message' : messageController.text,
      'messageType':'text',
      'profile':profile,
      'sender':userUid,
      'id':uuid.v4(),
      'time':Timestamp.now()
    };
    services.createChat(chat['chatRoomId'], message);
    messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    String chatRoomId = Provider.of<AgentNotifier>(context, listen: false).chat['chatRoomId'];

    final Stream<QuerySnapshot> typingStatus = FirebaseFirestore.instance.
    collection('typing')
    .doc(chatRoomId)
    .collection('typing')
    .snapshots();

    final Stream<QuerySnapshot> chats = FirebaseFirestore.instance.
    collection('chats')
    .doc(chatRoomId)
    .collection('messages')
    .orderBy('time')
    .snapshots();

    return Scaffold(
      backgroundColor: Color(kLight.value),
      appBar: AppBar(
        backgroundColor: Color(kLight.value),
        elevation: 0,
        leading: Padding(padding: EdgeInsets.all(12.w),
        child: const BackBtn(),
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 15.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(stream: typingStatus,
                      builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Text('Error: ${snapshot.error}');
                    }else if(snapshot.connectionState == ConnectionState.waiting){
                      return const SizedBox.shrink();
                    } else if (snapshot.data!.docs.isEmpty){
                      return const Text('');
                    }
                    List<String> documentIds = snapshot.data!.docs.map((doc) => doc.id).toList();
                    return ReusableText(text: documentIds.isNotEmpty && !documentIds.contains(userUid)
                        ? 'typing...' : '',
                        style: appstyle(9.sp, Colors.black54, FontWeight.normal));
                      }),
                  ReusableText(text: 'online', style: appstyle(9.sp, Colors.green.shade600, FontWeight.normal))
                ],
              ),
              Stack(
                children: [
                  CircularProfileAvatar(image: imageUrl, w: 30.w, h: 30.h),
                  Positioned(child: CircleAvatar(backgroundColor: Colors.green.shade600, radius: 4.r,))
                ],
              )
            ],
          ),
          )
        ],
      ),
      body: SafeArea(child: Stack(
        children: [
          Positioned(child: Container(
            padding: EdgeInsets.only(left: 5.w, top: 10.h, right:20.w),
            width: width, height: 120.h,
            decoration: BoxDecoration(
              color: Color(kNewBlue.value),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r)
              )
            ),
            child: Column(
              children: [
                Consumer<AgentNotifier>(builder: (context, agentNotifier, child){
                  var jobDetails = agentNotifier.chat['job'];
                  return Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReusableText(text: 'Company', style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                ReusableText(text: 'Job Title', style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                ReusableText(text: 'Salary', style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                              ],
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Container(
                                color: Colors.amberAccent, height: 60.h, width: 1.w,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReusableText(text: jobDetails['company'], style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                ReusableText(text: jobDetails['title'], style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                ReusableText(text: jobDetails['salary'], style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                              ],
                            )
                          ],
                        ),
                        SizedBox(width: 20.w),
                        CircularProfileAvatar(image: jobDetails['image_url'], w: 50.w, h: 50.h)
                      ],
                    ),
                  );
                })
              ],
            ),
          )),
          Positioned(child: Container(
            width: width, height: height*0.75,
            decoration: BoxDecoration(
              color: Color(kGreen.value),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
                topLeft: Radius.circular(20.r)
              )
            ),
            child: Stack(
              children: [
                Padding(padding: EdgeInsets.only(bottom: 6.h),
                child: StreamBuilder(
                    stream: chats, builder: (context, snapshot){
                      if(snapshot.hasError){
                        return Text('Error: ${snapshot.error}');
                      } else if(snapshot.connectionState == ConnectionState.waiting){
                        return const SizedBox.shrink();
                      } else if(snapshot.data!.docs.isEmpty == true){
                        return const SizedBox.shrink();
                      }
                      int msgCount = snapshot.data!.docs.length;
                  return Column(
                    children: [
                      Container(
                        height: height*0.64,
                        padding: EdgeInsets.all(8.h),
                        child: ScrollablePositionedList.builder(
                          itemCount: msgCount,
                          initialScrollIndex: msgCount,
                          itemScrollController: itemController,
                          itemBuilder: (context, index){
                            var message = snapshot.data!.docs[index];
                            Timestamp lastChatTime = message['time'];
                            DateTime chatTime = lastChatTime.toDate();
                            print(message['id']);

                            return Padding(padding: EdgeInsets.all(8.w),
                            child: Column(
                              children: [
                                Text(timeLineFormat(chatTime),
                                style: appstyle(10.sp, Colors.grey, FontWeight.normal),),

                                message['sender'] == userUid ?
                                    chatRightItem(message['messageType'], message['message'], message['profile'])
                                    : chatLeftItem(message['messageType'], message['message'], message['profile'])
                              ],
                            ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
                ),
                Positioned(
                    bottom: 0.h,
                    child: MessagingField(
                      sendText: (){
                        sendMessage();
                      },
                        messageController: messageController, messageFocusNode: messageFocusNode))
              ],
            ),
          ))
        ],
      )),
    );
  }
}