# weather_app_with_cubit

A simple weather App created using Flutter and Dart and using API from [WeatherApi](https://www.weatherapi.com/)

**A screenshot from the evening hours**
//ekran kaydı gelecek 

**A screenshot from the morning hours**
//ekran kaydı gelecek


https://github.com/mesut-demr/weather_app_with_cubit/assets/81968170/cb92d4e4-1a23-4e41-a43c-bd847e89f07a



# App Architecture

- [✔️] The **BloC (cubit)** structure was used to manage the state.
- [✔️] The **dio** package was used to pull the api.
- [✔️] The user's position is stored with **shared_preferences**.
- [✔️] The **geolocator** package was used to track the user's location.
- [✔️] The **equatable** package was used to compare the objects.


# Supported Features

- Current temperature, condition, feels like temperature, wind, humidity, uv, vision, cloud and last updated.
- It retrieves the weather forecast based on the user's location.
- After receiving the user's location at the first login to the application, the location is held in memory with **shared_preferences** and the location is prevented from opening at each login.   
- The user can view the weather conditions of the desired city by selecting it from the list of cities.
- Change the background colour and message content according to the time change.
