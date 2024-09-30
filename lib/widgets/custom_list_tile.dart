import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String text;
  final bool? doesnotContainsDivider;
  final bool? hasRedColor;
  final Function() onTap;

  const CustomListTile({
    super.key,
    required this.leadingIcon,
    required this.text,
    this.doesnotContainsDivider,
    required this.onTap,
    this.hasRedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 3.w),

              // Icon in grey circle
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasRedColor != true
                      ? Colors.grey.shade300
                      : Colors.red.shade50,
                ),
                padding: EdgeInsets.all(2.w),
                child: Icon(
                  leadingIcon,
                  color:
                      hasRedColor != true ? Colors.grey.shade700 : Colors.red,
                  size: 15.sp,
                ),
              ),
              SizedBox(width: 4.w),
              // Text
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: hasRedColor != true
                          ? Colors.grey.shade700
                          : Colors.red),
                ),
              ),
              // Chevron icon
              if (hasRedColor != true)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade700,
                ),
              SizedBox(width: 3.w),
            ],
          ),
          // Divider
          if (doesnotContainsDivider != true) const Divider(),
        ],
      ),
    );
  }
}
