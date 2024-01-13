import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/views/common/page_loader.dart';
import 'package:jobhub/views/ui/jobs/widgets/uploaded_tile.dart';
import 'package:provider/provider.dart';
import '../../../../models/response/jobs/jobs_response.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(builder: (context, jobsNotifier, child){
      jobsNotifier.getJobs();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: FutureBuilder<List<JobsResponse>>(
            future: jobsNotifier.jobList,
            builder: (context, snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return const PageLoader();
              } else if(snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              } else if(snapshot.data!.isEmpty){
                return const Text('No jobs found');
              } else {
                final jobs = snapshot.data;
                return ListView.builder(
                    itemCount: jobs!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      var job = jobs[index];
                      return UploadedTile(job: job, text: 'popular',);
                    });
              }
            }),
      );
    });
  }
}
