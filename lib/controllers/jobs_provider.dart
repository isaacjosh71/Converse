import 'package:flutter/foundation.dart';
import 'package:jobhub/models/response/jobs/get_job.dart';
import 'package:jobhub/services/helpers/jobs_helper.dart';

import '../models/response/jobs/jobs_response.dart';


class JobsNotifier extends ChangeNotifier {
 late Future<List<JobsResponse>> jobList;
 late Future<List<JobsResponse>> recentJob;
 late Future<GetJobRes> job;

 Future<List<JobsResponse>> getJobs(){
   jobList = JobsHelper.getJobs();
   return jobList;
 }

 Future<GetJobRes> getJob(String jobId){
   job = JobsHelper.getJob(jobId);
   return job;
 }

 Future<List<JobsResponse>> getRecent(){
   recentJob = JobsHelper.getRecent();
   return recentJob;
 }
}
