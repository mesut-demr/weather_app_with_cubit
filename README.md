# weather_app_with_cubit

A simple weather App created using Flutter & Dart and using API from [WeatherApi](https://www.weatherapi.com/)

**A screenshot from the morning hours**


https://github.com/mesut-demr/weather_app_with_cubit/assets/81968170/8e054260-6c1c-419b-a6e2-9d74809481b6


**A screenshot from the evening hours**


https://github.com/mesut-demr/weather_app_with_cubit/assets/81968170/3a5df7d8-df20-4d00-99c9-0f4787445609


# App Architecture

- &#9745; The **BloC (cubit)** structure was used to manage the state.
- &#9745; The **dio** package was used to pull the api.
- &#9745; The user's position is stored with **shared_preferences**.
- &#9745; The **geolocator** package was used to track the user's location.
- &#9745; The **equatable** package was used to compare the objects.


# Supported Features

- Current temperature, condition, feels like temperature, wind, humidity, uv, vision, cloud and last updated.
- It retrieves the weather forecast based on the user's location.
- After receiving the user's location at the first login to the application, the location is held in memory with **shared_preferences** and the location is prevented from opening at each login.   
- The user can view the weather conditions of the desired city by selecting it from the list of cities.
- Change the background colour and message content according to the time change.
