import 'api.dart'; // Assuming weather_api.dart contains the WeatherApi class

class HandleUserInput {
  static String? storedZipCode;

  static void handleQuery(String query) {
    // Assuming the query is a ZIP code, you can store it in the storedZipCode variable
    storedZipCode = query;
    print('Stored ZIP Code: $storedZipCode');

    // You can perform further actions with the stored ZIP code here, such as fetching weather data
    if (storedZipCode != null) {
      WeatherApi weatherApi = WeatherApi();
      WeatherApi.getWeatherData(storedZipCode!);

    }
  }
}