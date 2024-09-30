import 'package:api_practice/providers/user_provider.dart';
import 'package:api_practice/screen/login_screen.dart';
import 'package:api_practice/screen/update_screen.dart';
import 'package:api_practice/widgets/column_widget.dart';
import 'package:api_practice/widgets/custom_list_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:api_practice/widgets/image_cached.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored preferences
    Provider.of<UserProvider>(context, listen: false).setAllToNull();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 25.h),
              Expanded(child: Head(userProvider)), // Wrap Head with Expanded
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Head(UserProvider provider) {
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
                    "http://192.168.18.27:3000${provider.profileImage!}",
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
                  'Username: ${provider.username ?? ''}',
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
          CustomListTile(
            leadingIcon: Icons.update,
            text: 'Update Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UpdateProfileScreen()),
              );
            },
          ),
          CustomListTile(
            leadingIcon: Icons.logout,
            text: 'Logout',
            onTap: () {
              _logout(context);
            },
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
