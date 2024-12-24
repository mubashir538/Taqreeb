import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/theme/color.dart'; // Replace with your color theme

class LocationInputWidget extends StatefulWidget {
  final TextEditingController locationController;
  final ValueChanged<String> onLocationChanged;

  const LocationInputWidget({
    super.key,
    required this.locationController,
    required this.onLocationChanged,
  });

  @override
  _LocationInputWidgetState createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  List<String> _suggestedLocations = [];
  String _currentLocation = "Unknown Location";

  // Mock data for location suggestions (In a real app, use Google Places API)
  final List<String> _allLocations = [
    "New York, USA",
    "Los Angeles, USA",
    "London, UK",
    "Paris, France",
    "Dubai, UAE",
    "Tokyo, Japan",
    "Sydney, Australia"
  ];

  // Method to fetch current location using Geolocator
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = "${position.latitude}, ${position.longitude}";
      widget.locationController.text = _currentLocation;
      widget.onLocationChanged(
          _currentLocation); // Notify parent with current location
    });
  }

  // Method to handle location suggestions based on text entered
  void _onSearchChanged(String query) {
    setState(() {
      _suggestedLocations = _allLocations
          .where((location) =>
              location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              // Location TextField
              Expanded(
                child: TypeAheadField<String>(
                  // textFieldConfiguration: TextFieldConfiguration(
                  //   controller: widget.locationController,
                  //   decoration: InputDecoration(
                  //     labelText: 'Enter Location',
                  //     hintText: 'Search for a location',
                  //     border: OutlineInputBorder(),
                  //     filled: true,
                  //   ),
                  // ),
                  suggestionsCallback: (pattern) {
                    return _suggestedLocations;
                  },
                  itemBuilder: (context, String suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSelected: (String suggestion) {
                    setState(() {
                      widget.locationController.text = suggestion;
                      widget.onLocationChanged(
                          suggestion); // Notify parent when suggestion is selected
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.location_on),
                onPressed: _getCurrentLocation, // Get current location on click
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Current Location: $_currentLocation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
