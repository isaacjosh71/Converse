import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub/controllers/zoom_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../services/helpers/auth_helper.dart';
import '../views/ui/home/mainscreen.dart';


class LoginNotifier extends ChangeNotifier {
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

  bool? _entryPoint;

  bool get entryPoint => _entryPoint ?? false;

  set entryPoint(bool newState){
    _entryPoint = newState;
    notifyListeners();
  }

  bool? _loggedIn;

  bool get loggedIn => _loggedIn ?? false;

  set loggedIn(bool newState){
    _loggedIn = newState;
    notifyListeners();
  }

  logIn(String model, ZoomNotifier zoomNotifier){
    AuthHelper.login(model).then((response){
      if(response==true){
        loader=false;
        zoomNotifier.currentIndex = 0;
        Get.offAll(()=> const MainScreen());
      } else{
        loader=false;
        Get.snackbar('Failed to sign up', 'Please check credentials',
            backgroundColor: Color(kDarkPurple.value),
            colorText: Color(kLight.value), icon: const Icon(Icons.add_alert)
        );
      }
    });
  }

  getPref() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    entryPoint = prefs.getBool('entrypoint') ?? false;
    loggedIn = prefs.getBool('loggedIn') ?? false;
    userName = prefs.getString('userName') ?? '';
    userUid = prefs.getString('uid') ?? '';
    //
  }

  logOut() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.remove('token');
  }
}
