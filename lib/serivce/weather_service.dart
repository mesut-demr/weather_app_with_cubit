import 'package:dio/dio.dart';

class WeatherApiService {
  final Dio _dio = Dio();

  Future<Weather> fetchWeatherForUserLocation() async {
    try {
      Response response = await _dio
          .get('https://api.weatherapi.com/v1/current.json', queryParameters: {
        'key': '',
        'q': '',
      });

      return Weather
    } catch (e) {}
  }
}
