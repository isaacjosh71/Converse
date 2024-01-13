import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub/views/ui/jobs/widgets/vertical_tile.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_constants.dart';
import '../../../../controllers/jobs_provider.dart';
import '../../../../models/response/jobs/jobs_response.dart';
import '../job_page.dart';
import 'horizontal_tile.dart';

class RecentJob extends StatelessWidget {
  const RecentJob({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
        builder: (context, jobsNotifier, child){
          jobsNotifier.getRecent();
          return SizedBox( height: height*0.28,
            child: FutureBuilder<List<JobsResponse>>(
                future: jobsNotifier.recentJob,
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator.adaptive(),);
                  } else if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  } else if(snapshot.data!.isEmpty){
                    return const Text('No jobs found');
                  } else {
                    final jobs = snapshot.data;
                    return ListView.builder(
                        itemCount: jobs!.length,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          var job = jobs[index];
                          return JobVerticalTile(job: job);
                        });
                  }
                }),
          );
        });
  }
}
