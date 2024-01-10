import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_with_cubit/cubit/weather_state.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';
import 'package:weather_app_with_cubit/serivce/weather_api_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherApiService weatherApiService = WeatherApiService();

  WeatherCubit()
      : super(
          const WeatherState(status: WeatherStatus.initial),
        );

  Future<void> fetchWeatherForUserLocation() async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      WeatherModel newWeather =
          await weatherApiService.fetchWeatherForUserLocation();
      emit(
        state.copyWith(
            status: WeatherStatus.completed, weatherModel: newWeather),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: WeatherStatus.errorMessage, errorMessage: 'Hava Hata'),
      );
    }
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
