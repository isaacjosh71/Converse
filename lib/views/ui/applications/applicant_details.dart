import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:jobhub/controllers/agent_provider.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:http/http.dart' as http;
import '../../../services/pdf_services.dart';

class ApplicantDetails extends StatelessWidget {
  const ApplicantDetails({super.key});

  static var client = http.Client();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        leading: Padding(padding: EdgeInsets.all(12.w),
          child: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(AntDesign.leftcircleo, color: Color(kLight.value),),
          ),
        ),
      ),
      body:  Stack(
        children: [
          Positioned(
              top: 0.h, left: 0.w, right: 0.w,
              child: Container(
                height: Dimensions.height, width: Dimensions.width,
                decoration: BoxDecoration(
                    color: Color(kNewBlue.value),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        topLeft: Radius.circular(20.r)
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 5.h, right: 15.w),
                  child: Consumer<AgentNotifier>(
                         builder: (context, agentNotifier, child) {
                           var name = agentNotifier.chat['name'];
                           var email = agentNotifier.chat['email'];
                           var profile = agentNotifier.chat['profile'];
                           return Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Row(
                                     children: [
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           ReusableText(text: 'Name', style: appstyle(13.sp, Color(kLight.value), FontWeight.w500)),
                                           SizedBox(height: 10.h,),
                                           ReusableText(text: 'Email', style: appstyle(13.sp, Color(kLight.value), FontWeight.w500)),
                                         ],
                                       ),
                                       Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
                                         child: Container(
                                           color: Colors.amberAccent, height: 60.h, width: 1.w,
                                         ),
                                       ),
                                       Column(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           ReusableText(text: name, style: appstyle(13.sp, Color(kLight.value), FontWeight.w500)),
                                           SizedBox(height: 10.h,),
                                           ReusableText(text: email, style: appstyle(13.sp, Color(kLight.value), FontWeight.w500)),
                                         ],
                                       )
                                     ],
                                   ),
                                   SizedBox(width: 20.w),
                                   CircularProfileAvatar(image: profile, w: 50.w, h: 50.h)
                                 ],
                               ),
                             ],
                           );
                         },
                       ),
                ),
              )),
          Positioned(
              top: 80.h, left: 0.w, right: 0.w,
              child: Container(
                height: Dimensions.height*0.8, width: Dimensions.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFEFFFFC),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        topLeft: Radius.circular(20.r)
                    )
                ),
                child: buildStyleContainer(
                    context,
                    Padding(padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Consumer<AgentNotifier>(
                      builder: (BuildContext context, agentNotifier, child) {
                        var skill = agentNotifier.chat['skills'];
                        var pdfFile = agentNotifier.chat['pdf'];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 50.h,),
                                Text('CV',
                                  style: appstyle(14.sp, Colors.black,
                                      FontWeight.w500),
                                ),
                                SizedBox(height: 20.h,),
                                pdfFile != '' ? GestureDetector(
                                  onTap: () async{
                                    Uri url = Uri.parse(pdfFile);
                                    final response = await client.get(url);
                                    final bytes = response.bodyBytes;
                                    PdfServices.storeFile(url, bytes);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        color: Colors.white70,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: const Offset(0, 1),
                                              blurRadius: 3, spreadRadius: 2
                                          )
                                        ]
                                    ),
                                    child: ReusableText(text: 'Applicant CV', style: appstyle(12.sp, Color(kDark.value), FontWeight.normal)),
                                  ),
                                )
                            : const SizedBox.shrink(),
                              ],
                            ),
                            SizedBox(height: 50.h,),
                            Text('Brief Description - Portfolio',
                              style: appstyle(14.sp, Colors.black,
                                  FontWeight.w500),
                            ),
                            SizedBox(height: 20.h,),
                            SizedBox(
                                height: 250.h,
                                width: Dimensions.width,
                                child: Text(skill,
                                  textAlign: TextAlign.justify,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: appstyle(13.sp, Colors.black87,
                                      FontWeight.w500),
                                )),
                          ],
                        );
                      },
                    ),

                    )
                ),
              ))
        ],
      ),
    );
  }
}