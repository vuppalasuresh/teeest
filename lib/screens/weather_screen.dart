import 'package:flutter/material.dart';
import 'package:weatherplan2/utils/location_search.dart';
import 'package:weatherplan2/screens/saved_locations.dart';



class WeatherScreen extends StatelessWidget {
  final String currentLocation = "New York, NY";  // Assume this is your current location

  void saveCurrentLocation() {
    // Logic to save the location
    print("Saved location: $currentLocation");
    // Here, implement the actual saving logic, possibly involving state management or database storage
    // Don't forget to check if location already exists in saved locations
  }

  // define BG colors for conditions
  final Map<String, Color> weatherColors = {
    "Sunny": Colors.yellowAccent,
    "Cloudy": Colors.grey.shade300,
    "Rainy": Colors.blueGrey,
    "Snowy": Colors.grey,
  };

  // BG color function
  Color getBackgroundColorForCondition(String condition) {
    return weatherColors[condition] ?? Colors.grey;
  }

  // define icons for conditions
  final Map<String, IconData> weatherIcons = {
    "Sunny": Icons.wb_sunny_outlined,
    "Cloudy": Icons.wb_cloudy_outlined,
    "Rainy": Icons.water_drop_outlined,
    "Snowy": Icons.snowing,
  };

  // conditions icon function
  IconData getIconForCondition(String condition) {
    return weatherIcons[condition] ?? Icons.question_mark;
  }

  // define clothing icons for conditions
  final Map<int, IconData> clothingIcons = {
    70: Icons.woman, //replace with light clothing
    60: Icons.woman, //replace with mid clothing
    50: Icons.woman, //replace with jacket
    40: Icons.woman, //replace with coatnew
  };

  IconData getClothingIcon(int temperature) {
  // Sort keys in descending order to start comparison from the warmest range
  var sortedKeys = clothingIcons.keys.toList()..sort((a, b) => b.compareTo(a));
  for (var temp in sortedKeys) {
    if (temperature >= temp) {
      return clothingIcons[temp]!;
    }
  }
  // Return a default icon if no conditions are met
  return Icons.error; // Default icon if very cold or no matching range
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/WeatherPlanLogo.png', width: 200),
      ),
      body: Column(
        children: [
          LocationSearch(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  WeatherInfoItem(
                    location: 'Test', 
                    icon: getIconForCondition('Cloudy'),
                    conditions: 'Cloudy',
                    temp: '99',
                    backgroundColor: getBackgroundColorForCondition('Cloudy'),
                  ),

                  ClothingInfoItem(
                    icon: getClothingIcon(63), // Replace with actual icon
                  ),
                  
                  ForecastInfoItem(
                    day: 'Monday',
                    icon: getIconForCondition('Sunny'), // Replace with actual weekday icon
                    hiTemp: '67',
                    loTemp: '50',
                    conditions: 'Sunny',
                    backgroundColor: getBackgroundColorForCondition('Sunny'),
                  ),
                  ForecastInfoItem(
                    day: 'Tuesday',
                    icon: getIconForCondition('Cloudy'), // Replace with actual weekday icon
                    hiTemp: '67',
                    loTemp: '50',
                    conditions: 'Cloudy',
                    backgroundColor: getBackgroundColorForCondition('Cloudy'),
                  ),
                  ForecastInfoItem(
                    day: 'Wednesday',
                    icon: getIconForCondition('Rainy'), // Replace with actual weekday icon
                    hiTemp: '67',
                    loTemp: '50',
                    conditions: 'Rainy',
                    backgroundColor: getBackgroundColorForCondition('Rainy'),
                  ),
                  ForecastInfoItem(
                    day: 'Thursday',
                    icon: getIconForCondition('Snowy'), // Replace with actual weekday icon
                    hiTemp: '67',
                    loTemp: '50',
                    conditions: 'Snowy',
                    backgroundColor: getBackgroundColorForCondition('Snowy'),
                  ),
                  
                ],
              ),
            ),
          ),
          Container(
            height: 150.0,
            child: SavedLocations(
              onSaveCurrentLocation: saveCurrentLocation, // Pass the save action
            ),
          ),
        ],
      ),
    );
  }
}


class WeatherInfoItem extends StatelessWidget {
  final String location;
  final IconData icon;
  final String conditions;
  final String temp;
  final Color backgroundColor;

  const WeatherInfoItem({
    required this.location,
    required this.icon,
    required this.conditions,
    required this.temp,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      color: backgroundColor,  // Use the background color
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use the minimal space needed by the child
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Text(
              location,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              icon,
              size: 30,
            ),
            Text(
              "$conditions, $temp",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ClothingInfoItem extends StatelessWidget {
  final IconData icon;

  const ClothingInfoItem({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Icon(icon),
      ),
    );
  }
}

class ForecastInfoItem extends StatelessWidget {
  final String day;
  final String hiTemp;
  final String loTemp;
  final String conditions;
  final IconData icon;
  final Color backgroundColor;

  const ForecastInfoItem({
    required this.day,
    required this.hiTemp,
    required this.loTemp,
    required this.conditions,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: ListTile(
        leading: Icon(icon),
        title: Text(day),
        subtitle: Text(conditions + ". High of " + hiTemp + ", low of " + loTemp),
      ),
    );
  }
}