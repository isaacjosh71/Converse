import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/views/common/exports.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key, required this.indexSetter});
  final ValueSetter indexSetter;

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kDarkPurple.value),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          drawerList(Icons.home_outlined, "Home", 0),
          drawerList(Icons.chat_outlined, "Chat", 1),
          drawerList(Icons.bookmark_outline_outlined, "Bookmarks", 2),
          drawerList(Icons.list_alt_outlined, "Applications", 3),
          drawerList(Icons.person_outline_outlined, "Profile", 4),
        ],
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index){
   return GestureDetector(
     onTap: (){
       widget.indexSetter(index);
     },
     child: Container(
       margin: EdgeInsets.only(left: 25.w, bottom: 45.h),
       child: Row(
         children: [
           Icon(icon, size: 14.sp, color: Color(kLight.value),),
           SizedBox(width: 10.w,),
           ReusableText(text: text, style: appstyle(16.sp, Color(kLight.value), FontWeight.normal))
         ],
       ),
     ),
   );
  }
}
