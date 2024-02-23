
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/views/ui/chat/conversation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../views/ui/chat/chatpage.dart';

class NotificationServices{
  static const key = 'AAAArs5TvKs:APA91bEy-7hT55cICUQRh0trH0I7qWZSbS6cUiRy3kxXTqp1tJ9GM_sYRLk0Ckw4u__nzQovYP7Dckk7DP_4hVslud1Rm0qjmocZgXNcvcfMFucLGqKwSKu0VJCYPe-b1hcz7sEm0fSn';

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void intLocalNotification(){
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    const initializationSetting = InitializationSettings(
      android: androidSettings, iOS: iosSettings);

    flutterLocalNotificationsPlugin.initialize(
        initializationSetting, onDidReceiveNotificationResponse: (response){
      debugPrint(response.payload.toString());
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async{
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true
    );
    var androidDetails = AndroidNotificationDetails(
        'my channel id', 'com.dbestech.jobhub',
        styleInformation: styleInformation,
        importance: Importance.max, priority: Priority.max);
    var iosDetails = const DarwinNotificationDetails(
        presentAlert: true, presentBadge: true);
    final notificationDetails = NotificationDetails(
      android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: message.data['body']);
  }

  Future<void> requestPermission() async{
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      debugPrint('User granted permission');
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      debugPrint('User granted provisional permission');
    }else{debugPrint('User declined or has not accepted permission');}
  }

  Future<void> getToken() async{
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    userUid = pref.getString('userUid') ?? '';
    await FirebaseFirestore.instance.collection('users').doc(userUid)
        .set({'token':token}, SetOptions(merge: true));
  }

  String receiverToken = '';

  Future<void> getReceiverToken(String? receiverId) async{
    final getToken = await FirebaseFirestore.instance.collection('users')
        .doc(receiverId).get();
    receiverToken = await getToken.data()!['token'];
  }

  void firebaseNotification(context){
    intLocalNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      await Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const ChatsPage()));
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      await _showLocalNotification(message);
    });
  }

  Future<void> sendNotification({required String body, required String senderId
  })async {
   try {await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key'
        },
        body: jsonEncode(<String, dynamic>{
          'to': receiverToken,
          'priority': 'high',
          'notification': <String, dynamic>{
            'body': body,
            'title': 'New message',
          },
          'data': <String, String>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'senderId': senderId,
            'body': body,
            'title': 'New message',
          }
        }
        ));
  } catch(e){
     debugPrint(e.toString());
   }
  }
}