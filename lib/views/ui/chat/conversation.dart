import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uuid/uuid.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../models/response/auth/profile_model.dart';
import '../../../services/helpers/auth_helper.dart';
import '../../../services/notification_services.dart';
import '../../../services/pdf_services.dart';
import 'package:http/http.dart' as http;


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
  var uuid = const Uuid();
  late Future<ProfileRes> userProfile;
  ProfileRes? profile;
  final notificationServices = NotificationServices();

  sendMessage(String profileImg){
    var chat = Provider.of<AgentNotifier>(context, listen: false).chat;

    Map<String, dynamic> message = {
      'message' : messageController.text,
      'messageType':'text',
      'profile':profileImg,
      'sender':userUid,
      'id':uuid.v4(),
      'time':Timestamp.now()
    };

    services.createChat(chat['chatRoomId'], message);
    messageController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    getProf();
    getPrefs();
  }

  getProf(){
    // var chat = Provider.of<AgentNotifier>(context, listen: false).chat;
    // String receiverId = chat['sender'] != userUid ? jobUpdate!.agentId : userUid;
    userProfile = AuthHelper.getProfile();
    notificationServices.getReceiverToken(userUid);
  }

  getPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUid = prefs.getString('userUid') ?? '';
  }

  File? file;
  PlatformFile? platformFile;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  static var client = http.Client();

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
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
      backgroundColor: Color(kDark.value),
      appBar: AppBar(
        backgroundColor: Color(kDark.value),
        elevation: 0,
        leading: Padding(padding: EdgeInsets.all(12.w),
        child: BackBtn(color: Color(kLight.value),),
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 15.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                        style: appstyle(10.sp, Color(kLight.value), FontWeight.normal));
                      }),
                ],
              ),
            ],
          ),
          )
        ],
      ),
      body: SafeArea(
          child: Stack(
          children: [
          Positioned(
              top: 0.h, right: 0.w, left: 0.w,
              child: Container(
            padding: EdgeInsets.only(left: 5.w, top: 10.h, right:20.w),
            width: Dimensions.width, height: 140.h,
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
                                ReusableText(text: jobDetails['company'], style: appstyle(12.sp, Color(kLight.value), FontWeight.normal)),
                                ReusableText(text: jobDetails['title'], style: appstyle(12.sp, Color(kLight.value), FontWeight.normal)),
                                ReusableText(text: jobDetails['salary'], style: appstyle(12.sp, Color(kLight.value), FontWeight.normal)),
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
          Positioned(
              top: 90.h, right: 0.w, left: 0.w,
              child: Container(
            width: Dimensions.width, height: Dimensions.height*0.75,
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
                        height: Dimensions.height*0.64,
                        padding: EdgeInsets.all(8.h),
                        child: ScrollablePositionedList.builder(
                          padding: EdgeInsets.only(bottom: (viewInsets.bottom > 0) ? Dimensions.height*0.29 : 0.h),
                          itemCount: msgCount,
                          initialScrollIndex: msgCount,
                          itemScrollController: itemController,
                          itemBuilder: (context, index){
                            var message = snapshot.data!.docs[index];
                            Timestamp lastChatTime = message['time'];
                            DateTime chatTime = lastChatTime.toDate();
                            final isText = message['messageType'] == 'text';

                            return Padding(padding: EdgeInsets.all(8.w),
                            child: Column(
                              children: [
                                Text(timeLineFormat(chatTime),
                                style: appstyle(10.sp, Colors.grey, FontWeight.normal),),

                                isText ?
                                (message['sender'] == userUid ?
                                chatRightItem(message['messageType'], message['message'],)
                                    : chatLeftItem(message['messageType'], message['message'],))
                                :(message['sender'] == userUid ?
                            InkWell(
                                child: chatRightItem(message['messageType'], message['message'],),
                            onTap: () async{
                              Uri url = Uri.parse(message['messageType']);
                              final response = await client.get(url);
                              final bytes = response.bodyBytes;
                              PdfServices.storeFile(url, bytes);
                            },)
                                : InkWell(
                                    child: chatLeftItem(message['messageType'], message['message'],),
                                  onTap: () async{
                                    Uri url = Uri.parse(message['messageType']);
                                    final response = await client.get(url);
                                    final bytes = response.bodyBytes;
                                    PdfServices.storeFile(url, bytes);
                                  },
                                ))],
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
                     bottom: (viewInsets.bottom > 0) ? Dimensions.height*0.29 : 0.h,
                    child: FutureBuilder(
                      future: userProfile,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return MessagingField(
                              sendText: () {},
                              messageController: messageController,
                              messageFocusNode: messageFocusNode);
                        } else if(snapshot.hasError){
                          return Text('Error: ${snapshot.error}');
                        } else {
                          profile = snapshot.data;
                          String senderId = Provider.of<AgentNotifier>(context, listen: false).chat['sender'];
                              return Consumer<AgentNotifier>(
                                builder: (context, agentNotifier, child) {
                                  return MessagingField(
                                      onTap: () async{
                                        String profileImg = profile!.profile;
                                        final result = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf', 'doc',],
                                          allowMultiple: false,
                                        );
                                        if (result != null) {
                                          platformFile = result.files.first;
                                          file = File(result.files.single.path!);

                                          Reference ref = _storage.ref().child('pdf').child(userUid);
                                          UploadTask uploadTask = ref.putFile(file!);
                                          TaskSnapshot snapshot = await uploadTask;
                                          var downloadUrl = await snapshot.ref.getDownloadURL();

                                          var chat = agentNotifier.chat;

                                          Map<String, dynamic> message = {
                                            'message' : platformFile!.name,
                                            'messageType': downloadUrl,
                                            'profile':profileImg,
                                            'sender':userUid,
                                            'id':uuid.v4(),
                                            'time':Timestamp.now()
                                          };
                                          services.createChat(chat['chatRoomId'], message);
                                          await notificationServices.sendNotification(body: platformFile!.name, senderId: senderId
                                          );
                                        } else {}
                                      },
                                      sendText: () async{
                                        String profileImg = profile!.profile;
                                        sendMessage(profileImg);
                                        await notificationServices.sendNotification(body: messageController.text,
                                            senderId: senderId
                                        );
                                      },
                                      messageController: messageController,
                                      messageFocusNode: messageFocusNode);
                                },
                              );
                        }
                      },
                    ))
              ],
            ),
          ))
        ],
      )),
    );
  }
}