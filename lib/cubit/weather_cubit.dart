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
           WeatherState(status: WeatherStatus.loading),
        ) {
          filterCitites('');
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

  String getGreetingsMessage() {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 11) {
      return 'Günaydın';
    } else if (hour >= 11 && hour < 18) {
      return 'İyi Günler';
    } else if (hour >= 18 && hour < 24) {
      return 'İyi Akşamlar';
    } else {
      return 'İyi Geceler';
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

  final List<String> cityList = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Amasya',
    'Ankara',
    'Antalya',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkari',
    'Hatay',
    'Isparta',
    'Mersin',
    'İstanbul',
    'İzmir',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kırklareli',
    'Kırşehir',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Kahramanmaraş',
    'Mardin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Rize',
    'Sakarya',
    'Samsun',
    'Siirt',
    'Sinop',
    'Sivas',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Şanlıurfa',
    'Uşak',
    'Van',
    'Yozgat',
    'Zonguldak',
    'Aksaray',
    'Bayburt',
    'Karaman',
    'Kırıkkale',
    'Batman',
    'Şırnak',
    'Bartın',
    'Ardahan',
    'Iğdır',
    'Yalova',
    'Karabük',
    'Kilis',
    'Osmaniye',
    'Düzce',
  ];


String selectedCity="";

void filterCitites(String filter){
  emit(state.copyWith(status: WeatherStatus.completed,weatherModel: null, filteredCityList: cityList.where((city) => city.toLowerCase().startsWith(filter.toLowerCase())).toList()));
}

void selectCity(String city){
selectedCity=city;
emit(state.copyWith(status: WeatherStatus.completed,weatherModel: null));
}
}
