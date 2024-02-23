import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/zoom_provider.dart';
import 'package:jobhub/views/common/drawer/drawer_screen.dart';
import 'package:jobhub/views/ui/applications/applied.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:jobhub/views/ui/bookmarks/bookmarks.dart';
import 'package:jobhub/views/ui/chat/chatpage.dart';
import 'package:jobhub/views/ui/home/homepage.dart';
import 'package:provider/provider.dart';
import '../../../controllers/login_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ZoomNotifier>(
        builder: (context, zoomNotifier, child){
          return ZoomDrawer(
            borderRadius: 30.r,
            menuBackgroundColor: Color(kLightBlue.value),
            angle: 0.0, slideWidth: 210.w,
            menuScreen: DrawerScreen(indexSetter: (index){
              zoomNotifier.currentIndex = index;
            },),
            mainScreen: currentScreen(),);
        },
      ),
    );
  }

  Widget currentScreen(){
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var loginNotifier = Provider.of<LoginNotifier>(context);
    loginNotifier.getPref();
    switch (zoomNotifier.currentIndex){
      case 0:
      return const HomePage();
      case 1:
      return const BookMarkPage();
      case 2:
      return const ChatsPage();
      case 3:
      return const AppliedJobs();
      case 4:
      return const ProfilePage(drawer: true);
      default:
      return const HomePage();
    }
  }
}