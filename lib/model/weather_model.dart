class WeatherModel {
  final String city;
  final String condition;
  final double temperature;
  final double feelslike_c;
  final String last_updated;
  final double wind_kph;
  final int humidity;

  static const Map<String, String> conditions = {
    'Clear': 'Açık',
    'Cloudy': 'Bulutlu',
    'Rainy': 'Yağmurlu',
    'Snowy': 'Karlı',
    'Windy': 'Rüzgarlı',
    'Partly cloudy': 'Parçalı Bulutlu',
    'Mostly Cloudy': 'Çok Bulutlu',
    'Overcast': 'Kapalı',
    'Mist': 'Sisli',
    'Fog': 'Puslu',
    'Light Rain': 'Hafif Yağmur',
    'Heavy Rain': 'Şiddetli Yağmur',
    'Light Snow': 'Hafif Kar',
    'Heavy Snow': 'Şiddetli Kar',
    'Thunderstorm': 'Gök Gürültülü Fırtına',
    'Sunny': 'Güneşli',
    'Patchy rain possible': 'Olası Yağmur',
    'Patchy snow possible': 'Olası Kar',
    'Patchy sleet possible': 'Olası Karla Karışık Yağmur',
    'Patchy freezing drizzle possible': 'Olası Dondurucu Çiseleme',
    'Thundery outbreaks possible': 'Olası Gök Gürültü',
    'Blowing snow': 'Kar Fırtına',
    'Blizzard': 'Kar Fırtınası',
    'Freezing fog': 'Dondurucu Sis',
    'Patchy light drizzle': 'Yer Yer Hafif Çiseleyen Yağmur',
    'Light drizzle': 'Hafif Çiseleyen Yağmur',
    'Freezing drizzle': 'Dondurucu Çiseleme',
    'Heavy freezing drizzle': 'Şiddetli Dondurucu Çiseleme',
    'Patchy light rain': 'Parçalı Hafif Yağmur',
    'Moderate rain at times': 'Zaman Zaman Orta Şiddette Yağmur',
    'Moderate rain': 'Orta Derecede Yağmur',
    'Heavy rain at times': 'Zaman Zaman Şiddetli Yağmur',
    'Light freezing rain': 'Hafif Dondurucu Yağmur',
    'Moderate or heavy freezing rain': 'Orta veya Şiddetli Dondurucu Yağmur',
    'Light sleet': 'Hafif Karla Karışık Ysğmur',
    'Moderate or heavy sleet': 'Orta veya Şiddetli Karla Karışık Yağmur',
    'Patchy light snow': 'Yer Yer Hafif Kar',
    'Patchy moderate snow': 'Düzensiz Orta Şiddette Kar',
    'Moderate snow': 'Orta Derecede Kar',
    'Patchy heavy snow': 'Yer Yer Yoğun Kar',
    'Ice pellets': 'Buz Taneleri',
    'Light rain shower': 'Hafif Yağmur Yağışı',
    'Moderate or heavy rain shower': 'Orta veya Şiddetli Yağmur Yağışı',
    'Torrential rain shower': 'Sağanak Yağmur Yağışı',
    'Light sleet showers': 'Hafif Karla Karışık Yağmur',
    'Moderate or heavy sleet showers':
        'Orta veya Şiddetli Karla Karışık Yağmur',
    'Light snow showers': 'Hafif Kar Yağışı',
    'Moderate or heavy snow showers': 'Orta veya Yoğun Kar Yağışı',
    'Light showers of ice pellets': 'Hafif Buzlu',
    'Moderate or heavy showers of ice pellets': 'Orta veya Şiddetli Buzlu',
    'Patchy light rain with thunder': 'Gök Gürültülü Hafif Yağmur',
    'Moderate or heavy rain with thunder':
        'Gök Gürültülü Orta veya Şiddetli Yağmur',
    'Patchy light snow with thunder': 'Gök Gürültülü Hafif Kar Yağışı',
    'Moderate or heavy snow with thunder': 'Gök Gürültülü Orta veya Yoğun Kar',
  };

  static const Map<String, String> conditionGif = {
    // 'Clear': 'https://cdn.pixabay.com/animation/2023/03/26/01/15/01-15-42-612_512.gif',
    // 'Cloudy': 'https://cdn.pixabay.com/animation/2023/03/26/01/15/01-15-42-612_512.gif',
    // 'Rainy': 'https://cdn.pixabay.com/animation/2023/03/26/01/15/01-15-42-612_512.gif',
    // 'Snowy': 'https://cdn.pixabay.com/animation/2023/03/26/01/15/01-15-42-612_512.gif',
    // 'Windy': 'https://pixabay.com/gifs/rain-storm-temporary-lake-toilet-4943/',
    // 'Partly cloudy': 'https://pixabay.com/gifs/rain-storm-temporary-lake-toilet-4943/',
    // 'Thunderstorm': 'https://pixabay.com/gifs/rain-storm-temporary-lake-toilet-4943/',
    // 'Mist': 'https://pixabay.com/gifs/rain-storm-temporary-lake-toilet-4943/',
    // 'Sunny': 'https://pixabay.com/gifs/rain-storm-temporary-lake-toilet-4943/',
  };

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

  static String _translateCondition(String englishCondition) {
    return conditions[englishCondition] ?? englishCondition;
  }

  static getConditionGif() {
    return conditionGif[conditions] ?? ''; //tırnak içine default bir gif verilebiir
  }
}
