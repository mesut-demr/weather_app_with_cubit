import 'package:dio/dio.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';

class WeatherApiService {
  final Dio _dio = Dio();

  Future<WeatherModel> fetchWeatherForUserLocation() async {
    try {
      Response response = await _dio
          .get('https://api.weatherapi.com/v1/current.json', queryParameters: {
        'key': '',
        'q': '',
      });

      return WeatherModel(
        city: response.data['location']['name'],
        condition: response.data['current']['condition']['text'],
        temperature: response.data['current']['temp_c'],
      );
    } catch (e) {
      throw Exception('Hava Durumu Bilgisi Alınamadı: $e');
    }
  }

  Future<WeatherModel> fetchWeatherForCity(String city) async {
    try {
      Response response = await _dio
          .get('https://api.weatherapi.com/v1/current.json', queryParameters: {
        'key': '',
        'q': city,
      });

      return WeatherModel(
        city: response.data['location']['name'],
        condition: response.data['current']['condition']['text'],
        temperature: response.data['current']['temp_c'],
      );
    } catch (e) {
      throw Exception('Hava Durumu Bilgisi Alınamadaı: $e');
    }
  }
}


//try üstüne tanımlama yapılabilir