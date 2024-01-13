
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../../constants/app_constants.dart';
import '../../common/buildtextfield.dart';

class AddSkills extends StatelessWidget {
  const AddSkills({super.key, required this.skill, this.onTap});
  final TextEditingController skill;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.h),
      height: 60.h,
      child: buildTextField(
        controller: skill, hintText: 'Add new skill',
      suffixIcon: GestureDetector(
        onTap: onTap,
        child: Icon(Entypo.upload_to_cloud, size: 30.sp, color: Color(kNewBlue.value),),
      ),
        onSubmitted: (p0){
          if(p0!.isEmpty){return 'Please enter skill name';}
          else{return null;}
        },
      ),
    );
  }
}
