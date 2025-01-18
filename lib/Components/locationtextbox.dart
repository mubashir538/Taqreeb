import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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

  final List<String> _allLocations = [
    "New York, USA",
    "Los Angeles, USA",
    "London, UK",
    "Paris, France",
    "Dubai, UAE",
    "Tokyo, Japan",
    "Sydney, Australia"
  ];

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = "${position.latitude}, ${position.longitude}";
      widget.locationController.text = _currentLocation;
      widget.onLocationChanged(_currentLocation);
    });
  }

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
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
                      widget.onLocationChanged(suggestion);
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.location_on),
                onPressed: _getCurrentLocation,
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
