import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/models/request/auth/image_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/helpers/auth_helper.dart';

  pickUserImage(ImageSource source) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();

    XFile? _imageFile = await _picker.pickImage(source: source);

    if (_imageFile != null){
       return await _imageFile.readAsBytes();
      } else {
        print('No images selected');
      }
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;


  class StoreData{

    //storage
    Future<String> uploadImageToStorage(String childName, Uint8List file) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
        userUid = prefs.getString('userUid') ?? '';
      Reference ref = _storage.ref().child(childName).child(userUid);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      ProfileImageReq rawModel = ProfileImageReq(profile: downloadUrl);
      var model = profileImageReqToJson(rawModel);
      updateProfileImage(model);
      print('Successful upload');
      print(downloadUrl);
      return downloadUrl;
    }

    updateProfileImage(var model){
      AuthHelper.updateImage(model).then((response){
        if(response==true){
          print('image changed successful');
        } else{
          Get.snackbar('Failed to change image', 'Please try again',
              backgroundColor: Color(kOrange.value),
              colorText: Color(kLight.value), icon: const Icon(Icons.add_alert)
          );
        }
      });
    }

    // Future<String> uploadPdfToStorage(String childName, Uint8List file) async{
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   userUid = prefs.getString('userUid') ?? '';
    //   Reference ref = _storage.ref().child(childName).child(userUid);
    //   UploadTask uploadTask = ref.putData(file);
    //   TaskSnapshot snapshot = await uploadTask;
    //   String downloadUrl = await snapshot.ref.getDownloadURL();
    //   updatePdf(downloadUrl);
    //   print('Successful upload');
    //   print(downloadUrl);
    //   return downloadUrl;
    // }
    //
    // updatePdf(String url) async{
    //   // SharedPreferences prefs = await SharedPreferences.getInstance();
    //   // userUid = prefs.getString('userUid') ?? '';
    //   pdf.doc('').set({'pdf':url});
    // }

  }


  //  imageUpload() async {
  //   final ref =
  //       FirebaseStorage.instance.ref().child('jobhub').child('${uid}jpg');
  //   await ref.putFile(imageUrl[0]);
  //   imageUrl = await ref.getDownloadURL();
  // }
//firestore database
// Future<String> saveData(Uint8List file) async{
//   String res = 'Some error occurred';
//   try{
//     String imageUrl = await uploadImageToStorage('profileImage', file);
//     await _fireStore.collection('userProfileImage').add({'imageUrl': imageUrl,});
//     res = 'success';
//   }catch(e){
//     res = e.toString();
//   }
//   return res;
// }

//build profile pic update mongoose
