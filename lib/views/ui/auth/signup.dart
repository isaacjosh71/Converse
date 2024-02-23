import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/models/request/auth/signup_model.dart';
import 'package:jobhub/services/notification_services.dart';
import 'package:jobhub/views/ui/auth/login.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../common/app_bar.dart';
import '../../common/app_style.dart';
import '../../common/custom_btn.dart';
import '../../common/custom_textfield.dart';
import '../../common/reusable_text.dart';
import '../../common/style_container.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
 
 final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();


  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpNotifier>(builder: (context,signupNotifier,child){
      return Scaffold(
        backgroundColor: Color(kLight.value),
        appBar: PreferredSize(preferredSize: Size.fromHeight(50.h),
            child: CustomAppBar(
              text: 'Sign Up',
              child: GestureDetector(
                onTap: (){
                  Get.offAll(()=> const LoginPage());
                },
                child: const Icon(AntDesign.leftcircleo),
              ),)),
        body:
        // signupNotifier.loader ?
        // const Center(child: Loader(text: ''),) :
        buildStyleContainer(context, Padding(padding: EdgeInsets.symmetric(
            horizontal: 20.w),
          child: Form(child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 50.h,),
              ReusableText(text: 'Welcome', style: appstyle(30.sp, Color(kDark.value), FontWeight.w600)),
              ReusableText(text: 'Fill in the details to signup your account', style: appstyle(14.sp, Color(kDarkGrey.value), FontWeight.w400)),
              SizedBox(height: 40.h,),
              CustomTextField(controller: name,
                hintText: 'Enter your full name',
                keyboard: TextInputType.text,
                validator: (name){
                  if(name!.isEmpty){
                    return 'Please enter full name';
                  } return null;
                },
              ),
              SizedBox(height: 20.h,),
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
                obscureText: signupNotifier.obscureText,
                keyboard: TextInputType.text,
                suffixIcon: GestureDetector(
                  onTap: (){signupNotifier.obscureText=!signupNotifier.obscureText;},
                  child: Icon(
                      signupNotifier.obscureText ? Icons.visibility : Icons.visibility_off
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
                    Get.offAll(()=> const LoginPage());
                  },
                  child: ReusableText(text: 'Already have an account? Login', style: appstyle(12.sp, Color(kDark.value), FontWeight.w400)),
                ),
              ),
              SizedBox(height: 40.h,),
              Consumer<ZoomNotifier>(builder: (context, zoomNotifier, child){
                return CustomButton(
                    text: 'Sign Up', onTap: (){
                      signupNotifier.loader = true;

                      SignupModel model = SignupModel(
                          username: name.text, email: email.text, password: password.text);

                      String newModel = signupModelToJson(model);

                      signupNotifier.signUp(newModel, zoomNotifier);
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