import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherCard extends StatelessWidget {
   WeatherCard({
    super.key,
    required this.title,
  });
String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: 180.w,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        color: Colors.black26,
        elevation: 100,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}