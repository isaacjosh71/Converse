import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/controllers/bookmark_provider.dart';
import 'package:jobhub/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhub/views/common/page_loader.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/bookmarks/widgets/bookmark_widget.dart';
import 'package:jobhub/views/ui/jobs/widgets/uploaded_tile.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../controllers/login_provider.dart';
import '../../common/app_bar.dart';
import '../../common/app_style.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/reusable_text.dart';
import '../auth/non_user.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: Color(kNewBlue.value),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            color: Color(kNewBlue.value),
            text: !loginNotifier.loggedIn ? '':'Bookmarks',
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: DrawerWidget(color: Color(kLight.value),),
              ))),
      body: loginNotifier.loggedIn == false ? const NonUser() :
          Consumer<BookMarkNotifier>(builder: (context, bookNotifier, child){
            bookNotifier.getAllBookmarks();
            var bookmarks = bookNotifier.getAllBookmarks();
            return Stack(
              children: [
                Positioned(
                  top: 0, left: 0, bottom: 0, right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)
                        ),
                        color: Color(kGreen.value)
                      ),
                      child: buildStyleContainer(context,
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: FutureBuilder<List<AllBookmarks>>(
                          future: bookmarks,
                          builder: ((context, snapshot){
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return const PageLoader();
                            } else if(snapshot.hasError){return Text('Error: ${snapshot.error}');}
                            else{
                              var storedBookMarks = snapshot.data;
                            return ListView.builder(
                              itemCount: storedBookMarks!.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index){
                                final storedBookmark = storedBookMarks[index];
                                print(storedBookmark.id);
                                return BookmarkTile(bookmark: storedBookmark);
                                });
                            }
                          })),
                      )
                      ),
                    ))
              ],
            );
          })
    );
  }
}