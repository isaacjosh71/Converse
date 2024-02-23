import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub/controllers/zoom_provider.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../services/helpers/agent_helper.dart';
import '../services/helpers/auth_helper.dart';
import '../services/notification_services.dart';
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

  static final notifications = NotificationServices();

  logIn(String model, ZoomNotifier zoomNotifier){
    AuthHelper.login(model).then((response){
      if(response==true){
        loader=false;
        zoomNotifier.currentIndex = 0;
        Get.offAll(()=> const MainScreen());
        notifications.requestPermission();
        notifications.getToken();
      } else{
        loader=false;
        Get.snackbar('Failed to sign up', 'Please check credentials',
            backgroundColor: Color(kOrange.value),
            colorText: Color(kLight.value), icon: const Icon(Icons.add_alert)
        );
      }
    });
  }

  update(var model){
    AuthHelper.updateProfile(model).then((response){
      if(response==true){
        print(response);
        Get.offAll(()=> const MainScreen());
      } else{
        Get.snackbar('Failed to update', 'Please check credentials',
            backgroundColor: Color(kOrange.value),
            colorText: Color(kLight.value), icon: const Icon(Icons.add_alert)
        );
      }
    });
  }


  agent(var model){
    AgentHelper.beAnAgent(model).then((response){
      if(response==true){
        print(response);
        Get.offAll(()=> const MainScreen());
      } else{
        Get.snackbar('Failed', 'Please try again',
            backgroundColor: Color(kOrange.value),
            colorText: Color(kLight.value), icon: const Icon(Icons.add_alert)
        );
      }
    });
  }

  getPref() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    entryPoint = prefs.getBool('entryPoint') ?? false;
    loggedIn = prefs.getBool('loggedIn') ?? false;
    // isAgent = prefs.getBool('agent') ?? false;
    userName = prefs.getString('username') ?? '';
    userUid = prefs.getString('userUid') ?? '';
    profileImage = prefs.getString('profile') ?? '';
    token = prefs.getString('token') ?? '';
  }

  logOut() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.remove('token');
  }
}
