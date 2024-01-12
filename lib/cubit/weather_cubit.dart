import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_with_cubit/cubit/weather_state.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';
import 'package:weather_app_with_cubit/serivce/location_service.dart';
import 'package:weather_app_with_cubit/serivce/weather_api_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherApiService weatherApiService = WeatherApiService();
  final LocationService locationService = LocationService();
  late StreamSubscription<Position> _locationSubscription;

  WeatherCubit()
      : super(
          const WeatherState(status: WeatherStatus.loading),
        ) {
    _init();
  }

Future<void> _init() async {
  bool hasLocationPermission = await _checkLocationPermission();

  if (hasLocationPermission) {
    await fetchWeatherForUserLocation();
    _startListeningLocationChanges();
  } else {
    // Kullanıcıdan konum izni iste
    _requestLocationPermission();
  }
}

Future<bool> _checkLocationPermission() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasLocationPermission') ?? false;
}

  Future<void> fetchWeatherForUserLocation() async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      Position currentPosition = await locationService.getCurrentLocation();
      WeatherModel newWeather =
          await weatherApiService.fetchWeatherForUserLocation();
      emit(state.copyWith(
          status: WeatherStatus.completed, weatherModel: newWeather));
    } catch (e) {
      emit(state.copyWith(
          status: WeatherStatus.errorMessage,
          errorMessage: 'Hava durumu alınamadı: $e'));
    }
  }

  void _startListeningLocationChanges() {
    _locationSubscription = locationService
        .listenLocationChanges()
        .listen((Position position) async {
      // Konum değiştiğinde hava durumu bilgisini güncelle
      WeatherModel newWeather =
          await weatherApiService.fetchWeatherForUserLocation();
      emit(state.copyWith(
          status: WeatherStatus.completed, weatherModel: newWeather));
    });
  }

void _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasLocationPermission', true);

    // Konum izni alındı, hava durumu bilgisini çek ve dinlemeye başla
    await fetchWeatherForUserLocation();
    _startListeningLocationChanges();
  } else {
    print('Konum izni verilmedi. Mevcut izin durumu: $permission');
    emit(state.copyWith(status: WeatherStatus.errorMessage, errorMessage: 'Konum izni verilmedi.'));
  }
}

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    return super.close();
  }

  Future<void> fetchWeatherForCity(String city) async {
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );

    try {
      WeatherModel requestWeather =
          await weatherApiService.fetchWeatherForCity(city);
      emit(
        state.copyWith(
            status: WeatherStatus.completed, weatherModel: requestWeather),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: WeatherStatus.errorMessage,
            errorMessage: 'Hava Durumu Alınamadı.'),
      );
    }
  }
}
