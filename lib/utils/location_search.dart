import 'package:flutter/material.dart';
import 'api.dart'; // Import the WeatherApi class
import 'handleuserinput.dart'; // Import relevant code from handleuserinput.dart

class LocationSearch extends StatefulWidget {
  @override
  _LocationSearchState createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  TextEditingController _controller = TextEditingController(); // Declare TextEditingController
  String _searchedLocation = ''; // Declare searchedLocation variable
  double _latitude = 0.0; // Declare latitude variable
  double _longitude = 0.0; // Declare longitude variable

  void _searchLocation(String zipCode) async {
    List<MyWeatherData> weatherDataList = await WeatherApi.getWeatherData(zipCode);

    if (weatherDataList.isNotEmpty) {
      // Print city only once
      print('City: ${weatherDataList[0].cityName}');
      print('State: ${weatherDataList[0].stateName}');
      print('Current Temp: ${weatherDataList[0].temperature}');
      print('----------------------------------------------');

      // Initialize variables for Today and Tonight temperatures
      List<double> todayTonightTemps = [];
      Map<String, List<double>> otherDayTemps = {}; // Store other day temperatures

      for (MyWeatherData weatherData in weatherDataList) {
        // Splitting the name to get the day of the week
        List<String> nameParts = weatherData.name.split(' ');
        String dayOfWeek = nameParts[0];

        // Check if it is Today or Tonight and add temperature to combined list
        if (dayOfWeek == 'Today' || dayOfWeek == 'Tonight') {
          todayTonightTemps.add(weatherData.temperature as double);
        } else {
          // Store temperatures for other days
          otherDayTemps.putIfAbsent(dayOfWeek, () => []).add(weatherData.temperature as double);
        }

        // Print the parameters of each MyWeatherData object
        print('Day: $dayOfWeek'); // Print day of the week
        print('Temp: ${weatherData.temperature}');
        print('Description:  ${weatherData.shortForecast}');
        print('----------------------------------------------');
      }

      // Print high and low temperatures for each day except Today and Tonight
      otherDayTemps.forEach((day, temperatures) {
        double highTemp = temperatures.reduce((a, b) => a > b ? a : b);
        double lowTemp = temperatures.reduce((a, b) => a < b ? a : b);
        print('Day: $day');
        print('High Temp: $highTemp');
        print('Low Temp: $lowTemp');
        print('----------------------------------------------');
      });

      // Calculate high and low temperatures for Today/Tonight combined
      double todayTonightHighTemp = todayTonightTemps.reduce((a, b) => a > b ? a : b);
      double todayTonightLowTemp = todayTonightTemps.reduce((a, b) => a < b ? a : b);
      print('Today High Temp: $todayTonightHighTemp');
      print('Today Low Temp: $todayTonightLowTemp');
      print('----------------------------------------------');

    } else {
      print('No weather data found.');
    }
  }

  bool _checkLocationExists(String query) {
    // Implement logic to check if the searched location already exists in the saved locations
    // For simplicity, let's assume a list of saved locations called savedLocations
    // You can replace this with your actual implementation
    List<String> savedLocations = ['New York, NY', 'Los Angeles, CA', 'Chicago, IL']; // Example list of saved locations
    return savedLocations.contains(query);
  }

  void _showSaveLocationDialog(String query, double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Location'),
          content: Text('Do you want to save $query to your list of saved locations?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Save the location to the list of saved locations
                _saveLocation(query, latitude, longitude);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveLocation(String query, double latitude, double longitude) {
    // Implement saving the location to the list of saved locations
    // You can use a data structure like a list or a database to store the saved locations
    // For simplicity, let's print the location details
    print('Location saved: $query, Latitude: $latitude, Longitude: $longitude');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter location',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _searchLocation(_controller.text);
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          if (_searchedLocation.isNotEmpty)
            Text(
              'Searched Location: $_searchedLocation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          if (_latitude != 0.0 && _longitude != 0.0)
            Text(
              'Latitude: $_latitude, Longitude: $_longitude',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
