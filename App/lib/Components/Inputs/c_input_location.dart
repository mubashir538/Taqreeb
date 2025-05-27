import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import '../../core/services/api_service.dart' show MyApi;

class LocationInputWidget extends StatefulWidget {
  final TextEditingController locationController;
  final ValueChanged<String> onLocationChanged;

  const LocationInputWidget({
    super.key,
    required this.locationController,
    required this.onLocationChanged,
  });

  @override
  LocationInputWidgetState createState() => LocationInputWidgetState();
}

class LocationInputWidgetState extends State<LocationInputWidget> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  String _currentLocation = "Unknown Location";

  @override
  void initState() {
    super.initState();
    _textController =
        TextEditingController(text: widget.locationController.text);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    // _focusNode.dispose();
    super.dispose();
  }

  Future<List<String>> _fetchSuggestions(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse(
            'https://maps.gomaps.pro/maps/api/place/autocomplete/json?input=$query&key=AlzaSyTupm6TUJxeoGqvqM-NcWyPRvSrN8NRL8D&components=country:pk'),
      );
 
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['predictions'] as List)
            .map((prediction) => prediction['description'] as String)
            .toList();
      } else {
        throw Exception('Failed to fetch suggestions');
      }
    } catch (error) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'Error fetching suggestions: $error'});
      return [];
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentLocation = "${position.latitude}, ${position.longitude}";
        _textController.text = _currentLocation;
        widget.onLocationChanged(_currentLocation);
      });
    } catch (e) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'Error fetching current location: $e'});
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
                    return MyTextBox(
                      prefixIcon: FontAwesomeIcons.locationPin,
                      hint: 'Location',
                      valueController: _textController,
                      focusNode: _focusNode,
                    );
                  },
                  suggestionsCallback: _fetchSuggestions,
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: Icon(FontAwesomeIcons.locationDot),
                      title: Text(suggestion),
                    );
                  },
                  onSelected: (suggestion) {
                    setState(() {
                      _textController.text = suggestion;
                      widget.onLocationChanged(suggestion);
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.locationDot),
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
