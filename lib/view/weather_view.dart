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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
           //   Color(0xFF16C1F7), //dark theme eklenecek
           //   Color(0xFF146DF3),
            Color(0xFF146DF3),
            Color(0xFF14C2F5),
          ],
        ),
        ),
        child: Center(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state.status == WeatherStatus.loading) {
                return const CircularProgressIndicator();
              } else if (state.status == WeatherStatus.completed) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${context.read<WeatherCubit>().getGreetingsMessage()}'),
                    Text(
                      'Condition: ${WeatherModel.conditions[state.weatherModel?.condition ?? ''] ?? ''}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Image.asset(WeatherModel.getConditionGif()?? ''),
                    Text(
                      'Temperature: ${state.weatherModel?.temperature ?? ''}°C',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'City: ${state.weatherModel?.city ?? ''}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Last Updated: ${state.weatherModel?.last_updated ?? ''}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'Feels Like: ${state.weatherModel?.feelslike_c ?? ''}°C',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Wind Speed: ${state.weatherModel?.wind_kph ?? ''} kph',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Humidity: ${state.weatherModel?.humidity ?? ''}%',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              } else if (state.status == WeatherStatus.errorMessage) {
                return Text('Error: ${state.errorMessage}');
              } else {
                return const Text('Press the buttons to fetch weather data.');
              }
            },
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

//saate göre tema ayarlaması--> mavi ekran siyah ekran
//gifler eklenecek
//konumun hafızada tutulması--> +
//şehirlere göre arama yapma
//tasarımın ayarlanması
