import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColumnWidget extends StatelessWidget {
  final String upperText;
  final String lowerText;
  const ColumnWidget(
      {super.key, required this.upperText, required this.lowerText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          upperText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          lowerText,
          style: TextStyle(fontSize: 13.sp, color: Colors.black),
        ),
      ],
    );
  }
}
