import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:taqreeb/Components/text_box.dart';

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
  String _currentLocation = "Unknown Location";

  Future<List<String>> _fetchSuggestions(String query) async {
    print('Running');
    if (query.isEmpty) return [];

    try {
      // Replace `YOUR_API_KEY` with your GoMaps Pro API key
      final response = await http.get(
        Uri.parse(
            'https://maps.gomaps.pro/maps/api/place/autocomplete/json?input=$query&key=AlzaSy3NTbKIdIUJGedW-k7yw_9oeQcVTeQgO-T&components=country:pk'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse suggestions from the API response
        List<String> suggestions = (data['predictions'] as List)
            .map((prediction) => prediction['description'] as String)
            .toList();

        return suggestions;
      } else {
        throw Exception('Failed to fetch suggestions');
      }
    } catch (error) {
      print("Error fetching suggestions: $error");
      return [];
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentLocation = "${position.latitude}, ${position.longitude}";
        widget.locationController.text = _currentLocation;
        widget.onLocationChanged(_currentLocation);
      });
    } catch (e) {
      print("Error fetching current location: $e");
    }
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
                  builder: (context, controller, focusNode) {
                    if (widget.locationController.text.isNotEmpty) {
                      controller.text = widget.locationController.text;
                    }
                    return MyTextBox(
                        hint: 'Location',
                        valueController: controller,
                        focusNode: focusNode);
                  },
                  suggestionsCallback: (value) async {
                    return await _fetchSuggestions(value);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(suggestion),
                    );
                  },
                  onSelected: (suggestion) {
                    setState(() {
                      // Update the controller's text
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
        ],
      ),
    );
  }
}
