enum WeatherState{initial, loading, completed, errorMesssage}

class WeatherModel {
  final String city;
  final String condition;
  final double temperature;

  WeatherModel({required this.city, required this.condition, required this.temperature});
}