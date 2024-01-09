import 'package:equatable/equatable.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';

enum WeatherStatus { initial, loading, completed, errorMessage }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final WeatherModel? weatherModel;
  final String? errorMessage;

  const WeatherState({required this.status, this.weatherModel, this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [status, weatherModel, errorMessage];

  WeatherState copyWith(
      {WeatherStatus? status,
      WeatherModel? weatherModel,
      String? errorMessage}) {
    return WeatherState(
        status: status ?? this.status,
        weatherModel: weatherModel ?? this.weatherModel,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
