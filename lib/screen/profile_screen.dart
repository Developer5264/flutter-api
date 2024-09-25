import 'package:api_practice/widgets/column_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:api_practice/widgets/image_cached.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool yourse = false;
  List following = [];
  bool follow = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 25.h),
              Expanded(child: Head()), // Wrap Head with Expanded
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Head() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: CachedImage(
                    "https://cdn-icons-png.flaticon.com/512/5110/5110617.png",
                  ),
                ),
              ),
              ColumnWidget(
                upperText: '0',
                lowerText: 'Posts',
              ),
              ColumnWidget(
                upperText: '93',
                lowerText: 'Followers',
              ),
              ColumnWidget(
                upperText: '13',
                lowerText: 'Following',
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Armaghan",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Bio: Armaghan Mubeen Butt",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Visibility(
            visible: !follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: yourse ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: yourse ? Colors.grey.shade400 : Colors.blue,
                    ),
                  ),
                  child: yourse
                      ? Text('Edit Your Profile')
                      : Text(
                          'Follow',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.center,
                        height: 30.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text('Unfollow'),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        'Message',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.h),
          SizedBox(
            width: double.infinity,
            height: 30.h,
            child: const TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Icon(Icons.grid_on),
                Icon(Icons.video_collection),
                Icon(Icons.person),
              ],
            ),
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
