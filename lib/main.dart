import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app_with_cubit/cubit/weather_cubit.dart';
import 'package:weather_app_with_cubit/view/weather_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    print("height: ${MediaQuery.of(context).size.height}");
    print("width: ${MediaQuery.of(context).size.width}");
    return ScreenUtilInit(
      designSize: const Size(392, 850),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: BlocProvider(
        create: (context) => WeatherCubit(),
        child: WeatherView(),
      ),
    );
  }
}
