import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/services/helpers/jobs_helper.dart';
import 'package:jobhub/views/common/loader.dart';
import 'package:jobhub/views/ui/jobs/widgets/vertical_tile.dart';
import 'package:jobhub/views/ui/search/widgets/custom_field.dart';

import '../../../models/response/jobs/jobs_response.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kLight.value),
      appBar: AppBar(
        backgroundColor: Color(kLight.value),
        automaticallyImplyLeading: false, elevation: 0,
        title: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25.r),),
          child: CustomField(onTap: (){
            setState(() {

            });
          }, controller: controller),
        ),
      ),
      body: controller.text.isNotEmpty ?
      Padding(padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: FutureBuilder<List<JobsResponse>>(
          future: JobsHelper.searchJobs(controller.text),
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
                  itemBuilder: (context, index){
                    var job = jobs[index];
                    return JobVerticalTile(
                      job: job,
                    );
                  });
            }
          }),
      )
      :
          const Center(child: Loader(text: 'No jobs found'))
      ,
    );
  }
}
