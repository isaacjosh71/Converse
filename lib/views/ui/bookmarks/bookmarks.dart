import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub/controllers/bookmark_provider.dart';
import 'package:jobhub/models/response/bookmarks/all_bookmarks.dart';
import 'package:jobhub/services/helpers/book_helper.dart';
import 'package:jobhub/views/common/style_container.dart';
import 'package:jobhub/views/ui/bookmarks/widgets/bookmark_widget.dart';
import 'package:jobhub/views/ui/jobs/widgets/uploaded_tile.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../../controllers/login_provider.dart';
import '../../common/app_bar.dart';
import '../../common/app_style.dart';
import '../../common/drawer/drawer_widget.dart';
import '../../common/loader.dart';
import '../../common/reusable_text.dart';
import '../../common/shimmer.dart';
import '../auth/non_user.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {

  late Future<List<AllBookmarks>> bookmarks;

  getBookmarks() {
    bookmarks = BookMarkHelper.getAllBookMarks();
  }

  @override
  void initState(){
    super.initState();
    getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: !loginNotifier.loggedIn ? Color(kLight.value) : const Color(0xFF3281E3),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            color: !loginNotifier.loggedIn ? Color(kLight.value) : Color(kNewBlue.value),
            text: !loginNotifier.loggedIn ? '':'Bookmarks',
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: DrawerWidget(color: !loginNotifier.loggedIn ? Color(kDark.value) : Color(kLight.value),),
              ))),
      body: loginNotifier.loggedIn == false ? const NonUser() :
          Consumer<BookMarkNotifier>(builder: (context, bookNotifier, child){
            bookNotifier.getAllBookmarks();
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
                              return const Center(child: Loader(text: 'Fetching bookmarks..'),);
                            }
                            else if(snapshot.hasError)
                            {
                              return Text('Error: ${snapshot.error}');}
                            else if(snapshot.data!.isEmpty){
                              return const Loader(text: 'No bookmarks found');
                            }
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