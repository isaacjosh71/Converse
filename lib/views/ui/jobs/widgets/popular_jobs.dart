import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/views/common/loader.dart';
import 'package:jobhub/views/common/popular_shimmer.dart';
import 'package:jobhub/views/ui/jobs/job_page.dart';
import 'package:jobhub/views/ui/jobs/widgets/horizontal_tile.dart';
import 'package:provider/provider.dart';

import '../../../../services/helpers/jobs_helper.dart';
import '../../../common/shimmer.dart';
import '../../../common/style_container.dart';

class PopularJobs extends StatefulWidget {
  const PopularJobs({super.key});

  @override
  State<PopularJobs> createState() => _PopularJobsState();
}

class _PopularJobsState extends State<PopularJobs> {
  late Future<List<JobsResponse>> popularJobs;

  getPopular() {
    popularJobs = JobsHelper.getJobs();
  }

  @override
  void initState(){
    super.initState();
    getPopular();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
        builder: (context, jobsNotifier, child){
          jobsNotifier.getJobs();
          return SizedBox( height: Dimensions.height*0.24,
            child: FutureBuilder<List<JobsResponse>>(
                future: jobsNotifier.jobList,
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return buildPopularShimmer();
                  } else if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  } else if(snapshot.data!.isEmpty){
                    return const Text('No jobs found');
                  } else {
                    final jobs = snapshot.data;
                    return ListView.builder(
                      physics: const ScrollPhysics(),
                        itemCount: jobs!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          var job = jobs[index];
                          return JobHorizontalTile(
                              job: job,
                           onTap: (){Get.to(()=> JobPage(title: job.title, id: job.id, agentName: job.agentName, agentPic: job.agentPic,));},
                          );
                        });
                  }
                }),
          );
        });
  }

  Widget buildPopularShimmer()=> ListView.builder(
    itemCount: 3,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index){
      return Padding(
          padding: EdgeInsets.only(right:12.w),
        child: ShimmerPWidget.rectangular(height: Dimensions.height*0.3, width: Dimensions.width*0.69),
      );
    },
  );
}
