import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_with_cubit/model/weather_model.dart';
import 'package:weather_app_with_cubit/serivce/location_service.dart';

class WeatherApiService {
  final Dio _dio = Dio();
  final LocationService _locationService = LocationService();

  Future<WeatherModel> fetchWeatherForUserLocation() async {
    try {
      Position currentPosition = await _locationService.getCurrentLocation();

      Response response = await _dio
          .get('https://api.weatherapi.com/v1/current.json', queryParameters: {
        'key': '96547a1fea574a13b4f90130232811',
        'q': '${currentPosition.latitude},${currentPosition.longitude}',
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
        'key': '96547a1fea574a13b4f90130232811',
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