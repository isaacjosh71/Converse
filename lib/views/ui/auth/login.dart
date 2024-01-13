import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/controllers/login_provider.dart';
import 'package:jobhub/models/request/auth/login_model.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/backBtn.dart';
import 'package:jobhub/views/common/custom_btn.dart';
import 'package:jobhub/views/common/custom_textfield.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/auth/signup.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginNotifier>(builder: (context,loginNotifier,child){
      loginNotifier.getPref();
      return Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(50.h),
            child: CustomAppBar(
              text: 'Login',
              child: GestureDetector(
                onTap: (){
                  Get.offAll(()=> const MainScreen());
                },
                child: const Icon(AntDesign.leftcircleo),
              ),)),
        body: buildStyleContainer(context, Padding(padding: EdgeInsets.symmetric(
            horizontal: 20.w),
          child: Form(child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 50.h,),
              ReusableText(text: 'Welcome Back', style: appstyle(30.sp, Color(kDark.value), FontWeight.w600)),
              ReusableText(text: 'Fill in the details to login your account', style: appstyle(14.sp, Color(kDarkGrey.value), FontWeight.w400)),
              SizedBox(height: 40.h,),
              CustomTextField(controller: email,
                hintText: 'Enter your email',
                keyboard: TextInputType.emailAddress,
                validator: (email){
                  if(email!.isEmpty || !email.contains('@')){
                    return 'Please enter email';
                  } return null;
                },
              ),
              SizedBox(height: 20.h,),
              CustomTextField(controller: password,
                hintText: 'Enter your password',
                obscureText: loginNotifier.obscureText,
                keyboard: TextInputType.text,
                suffixIcon: GestureDetector(
                  onTap: (){loginNotifier.obscureText=!loginNotifier.obscureText;},
                  child: Icon(
                    loginNotifier.obscureText ? Icons.visibility : Icons.visibility_off
                  ),
                ),
                validator: (password){
                  if(password!.isEmpty || password.length < 8){
                    return 'Please enter password';
                  } return null;
                },
              ),
              SizedBox(height: 10.h,),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: (){
                    Get.offAll(()=> const RegistrationPage());
                  },
                  child: ReusableText(text: 'Do\'nt have an account? Register', style: appstyle(12.sp, Color(kDark.value), FontWeight.w400)),
                ),
              ),
              SizedBox(height: 40.h,),
              Consumer<ZoomNotifier>(builder: (context, zoomNotifier, child){
                return CustomButton(
                  text: 'Login', onTap: (){
                  loginNotifier.loader = true;

                    LoginModel model = LoginModel(
                        email: email.text, password: password.text);

                    String newModel = loginModelToJson(model);

                    loginNotifier.logIn(newModel, zoomNotifier);
                }
                );
              })
            ],
          )),
        )),
      );
    });
  }
}