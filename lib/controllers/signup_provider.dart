import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/services/helpers/auth_helper.dart';
import 'package:jobhub/views/ui/auth/login.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';



class SignUpNotifier extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  set obscureText(bool newState){
    _obscureText = newState;
    notifyListeners();
  }

  bool _loader = false;

  bool get loader => _loader;

  set loader(bool newState){
    _loader = newState;
    notifyListeners();
  }

//
// // triggered when the fist time when user login to be prompted to the update profile page
//   bool _firstTime = false;
//
//   bool get firstTime => _firstTime;
//
//   set firstTime(bool newValue) {
//     _firstTime = newValue;
//     notifyListeners();
//   }
//
  final signupFormKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = signupFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // bool passwordValidator(String password) {
  //   if (password.isEmpty) return false;
  //   String pattern =
  //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  //   RegExp regex = RegExp(pattern);
  //   return regex.hasMatch(password);
  // }

  signUp(String model, ZoomNotifier zoomNotifier){
    AuthHelper.signup(model).then((response){
      if(response==true){
        loader=false;
        zoomNotifier.currentIndex = 0;
        Get.offAll(()=> const LoginPage());
      } else{
        loader=false;
        Get.snackbar('Failed to sign up', 'Please check credentials',
        backgroundColor: Color(kDarkPurple.value),
          colorText: Color(kLight.value), icon: Icon(Icons.add_alert)
        );
      }
    });
  }
}
