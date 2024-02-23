
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';

import 'onboarding_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}
class _SplashState extends State<Splash> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )
    ..repeat(reverse: true);
  _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));
    Timer(const Duration(seconds: 3), ()=>Get.off(()=> const OnBoardingScreen()));
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: const Color(0xff6352c5),
          body:
          SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(kLight.value),
              ),
              child: SlideTransition(
                position: _offsetAnimation,
                child: Center(
                  child: Image.asset('assets/images/Converse.jpg',
                    height: MediaQuery.of(context).size.height*0.22,
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
