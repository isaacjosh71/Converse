import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.back();
      },
      child: Icon(AntDesign.leftcircleo, color: color,),
    );
  }
}
