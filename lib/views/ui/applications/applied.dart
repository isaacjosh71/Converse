import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/models/response/applied/applied.dart';
import 'package:jobhub/services/helpers/applied_helper.dart';
import 'package:jobhub/views/ui/applications/widgets/applied_tile.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../controllers/login_provider.dart';
import '../../common/app_bar.dart';
import '../../common/app_style.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/page_loader.dart';
import '../../common/reusable_text.dart';
import '../../common/style_container.dart';
import '../auth/non_user.dart';

class AppliedJobs extends StatelessWidget {
  const AppliedJobs({super.key});

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            text: 'Applied Jobs',
            color: Color(kNewBlue.value),
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: DrawerWidget(color: Color(kLight.value),),
              ))),
      body: loginNotifier.loggedIn == false ? const NonUser() :
      Stack(
        children: [
          Positioned(
              top: 0, left: 0, bottom: 0, right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)
                    ),
                    color: Color(kGreen.value)
                ),
                child: buildStyleContainer(context,
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: FutureBuilder<List<Applied>>(
                          future: AppliedHelper.getApplied(),
                          builder: ((context, snapshot){
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const PageLoader();
                            } else if(snapshot.hasError){return Text('Error: ${snapshot.error}');}
                            else{
                              var jobs = snapshot.data;
                              return ListView.builder(
                                  itemCount: jobs!.length,
                                  itemBuilder: (context, index){
                                    final job = jobs[index].job;
                                    print(job.id);
                                    return AppliedTile(job: job);
                                  });
                            }
                          })),
                    )
                ),
              ))
        ],
      )
    );
  }
}
