import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherCard extends StatelessWidget {
   WeatherCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
  });
String title;
String subTitle;
IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Column(
     children: [
       Container(
       height: 25.h,
       width: 150.w,
       decoration: BoxDecoration(
         color: Colors.black38,
         borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r),topRight:Radius.circular(12.r)),
         ),
       child: Text(title,style: 
       TextStyle(
       color: Colors.grey[200],
      fontSize: 12.sp,
     fontWeight: FontWeight.w400,
     height: 2.h
     ),
     textAlign: TextAlign.center,
     ),
     ),
     Container(
       height: 50.h,
       width: 150.w,
       decoration: BoxDecoration(
         color: Colors.white.withOpacity(0.8),
         borderRadius: BorderRadius.only(bottomLeft:Radius.circular(12.r),bottomRight: Radius.circular(12.r)),
       ),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
         Icon(icon,color: Colors.indigo[400],size: 24.sp,),
         Text(subTitle, style: 
         TextStyle(
         color: Colors.indigo[600],
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
         ),
         textAlign: TextAlign.center,
         ),
       ],
       ),
     ),
    ]
    );
  }
}