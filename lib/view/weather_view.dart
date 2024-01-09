import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  Text(
                      'Temperature: ${state.weatherModel?.temperature ?? ''}°C'),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              weatherCubit.fetchWeatherForUserLocation();
            },
            tooltip: 'Fetch Weather for User Location',
            child: const Icon(Icons.location_on),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _showCityInputDialog(context, weatherCubit);
            },
            tooltip: 'Fetch Weather for City',
            child: const Icon(Icons.location_city),
          ),
        ],
      ),
    );
  }

  void _showCityInputDialog(BuildContext context, WeatherCubit weatherCubit) {
    TextEditingController _cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter City'),
          content: TextField(
            controller: _cityController,
            decoration: const InputDecoration(hintText: 'City Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                weatherCubit.fetchWeatherForCity(_cityController.text);
                Navigator.pop(context);
              },
              child: const Text('Fetch Weather'),
            ),
          ],
        );
      },
    );
  }
}
