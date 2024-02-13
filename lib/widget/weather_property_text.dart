import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeatherPropertyText extends StatelessWidget {
   WeatherPropertyText({
    super.key,
    required this.title,
     this.fontSize,
     this.fontWeight,
     this.letterSpacing,
     this.color,
  });
String title;
Color? color;
double? fontSize;
FontWeight? fontWeight;
double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(title,
         style: TextStyle(
           color: color?? Colors.grey[200],
           fontSize: fontSize ?? 14.sp,
           fontWeight: FontWeight.w300,
           letterSpacing: letterSpacing,
         ),
       );
  }
}