import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/models/request/auth/login_model.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/custom_btn.dart';
import 'package:jobhub/views/common/custom_textfield.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:jobhub/views/ui/auth/signup.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:provider/provider.dart';

import '../../../models/request/auth/profile_update_model.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {

  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    username.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(builder: (context,loginNotifier,child){
      loginNotifier.getPref();
      return Scaffold(
        backgroundColor: Color(kLight.value),
        appBar: PreferredSize(preferredSize: Size.fromHeight(50.h),
            child: CustomAppBar(
              text: 'Update Profile',
              child: GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: const Icon(AntDesign.leftcircleo),
              ),)),
        body: buildStyleContainer(context, Padding(padding: EdgeInsets.symmetric(
            horizontal: 20.w),
          child: Form(child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 50.h,),
              ReusableText(text: 'Update User Information', style: appstyle(20.sp, Color(kDark.value), FontWeight.w500)),
              SizedBox(height: 40.h,),
              CustomTextField(controller: username,
                hintText: 'Enter new username',
                keyboard: TextInputType.name,
                validator: (name){
                  if(name!.isEmpty){
                    return 'Please enter name';
                  } return null;
                },
              ),
              SizedBox(height: 20.h,),
              CustomTextField(controller: email,
                hintText: 'Enter new email',
                keyboard: TextInputType.emailAddress,
                validator: (email){
                  if(email!.isEmpty || email.contains('@')){
                    return 'Please enter email';
                  } return null;
                },
              ),
              SizedBox(height: 50.h,),
              CustomButton(
                  text: 'Update', onTap: (){
                ProfileUpdateReq rawModel = ProfileUpdateReq(
                    email: email.text, username: username.text);

                var model = profileUpdateReqToJson(rawModel);

                loginNotifier.update(model);
              }
              )
            ],
          )),
        )),
      );
    });
  }
}