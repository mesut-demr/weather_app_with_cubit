# weather_app_with_cubit

A simple weather App created using Flutter and Dart and using API from [WeatherApi](https://www.weatherapi.com/)

**A screenshot from the evening hours**
//ekran kaydı gelecek 

**A screenshot from the morning hours**
//ekran kaydı gelecek


# App Architecture

- [x] The **BloC (cubit)** structure was used to manage the state.
- [x] The **dio** package was used to pull the api.
- [x] The user's position is stored with **shared_preferences**.
- [x] The **geolocator** package was used to track the user's location.
- [x] The **equatable** package was used to compare the objects.

# Supported Features

- Current temperature, condition, feels like temperature, wind, humidity, uv, vision, cloud and last updated.
- It retrieves the weather forecast based on the user's location.
- After receiving the user's location at the first login to the application, the location is held in memory with **shared_preferences** and the location is prevented from opening at each login.   
- The user can view the weather conditions of the desired city by selecting it from the list of cities.
- Change the background colour and message content according to the time change.
