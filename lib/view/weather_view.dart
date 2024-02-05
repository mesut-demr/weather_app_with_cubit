import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_with_cubit/cubit/weather_cubit.dart';
import 'package:weather_app_with_cubit/cubit/weather_state.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTime = TimeOfDay.now();
    final isDayTime = currentTime.hour > 6 && currentTime.hour < 20;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: isDayTime
                  ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 17, 192, 245),
                        Color(0xFF146DF3),
                      ],
                    )
                  : const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 36, 37, 37),
                        Color.fromARGB(255, 44, 78, 110),
                      ],
                    ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 12.w),
              child: Center(
                child: BlocBuilder<WeatherCubit, WeatherState>(
                  builder: (context, state) {
                    if (state.status == WeatherStatus.loading) {
                      return const CircularProgressIndicator();
                    } else if (state.status == WeatherStatus.completed) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            onChanged: (value) {
                              context.read<WeatherCubit>().filterCitites(value);
                            },
                            decoration: const InputDecoration(
                                labelText: 'Şehir Ara',
                                prefixIcon: Icon(Icons.search),
                                ),
                          ),
                          SizedBox(
                            height: 200.h,
                            child: ListView.builder(
                              itemCount: state.filteredCityList!.length,
                              itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(state.filteredCityList!    [index]),
                                onTap: () {
                                  context.read<WeatherCubit>().selectCity(state.filteredCityList![index]);
                                  print('ffffffffff ${state.filteredCityList![index]}');
                                },
                              );
                            },
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            context.read<WeatherCubit>().getGreetingsMessage(),
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            ' ${state.weatherModel?.city ?? ''}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            ' ${WeatherModel.conditions[state.weatherModel?.condition ?? ''] ?? ''}',
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            ' ${state.weatherModel?.temperature ?? ''}°C',
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 110.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Image.asset(
                            WeatherModel.getConditionGif(
                                state.weatherModel?.condition ?? ''),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            ' ${state.weatherModel?.last_updated ?? ''}', //refresh ile gelebilir
                            style: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Divider(
                              height: 1.h, thickness: 0.5, color: Colors.grey),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
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
                                      'Hissedilen Sıcaklık: ${state.weatherModel?.feelslike_c ?? ''}°C',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
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
                                      'Rüzgar: ${state.weatherModel?.wind_kph ?? ''} kph',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 14.h),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
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
                                      'Nem: ${state.weatherModel?.humidity ?? ''}%',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
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
                                      'UV: ${state.weatherModel?.uv ?? ''}',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
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
                                      'Görüş: ${state.weatherModel?.vis_km ?? ''}km',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
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
                                      'Bulut ${state.weatherModel?.cloud ?? ''}',
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (state.status == WeatherStatus.errorMessage) {
                      return Text('Error: ${state.errorMessage}');
                    } else {
                      return const Text(
                          'Press the buttons to fetch weather data.');
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // İzin iste
      _requestLocationPermission(context);
    } else {
      // İzin zaten var veya kullanıcı daha önce reddetti
      // Burada başka bir şey yapabilirsiniz, örneğin bir mesaj gösterebilirsiniz.
    }
  }

  void _requestLocationPermission(BuildContext context) async {
    // Konum izni iste
    await Geolocator.requestPermission();
    // Diğer işlemleri burada gerçekleştirebilirsiniz, örneğin hava durumu bilgisini çekmeye başlayabilirsiniz.
  }
}

// !!! İlk Açılışta konum izni isteme --->-
//saate göre tema ayarlaması--> +
//gifler eklenecek----> bazıları eklenecek
//konumun hafızada tutulması--> +
//şehirlere göre arama yapma
//tasarımın ayarlanması renk ayarı--->+
