import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobhub/controllers/exports.dart';
import 'package:jobhub/services/helpers/auth_helper.dart';
import 'package:jobhub/views/common/backBtn.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/auth/skills.dart';
import 'package:jobhub/views/ui/auth/update_user.dart';
import 'package:jobhub/views/ui/home/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_constants.dart';
import '../../../models/response/auth/profile_model.dart';
import '../../common/app_bar.dart';
import '../../common/app_style.dart';
import '../../common/custom_outline_btn.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/loader.dart';
import '../../common/reusable_text.dart';
import '../agents/be_agent.dart';
import '../jobs/add_jobs_profile.dart';
import 'non_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.drawer});
  final bool drawer;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late Future<ProfileRes> userProfile;
  ProfileRes? profile;
  String image = 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTAxL3JtNjA5LXNvbGlkaWNvbi13LTAwMi1wLnBuZw.png';

  @override
  void initState() {
    super.initState();
    getProfile();
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),)
      ..addListener(() {
        setState(() {});
      });
  }

  getProfile() {
    var loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    if (widget.drawer == false && loginNotifier.loggedIn == true) {
      userProfile = AuthHelper.getProfile();
    } else if (widget.drawer == true && loginNotifier.loggedIn == true) {
      userProfile = AuthHelper.getProfile();
    } else {}
  }

  late AnimationController loadingController;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  void openFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
      allowMultiple: false,
    );

    if (result != null) {
      file = File(result.files.single.path!);
      platformFile = result.files.first;

      Reference ref = _storage.ref().child('pdfFromProfile').child(userUid);
      UploadTask uploadTask = ref.putFile(file!);
      TaskSnapshot snapshot = await uploadTask;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      pdfUrlFromProfile = downloadUrl;
    } else {
      // User canceled the picker
    }
    loadingController.forward();
  }

  File? file;
  PlatformFile? platformFile;
  Uint8List? _image;

  void selectImage() async{
    Uint8List img = await pickUserImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    saveImage(_image);
  }

  saveImage(path) async{
    String res = await StoreData().uploadImageToStorage('profileImage',_image!);
  }

  @override
  Widget build(BuildContext context) {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: !loginNotifier.loggedIn ? Color(kLight.value) : const Color(0xFF3281E3),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            color: !loginNotifier.loggedIn ? Color(kLight.value) : Color(kNewBlue.value),
            text: loginNotifier.loggedIn ?
            profile == null ?'loading..':profile!.username
                : '',
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: widget.drawer == false ?
                GestureDetector(
                  onTap: (){
                    Get.off(()=> const MainScreen());
                  },
                  child: Icon(AntDesign.leftcircleo, color: !loginNotifier.loggedIn ? Color(kDark.value) : Color(kLight.value),),
                )
                    : DrawerWidget(
                  color: !loginNotifier.loggedIn ? Color(kDark.value) : Color(kLight.value),),
              ))),
          body: loginNotifier.loggedIn == false ? const NonUser() :
          Stack(
            children: [
              Positioned(
                  top: 0, right: 0, bottom: 0, left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                    height: 80.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                        color: Color(kLightBlue.value)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _image != null ?
                            GestureDetector(
                              onTap: selectImage,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(99.r)),
                                  child: CircleAvatar(
                                    radius: 33.r,
                                    backgroundImage: MemoryImage(_image!),
                                  )
                              ),
                            )
                                :
                            GestureDetector(
                              onTap: selectImage,
                              child: CircularProfileAvatar(
                                  image:
                                  profile == null?
                                  image : profile!.profile,
                                  w: 50.w, h: 50.h),
                            ),
                            SizedBox(width: 10.w,),
                            SizedBox(
                              height: 50.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(7.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white30,
                                          borderRadius: BorderRadius.all(Radius.circular(20.r))
                                      ),
                                      child: ReusableText(text: profile == null ?'loading..':profile!.email,
                                          style: appstyle(14.sp, Color(kDark.value), FontWeight.w400))),
                                ],
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=> const UpdateUser());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Icon(Feather.edit, color: Color(kLight.value),),
                          ),
                        )
                      ],
                    ),
                  )),
              Positioned(
                right: 0, left: 0, bottom: 0, top: 90.w,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r)),
                    color: Color(kLight.value)
                  ),
                  child: FutureBuilder(future: userProfile,
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: Loader(text: 'Fetching data..'),);
                        } else if(snapshot.hasError){
                          return Text('Error: ${snapshot.error}');
                        }else{
                          profile = snapshot.data;
                        return buildStyleContainer(
                          context,
                          ListView(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            children: [
                              SizedBox(height: 30.h),
                              ReusableText(text: 'Profile', style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: (){
                                  openFile();
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: Dimensions.width,
                                      height: Dimensions.height*0.10,
                                      decoration: BoxDecoration(
                                          color: Color(kLightGrey.value), borderRadius: BorderRadius.all(Radius.circular(12.r))
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 12.w),
                                            width: 50.w, height: 60.h,
                                            decoration: BoxDecoration(
                                                color: Color(kLight.value),
                                                borderRadius: BorderRadius.all(Radius.circular(12.r))
                                            ),
                                            child: Icon(FontAwesome5Regular.file_pdf, color: Colors.red, size: 30.sp,),
                                          ),
                                          SizedBox(width: 7.w,),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ReusableText(text: 'Upload your resume', style: appstyle(16.sp, Color(kDark.value), FontWeight.w500)),
                                              SizedBox(height: 5.w,),
                                              FittedBox(
                                                child: Text('Please make sure you upload your resume in PDF format',
                                                  style: appstyle(9.sp, Color(kDarkGrey.value), FontWeight.w400),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 1.w,)
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        right: 0.w,
                                        child: EditButton(
                                            onTap:(){}
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(height: 15.h,),
                              platformFile!=null?
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      offset: const Offset(0, 1),
                                      blurRadius: 3, spreadRadius: 2
                                    )
                                  ]
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ReusableText(text: platformFile!.name, style: appstyle(12.sp, Color(kDark.value), FontWeight.normal)),
                                    SizedBox(height: 2.h,),
                                    ReusableText(text: '${(platformFile!.size/1024).ceil()} KB', style: appstyle(11.sp, Color(kDarkGrey.value), FontWeight.normal)),
                                    SizedBox(height: 2.h,),
                                    Container(
                                      height: 4.h,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue.shade200
                                      ),
                                      child: LinearProgressIndicator(
                                        value: loadingController.value,
                                      ),
                                    )
                                  ],
                                ),
                              )
                              : const SizedBox.shrink(),
                              SizedBox(height: 10.h,),
                              const SkillsWidget(),
                              SizedBox(height: 20.h,),
                              profile!.isAgent? /////
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReusableText(text: 'Agent Section',
                                      style: appstyle(14.sp, Color(kDark.value), FontWeight.w600)),
                                  SizedBox(height: 10.h),
                                  CustomOutlineBtn(text: 'Upload Job',
                                    onTap: (){
                                      Get.to(()=> const AddJobsFromProfile());
                                    },
                                    color: Color(kOrange.value), width: Dimensions.width, height: 40.h,),
                                ],
                              )
                                  :
                                  CustomOutlineBtn(text: 'Apply to become an agent',
                                    color: Color(kOrange.value), height: 40.h,
                                    onTap: (){
                                    profileUpdate = profile;
                                    Get.to(()=> const BeAnAgent());},),
                              SizedBox(height: 20.h),
                              CustomOutlineBtn(text: 'Proceed to logout',
                                onTap: (){
                                  zoomNotifier.currentIndex = 0;
                                  loginNotifier.logOut();
                                  Get.to(()=> const MainScreen());
                                },
                                color: Color(kOrange.value), width: Dimensions.width, height: 40.h,)
                            ],
                          ),
                        );
                        }
                      }),
                ),
              ),
            ]
          )
    );
  }
}

class CircularProfileAvatar extends StatelessWidget {
  const CircularProfileAvatar({super.key, required this.image, required this.w, required this.h,});
  final String image;
  final double w; final double h;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(99.r)),
      child: CachedNetworkImage(imageUrl: image, width: w, height: h, fit: BoxFit.cover,
       placeholder: (context, url)=> const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
        errorWidget: (context, url, error)=> const Icon(Icons.error),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: Color(kOrange.value),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(9.r), bottomLeft: Radius.circular(9.r),
          )
        ),
        child: ReusableText(text: 'Edit', style: appstyle(11.sp, Color(kLight.value), FontWeight.w500)),
      ),
    );
  }
}

