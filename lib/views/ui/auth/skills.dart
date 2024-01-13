import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/controllers/skills_provider.dart';
import 'package:jobhub/models/request/skills/add_skills.dart';
import 'package:jobhub/services/helpers/auth_helper.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/ui/auth/add_skill.dart';
import 'package:provider/provider.dart';

import '../../../models/response/skills/skills.dart';

class SkillsWidget extends StatefulWidget {
  const SkillsWidget({super.key});

  @override
  State<SkillsWidget> createState() => _SkillsWidgetState();
}

class _SkillsWidgetState extends State<SkillsWidget> {
  TextEditingController skills = TextEditingController();
  late Future<List<Skills>> userSkills;

  @override
  void initState() {
    userSkills = AuthHelper.getSkills();
    super.initState();
  }

  Future<List<Skills>> getSkills(){
    var skills = AuthHelper.getSkills();
    return skills;
  }

  @override
  Widget build(BuildContext context) {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var skillNotifier = Provider.of<SkillNotifier>(context);
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(text: 'Skills', style: appstyle(15.sp, Color(kDark.value), FontWeight.w600)),
              Consumer<SkillNotifier>(builder: (context, skillNotifier, child){
                return skillNotifier.addSkills == false ? GestureDetector(
                  onTap: (){
                    skillNotifier.setSkills = !skillNotifier.addSkills;
                    //false then true then false then true....
                  },
                  child: Icon(MaterialCommunityIcons.plus_circle_outline, size: 24.sp,),
                ) :
                GestureDetector(
                  onTap: (){
                    skillNotifier.setSkills = !skillNotifier.addSkills;
                    //false then true then false then true....
                  },
                  child: Icon(AntDesign.closecircleo, size: 21.sp,),
                );
              })
            ],
          ),
        ),
        SizedBox(height: 5.h),
        skillNotifier.addSkills == true ?
        AddSkills(skill: skills,
        onTap: (){
          AddSkill rawModel = AddSkill(skill: skills.text);
          var model = addSkillToJson(rawModel);
          AuthHelper.addSkills(model);
          skills.clear();
          skillNotifier.setSkills = !skillNotifier.addSkills;
          userSkills = getSkills();
        },
        ) : SizedBox(
          height: 35.h,
          child: FutureBuilder(future: userSkills, builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                  child: CircularProgressIndicator.adaptive());
            } else{
              var skills = snapshot.data;
              return ListView.builder(
                  itemCount: skills!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    var skill = skills[index];
                return GestureDetector(
                    onLongPress: (){
                      skillNotifier.setSkillsId = skill.id;
                    },
                    onTap: (){
                      skillNotifier.setSkillsId = '';
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.w),
                      margin: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        color: Color(kLightGrey.value)
                      ),
                      child: Row(
                        children: [
                          ReusableText(text: skill.skill, style: appstyle(10.sp, Color(kDark.value), FontWeight.w500)),
                          SizedBox(width: 5.w,),
                          skillNotifier.addSkillsId == skill.id ?
                              GestureDetector(
                                onTap: (){
                                  AuthHelper.deleteSkills(skillNotifier.addSkillsId);
                                  skillNotifier.setSkillsId = '';
                                  userSkills = getSkills();
                                },
                                child: Icon(AntDesign.closecircleo, size: 14.sp, color: Color(kDark.value),),
                              ) : const SizedBox.shrink()
                        ],
                      ),
                    ));
              });
            }
          }),
        )
      ],
    );
  }
}
