import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jobhub/constants/app_constants.dart';
import 'package:jobhub/controllers/agent_provider.dart';
import 'package:jobhub/views/common/app_style.dart';
import 'package:provider/provider.dart';

class MessagingField extends StatelessWidget {
  const MessagingField({super.key, required TextEditingController messageController,
    required FocusNode messageFocusNode, this.onTap, this.sendText})
      :_messageController = messageController, _messageFocusNode= messageFocusNode;

  final TextEditingController _messageController;
  final FocusNode _messageFocusNode;
  final void Function()? onTap;
  final void Function()? sendText;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            topLeft: Radius.circular(20.r)
        ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        width: width, height: 80.h,
        color: Colors.white,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 1,
          controller: _messageController,
          focusNode: _messageFocusNode,
          onTap: onTap,
          style: appstyle(12.sp, Colors.black, FontWeight.normal),
          decoration: InputDecoration(
            suffixIcon: SizedBox(
              width: 60.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){},
                    child: Icon(EvilIcons.image, size: 30.w,),
                  ),
                  Consumer<AgentNotifier>(builder: (context, agentNotifier, child){
                    return GestureDetector(
                      onTap: sendText,
                      child: Icon(MaterialCommunityIcons.send, color: Color(kNewBlue.value),),
                    );
                  })
                ],
              ),
            ),
            hintText:'send message...',
            hintStyle: appstyle(12.sp, Color(kDarkGrey.value), FontWeight.normal),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none)
          ),
        ),
      ),
    );
  }
}
