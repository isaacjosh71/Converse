import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobhub/controllers/zoom_provider.dart';
import 'package:jobhub/models/response/jobs/get_job.dart';
import 'package:jobhub/services/helpers/jobs_helper.dart';

import '../constants/app_constants.dart';
import '../models/response/jobs/jobs_response.dart';
import '../views/ui/home/mainscreen.dart';


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

 postJobs(String model, ZoomNotifier zoomNotifier){
   JobsHelper.createJob(model).then((response){
     if(response==true){
       zoomNotifier.currentIndex = 0;
       Get.to(()=> const MainScreen());
     } else{
       Get.snackbar('Failed to create jobs', 'Please try again',
           backgroundColor: Color(kDarkPurple.value),
           colorText: Color(kLight.value), icon: const Icon(Icons.add_alert)
       );
     }
   });
 }
}
