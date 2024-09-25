import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:api_practice/screen/post_screen.dart';
import 'package:api_practice/screen/profile_screen.dart';
import 'package:api_practice/widgets/image_cached.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final search = TextEditingController();

  bool show = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SearchBox(),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter SearchBox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          width: double.infinity,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.all(
              Radius.circular(10.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Ensures vertical alignment
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        show = value.isEmpty;
                      });
                    },
                    controller: search,
                    decoration: InputDecoration(
                      hintText: 'Search User',
                      hintStyle: const TextStyle(color: Colors.black),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h), // Adjust padding
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
