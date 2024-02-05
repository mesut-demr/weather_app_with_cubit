import 'package:equatable/equatable.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';

enum WeatherStatus { initial, loading, completed, errorMessage }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final WeatherModel? weatherModel;
  final String? errorMessage;
  List<String>? filteredCityList = [];


   WeatherState({
    required this.status,
    this.weatherModel,
    this.errorMessage,
    this.filteredCityList,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [status, weatherModel, errorMessage,filteredCityList];

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherModel? weatherModel,
    String? errorMessage,
    List<String>? filteredCityList,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weatherModel: weatherModel ?? this.weatherModel,
      errorMessage: errorMessage ?? this.errorMessage,
      filteredCityList:filteredCityList ?? this.filteredCityList,
    );
  }

}
