import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/agent_provider.dart';
import 'package:jobhub/models/response/agent/getAgent.dart';
import 'package:jobhub/services/helpers/agent_helper.dart';
import 'package:jobhub/views/common/backBtn.dart';
import 'package:jobhub/views/common/exports.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/agents/agent_jobs.dart';
import 'package:jobhub/views/ui/auth/profile.dart';
import 'package:provider/provider.dart';

class AgentDetails extends StatelessWidget {
  const AgentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        leading: Padding(padding: EdgeInsets.all(12.w),
          child: BackBtn(color: Color(kLight.value),),
        ),
        // title: ''
      ),
      body:  Stack(
        children: [
          Positioned(
              top: 0.h, left: 0.w, right: 0.w,
              child: Container(
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                height: 140.h,
                decoration: BoxDecoration(
                    color: Color(kNewBlue.value),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        topLeft: Radius.circular(20.r)
                    )
                ),
                child: Column(
                  children: [
                    Consumer<AgentNotifier>(builder: (context, agentNotifier, child){
                      var agent = agentNotifier.agents;
                      var agentInfo = agentNotifier.getAgentInfo(agent!.uid);
                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableText(text: 'Company', style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                    ReusableText(text: 'Address', style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                    ReusableText(text: 'Working hours', style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Container(
                                    color: Colors.amberAccent, height: 60.h, width: 1.w,
                                  ),
                                ),
                                FutureBuilder<GetAgent>(
                                    future: agentInfo,
                                    builder: (context, snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const SizedBox.shrink();
                                      } else if(snapshot.hasError){
                                        return Text('Error ${snapshot.error}');
                                      } else{
                                        var data = snapshot.data;
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ReusableText(text: data!.company, style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                            ReusableText(text: data.hqAddress, style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                            ReusableText(text: data.workingHrs, style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
                                          ],
                                        );
                                      }
                                    }),
                              ],
                            ),
                            SizedBox(width: 20.w),
                            CircularProfileAvatar(image: agent.profile, w: 50.w, h: 50.h)
                          ],
                        ),
                      );
                    })
                  ],
                ),
              )),
          Positioned(
              top: 80.h, left: 0.w, right: 0.w,
              child: Container(
                height: height*0.8, width: width,
                decoration: BoxDecoration(
                    color: const Color(0xFFEFFFFC),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        topLeft: Radius.circular(20.r)
                    )
                ),
                child: buildStyleContainer(
                  context,
                    const AgentJobs()),
              ))
        ],
      ),
    );
  }
}
