import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_with_cubit/cubit/weather_cubit.dart';
import 'package:weather_app_with_cubit/cubit/weather_state.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherCubit weatherCubit = BlocProvider.of<WeatherCubit>(context);
    return Scaffold(
      body: Center(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state.status == WeatherStatus.loading) {
              return const CircularProgressIndicator();
            } else if (state.status == WeatherStatus.completed) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('City: ${state.weatherModel?.city ?? ''}'),
                  Text('Condition: ${state.weatherModel?.condition ?? ''}'),
                  Text('Temperature: ${state.weatherModel?.temperature ?? ''}°C'),
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

