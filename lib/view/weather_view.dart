import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_with_cubit/cubit/weather_cubit.dart';
import 'package:weather_app_with_cubit/cubit/weather_state.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text('City: ${WeatherModel.conditions[state.weatherModel?.city ?? '']?? ''}'),
                  Text('Condition: ${WeatherModel.conditions[state.weatherModel?.condition ?? '']?? ''}'),
                  Text('Temperature:${WeatherModel.conditions[state.weatherModel?.temperature ?? '']?? ''}°C'),
                  Text('Feels Like: ${WeatherModel.conditions[state.weatherModel?.feelslike_c ?? '']?? ''}°C'),
                  Text('Last Updated: ${WeatherModel.conditions[state.weatherModel?.last_updated ?? '']?? ''}'),
                  Text('Wind Speed: ${WeatherModel.conditions[state.weatherModel?.wind_kph ?? '']?? ''} kph'),
                  Text('Humidity: ${WeatherModel.conditions[state.weatherModel?.humidity ?? '']?? ''}%'),
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
