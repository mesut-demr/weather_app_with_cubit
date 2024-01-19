class WeatherModel {
  final String city;
  final String condition;
  final double temperature;
  final double feelslike_c;
  final String last_updated;
  final double wind_kph;
  final int humidity;

  WeatherModel({
    required this.city,
    required this.condition,
    required this.temperature,
    required this.feelslike_c,
    required this.last_updated,
    required this.wind_kph,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location']['name'],
      condition: json['current']['condition']['text'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      feelslike_c: (json['current']['feelslike_c'] as num).toDouble(),
      last_updated: json['current']['last_updated'],
      wind_kph: (json['current']['wind_kph'] as num).toDouble(),
      humidity: json['current']['humidity'],
    );
  }
}
