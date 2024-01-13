import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/controllers/agent_provider.dart';
import 'package:jobhub/models/response/jobs/jobs_response.dart';
import 'package:jobhub/views/common/page_loader.dart';
import 'package:jobhub/views/ui/jobs/widgets/uploaded_tile.dart';
import 'package:provider/provider.dart';

class AgentJobs extends StatelessWidget {
  const AgentJobs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentNotifier>(builder: (context, agentNotifier, child){
      agentNotifier.getAgentJobs(agentNotifier.agents!.uid);
      return FutureBuilder<List<JobsResponse>>(
          future: agentNotifier.agentJobs,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const PageLoader();
            } else if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            } else {
              var jobs = snapshot.data;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: ListView.builder(
                  itemCount: jobs!.length,
                    itemBuilder: (context, index){
                    var job = jobs[index];
                    return UploadedTile(job: job, text: 'Agent');
                }),
              );
            }
      });
    });
  }
}
