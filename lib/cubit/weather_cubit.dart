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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? savedLatitude = prefs.getDouble('latitude');
    double? savedLongitude = prefs.getDouble('longitude');

    if (savedLatitude != null && savedLongitude != null) {
      await fetchWeatherForLocation(savedLatitude, savedLongitude);
    } else {
      await _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    print('Requested Location Permission: $permission');

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print('Requested Location Permission: $permission');
      if (permission == LocationPermission.denied) {
        emit(state.copyWith(
            status: WeatherStatus.errorMessage,
            errorMessage: 'Location permission denied'));
        return;
      }
    }

    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      emit(state.copyWith(
          status: WeatherStatus.errorMessage,
          errorMessage: 'Location services are disabled. Please enable them.'));
      return;
    }
    try {
      await fetchWeatherForUserLocation();
    } catch (e) {
      emit(state.copyWith(
          status: WeatherStatus.errorMessage,
          errorMessage: 'Failed to fetch weather: $e'));
    }
  }

  Future<void> fetchWeatherForUserLocation() async {
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );
    try {
      Position currentPosition = await locationService.getCurrentLocation();
      await _saveLocationToPrefs(
          currentPosition.latitude, currentPosition.longitude);
      await fetchWeatherForLocation(
          currentPosition.latitude, currentPosition.longitude);
    } catch (e) {
      emit(state.copyWith(
          status: WeatherStatus.errorMessage,
          errorMessage: 'Hava Durumu Alınamadı:$e'));
    }
  }

  Future<void> fetchWeatherForLocation(
      double latitude, double longitude) async {
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );
    try {
      WeatherModel newWeather = await weatherApiService.fetchWeatherForLocation(
          latitude, longitude); // Hava durumu API'den alınır
      emit(state.copyWith(
          status: WeatherStatus.completed, weatherModel: newWeather));
    } catch (e) {
      emit(state.copyWith(
          status: WeatherStatus.errorMessage,
          errorMessage: 'Hava Durumu Alınamadı:$e'));
    }
  }

  Future<void> _saveLocationToPrefs(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  void _startListeningLocationChanges() {
    _locationSubscription = locationService
        .listenLocationChanges()
        .listen((Position position) async {
      // Konum değiştiğinde hava durumu bilgisini güncelle
      WeatherModel newWeather =
          await weatherApiService.fetchWeatherForUserLocation();
      emit(
        state.copyWith(
            status: WeatherStatus.completed, weatherModel: newWeather),
      );
    });
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

  String getGreetingsMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 10) {
      return 'Günaydın';
    } else if (hour >= 10 && hour < 18) {
      return 'İyi Günler';
    } else if (hour >= 18 && hour < 24) {
      return 'İyi Akşamlar';
    } else {
      return 'İyi Geceler';
    }
  }
}
