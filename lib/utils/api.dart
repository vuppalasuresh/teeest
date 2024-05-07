import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyWeatherData {
  final String name; // Day name
  final int temperature; // Temperature in Fahrenheit
  final String shortForecast;
  final String cityName;
  final String stateName;

  MyWeatherData({
    required this.name,
    required this.temperature,
    required this.shortForecast,
    required this.cityName,
    required this.stateName,
  });
}

class WeatherApi {
  static final String apiKey = 'AIzaSyDALA35h_xl1wd4dQ4JWZAzn2AKMouR0IA'; // Add your API key here

  static Future<List<MyWeatherData>> getWeatherData(String zipCode) async {
    final geocodingUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$zipCode&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(geocodingUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'];

        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          final latitude = location['lat'];
          final longitude = location['lng'];
          final city = results[0]['address_components'][1]['long_name']; // Extract city name
          final state = results[0]['address_components'][2]['short_name']; // Extract state name

          // Print the extracted data
          print('Latitude: $latitude');
          print('Longitude: $longitude');
          print('City: $city');
          print('State: $state');

          final weatherUrl = 'https://api.weather.gov/points/$latitude,$longitude/';

          final weatherResponse = await http.get(Uri.parse(weatherUrl));

          if (weatherResponse.statusCode == 200) {
            final weatherData = json.decode(weatherResponse.body);
            final forecastUrl = weatherData['properties']['forecast'];

            final forecastResponse = await http.get(Uri.parse(forecastUrl));

            if (forecastResponse.statusCode == 200) {
              final forecastData = json.decode(forecastResponse.body);

              return parseWeatherData(forecastData, city, state);
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
    return [];
  }

  static List<MyWeatherData> parseWeatherData(dynamic forecastData, String city, String state) {
    final List<MyWeatherData> weatherDataList = [];

    for (var period in forecastData['properties']['periods']) {
      final String name = period['name'];
      final int temperature = period['temperature'];

      final shortForecast = period['shortForecast'];

      MyWeatherData weatherData = MyWeatherData(
        name: name,
        temperature: temperature,
        shortForecast: shortForecast,
        cityName: city,
        stateName: state,
      );
      weatherDataList.add(weatherData);
    }
    return weatherDataList;
  }
}
