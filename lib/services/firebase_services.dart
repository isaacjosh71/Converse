import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices{
  CollectionReference typing = FirebaseFirestore.instance.collection('typing');
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference status = FirebaseFirestore.instance.collection('status');
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');


  createChatRoom(Map<String, dynamic> chatData){
    chats.doc(chatData['chatRoomId']).set(chatData).catchError((e){
      debugPrint(e.toString());
    });
}

  void addTypingStatus(String chatRoomId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUid = prefs.getString('userUid') ?? '';
    typing.doc(chatRoomId).collection('typing').doc(userUid).set({});
  }


  void removeTypingStatus(String chatRoomId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userUid = prefs.getString('userUid') ?? '';
    typing.doc(chatRoomId).collection('typing').doc(userUid).delete();
  }

  createChat(String chatRoomId, message){
    chats.doc(chatRoomId).collection('messages').add(message).catchError((e){
      debugPrint(e.toString());
    });
    removeTypingStatus(chatRoomId);
    chats.doc(chatRoomId).update({
      'messageType':message['messageType'],
      'sender':message['sender'],
      'id':message['id'],
      // 'profile':message['profile'],
      'timestamp':Timestamp.now(),
      'lastChat':message['message'],
      'lastChatTime':message['time'],
      'read':false,
    });
  }

  updateCount(String chatRoomId){
    chats.doc(chatRoomId).update({'read':true});
  }

  Future<bool> chatRoomExist(String chatRoomId) async{
    DocumentReference chatRoomRef = chats.doc(chatRoomId);
    DocumentSnapshot chatRoomSnapshot = await chatRoomRef.get();
    return chatRoomSnapshot.exists;
  }

}