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

import '../../../models/request/agents/createAgents.dart';
import '../../../models/request/auth/profile_update_model.dart';

class BeAnAgent extends StatefulWidget {
  const BeAnAgent({super.key});

  @override
  State<BeAnAgent> createState() => _BeAnAgentState();
}

class _BeAnAgentState extends State<BeAnAgent> {

  final TextEditingController company = TextEditingController();
  final TextEditingController hqAddress = TextEditingController();
  final TextEditingController workingHrs = TextEditingController();

  @override
  void dispose() {
    // id.dispose();
    company.dispose();
    hqAddress.dispose();
    workingHrs.dispose();
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
              text: 'Become An Agent',
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
              ReusableText(text: 'Fill In the form', style: appstyle(18.sp, Color(kDark.value), FontWeight.normal)),
              SizedBox(height: 40.h,),
              // CustomTextField(controller: id,
              //   hintText: 'User id',
              //   validator: (id){
              //     if(id!.isEmpty){
              //       return '';
              //     } return null;
              //   },
              // ),
              SizedBox(height: 15.h,),
              CustomTextField(controller: company,
                hintText: 'Enter company name',
                keyboard: TextInputType.name,
                validator: (name){
                  if(name!.isEmpty){
                    return 'Please enter company name';
                  } return null;
                },
              ),
              SizedBox(height: 15.h,),
              CustomTextField(controller: hqAddress,
                hintText: 'Enter company address',
                validator: (add){
                  if(add!.isEmpty){
                    return 'Please enter company address';
                  } return null;
                },
              ),
              SizedBox(height: 15.h,),
              CustomTextField(controller: workingHrs,
                hintText: 'Enter company working hours',
                validator: (hr){
                  if(hr!.isEmpty){
                    return 'Please enter company working hours';
                  } return null;
                },
              ),
              SizedBox(height: 40.h,),
              CustomButton(
                  text: 'Done', onTap: (){
                BeAgent rawModel = BeAgent(
                    id: profileUpdate!.uid,
                    company: company.text,
                    hqAddress: hqAddress.text,
                    workingHrs: workingHrs.text
                );

                var model = beAgentToJson(rawModel);

                loginNotifier.agent(model);
              }
              )
            ],
          )),
        )),
      );
    });
  }
}