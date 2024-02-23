import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/views/common/app_bar.dart';
import 'package:jobhub/views/common/backBtn.dart';
import 'package:jobhub/views/ui/jobs/widgets/popular_job_list.dart';
import 'package:jobhub/views/ui/jobs/widgets/recent_job_list.dart';

import '../../../constants/app_constants.dart';

class RecentJobList extends StatelessWidget {
  const RecentJobList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kLight.value),
      appBar: PreferredSize(preferredSize: Size.fromHeight(50.h),
          child: const CustomAppBar(
              text: 'Jobs',
              child: BackBtn())),
      body: const RecentJobListPage(),
    );
  }
}
