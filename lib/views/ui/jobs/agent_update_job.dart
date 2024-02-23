import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/models/request/jobs/create_job.dart';
import 'package:jobhub/services/helpers/jobs_helper.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/app_style.dart';
import 'package:jobhub/views/common/backBtn.dart';
import 'package:jobhub/views/common/buildtextfield.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/skills_provider.dart';
import '../../../models/response/auth/profile_model.dart';
import '../../../services/helpers/auth_helper.dart';
import '../../common/custom_outline_btn.dart';
import '../../common/reusable_text.dart';

class AgentUpdateJob extends StatefulWidget {
  const AgentUpdateJob({super.key});

  @override
  State<AgentUpdateJob> createState() => _AgentUpdateJobState();
}

class _AgentUpdateJobState extends State<AgentUpdateJob> {
  TextEditingController title = TextEditingController(text: jobUpdate!.title);
  TextEditingController company = TextEditingController(text: jobUpdate!.company);
  TextEditingController location = TextEditingController(text: jobUpdate!.location);
  TextEditingController salary = TextEditingController(text: jobUpdate!.salary);
  TextEditingController level = TextEditingController(text: jobUpdate!.level);
  TextEditingController contract = TextEditingController(text: jobUpdate!.contract);
  TextEditingController description = TextEditingController(text: jobUpdate!.description);
  TextEditingController period = TextEditingController(text: jobUpdate!.period);
  TextEditingController rq1 = TextEditingController(text: jobUpdate!.requirements[0]);
  TextEditingController rq2 = TextEditingController(text: jobUpdate!.requirements[1]);
  TextEditingController rq3 = TextEditingController(text: jobUpdate!.requirements[2]);
  TextEditingController rq4 = TextEditingController(text: jobUpdate!.requirements[3]);
  TextEditingController rq5 = TextEditingController(text: jobUpdate!.requirements[4]);
  TextEditingController imageController = TextEditingController(text: jobUpdate!.imageUrl);

  String username = '';
  // String profile = '';
  late Future<ProfileRes> userProfile;
  ProfileRes? profile;

  @override
  void initState(){
    super.initState();
    getProfile();
    getName();
  }

  getName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username')??'';
    // profile = prefs.getString('profile')??'';
  }

  getProfile(){
    userProfile = AuthHelper.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    var skillNotifier = Provider.of<SkillNotifier>(context, listen: false);
    var zoomNotifier = Provider.of<ZoomNotifier>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
              actions: [
                Consumer<SkillNotifier>(builder: (context, skillNotifier, child){
                  return skillNotifier.logoUrl.isNotEmpty ? Padding(padding: EdgeInsets.all(12.w),
                    child: CircularProfileAvatar(image: skillNotifier.logoUrl, w: 30.w, h: 40.h),
                  ) : const SizedBox.shrink();
                })
              ],
              text: 'Upload Jobs',
              color: Color(kNewBlue.value),
              child: BackBtn(color: Color(kLight.value),))),
      body: Stack(
        children: [
          Positioned(
              right: 0,top: 0,bottom: 0,left: 0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r)), color: Color(kLight.value)
                ),
                child: buildStyleContainer(context,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 20.h),
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the void');
                                  } else {return null;}
                                }, label: const Text('Job title'),
                                controller: title, hintText: 'Job Title'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the void');
                                  } else {return null;}
                                }, label: const Text('Company'),
                                controller: company, hintText: 'Company'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the void');
                                  } else {return null;}
                                }, label: const Text('Level'),
                                controller: level, hintText: 'Level'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the void');
                                  } else {return null;}
                                }, label: const Text('Location'),
                                controller: location, hintText: 'Location'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the void');
                                  } else {return null;}
                                }, label: const Text('Contract'),
                                controller: contract, hintText: 'Contract'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the void');
                                  } else {return null;}
                                }, label: const Text('Salary'),
                                controller: salary, hintText: 'Salary'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the void');
                                  } else {return null;}
                                }, label: const Text('Salary Period'),
                                controller: period, hintText: 'Annual | Monthly | Weekly'),
                          ),
                          Consumer<SkillNotifier>(builder: (context, skillNotifier, child){
                            return SizedBox(width: Dimensions.width, height: 60.h,
                              child: Row(
                                children: [
                                  SizedBox(width: Dimensions.width*0.8, height: 60.h,
                                    child: buildTextField(
                                        onChanged: (value){
                                          skillNotifier.setLogoUrl(imageController.text);
                                        },
                                        onSubmitted: (value){
                                          if(value!.isEmpty && value.contains('https://')){
                                            return ('Please fill the field');
                                          } else {return null;}
                                        }, label: const Text('ImageUrl'),
                                        controller: imageController, hintText: 'Image Url'),
                                  ),
                                  SizedBox(width: 3.w,),
                                  GestureDetector(
                                    onTap: (){
                                      skillNotifier.setLogoUrl(imageController.text);
                                    }, child: Icon(Entypo.upload_to_cloud, size: 35.sp, color: Color(kNewBlue.value),),
                                  )
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: 5.h,),
                          buildTextField(
                              height: 100.h,
                              onSubmitted: (value){
                                if(value!.isEmpty){
                                  return ('Please fill the void');
                                } else {return null;}
                              }, label: const Text('Description'), maxLines: 3,
                              controller: description, hintText: 'Description'),
                          ReusableText(text: 'Requirements', style: appstyle(15.sp, Color(kDark.value), FontWeight.w600),),
                          SizedBox(height: 5.h,),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                maxLines: 2, height: 50.h,
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the field');
                                  } else {return null;}
                                }, label: const Text('Requirements'),
                                controller: rq1, hintText: 'Requirements'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                maxLines: 2, height: 50.h,
                                onSubmitted: (value){
                                  if(value!.isEmpty){
                                    return ('Please fill the field');
                                  } else {return null;}
                                }, label: const Text('Requirements'),
                                controller: rq2, hintText: 'Requirements'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                maxLines: 2, height: 50.h,
                                label: const Text('Requirements'),
                                controller: rq3, hintText: 'Requirements'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                maxLines: 2, height: 50.h,
                                label: const Text('Requirements'),
                                controller: rq4, hintText: 'Requirements'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.h),
                            child: buildTextField(
                                maxLines: 2, height: 50.h,
                                label: const Text('Requirements'),
                                controller: rq5, hintText: 'Requirements'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: FutureBuilder(
                              future: userProfile,
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const SizedBox.shrink();
                                } else if(snapshot.hasError){
                                  return Text('Error: ${snapshot.error}');
                                }else{
                                  profile = snapshot.data;
                                  return CustomOutlineBtn(text: 'Submit',
                                      onTap: () async{
                                        CreateJobsRequest rawModel = CreateJobsRequest(
                                            title: title.text, location: location.text,
                                            company: company.text, hiring: jobUpdate!.hiring,
                                            description: description.text, salary: salary.text,
                                            period: period.text, contract: contract.text,
                                            imageUrl: skillNotifier.logoUrl, agentId: jobUpdate!.agentId,
                                            requirements: [
                                              rq1.text, rq2.text, rq3.text, rq4.text, rq5.text,
                                            ], agentName: username, level: level.text, agentPic: profile!.profile);
                                        var model = createJobsRequestToJson(rawModel);
                                        JobsHelper.updateJob(model,jobUpdate!.id);
                                        zoomNotifier.currentIndex = 0;
                                        Get.offAll(()=> const MainScreen());
                                      },
                                      height: 40.h, color: Color(kLight.value), color2: Color(kOrange.value));
                                }

                              },
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ))
        ],
      ),
    );
  }
}
