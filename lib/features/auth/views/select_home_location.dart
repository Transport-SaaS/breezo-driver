import 'dart:convert';
import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/viewmodels/location_viewmodel.dart';
import 'package:breezodriver/features/auth/views/confirm_location_screen.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

/// Replace with your actual Google Places API key.
/// Make sure the Places API is enabled in your Google Cloud Console.
const String _googleApiKey = 'AIzaSyALBJu7cdnA9HCglhQLNlbxVwSEwvaZRgA';

class SelectLocationScreen extends StatefulWidget {
  final bool isFromAllAddress;
  const SelectLocationScreen({Key? key, required this.isFromAllAddress}) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  /// List of place predictions from Google Places Autocomplete
  List<Map<String, dynamic>> _placePredictions = [];

  /// The place user selected from the dropdown
  Map<String, dynamic>? _selectedPlace;

  @override
  void initState() {
    super.initState();
    // Listen for text changes and trigger search
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  /// Called whenever the user types in the text field
  void _onSearchChanged() {
    final query = _searchController.text.trim();
    debugPrint('Search changed: $query');

    // If user typed fewer than 3 characters, clear suggestions
    if (query.length < 3) {
      setState(() => _placePredictions.clear());
      return;
    }

    _getPlacePredictions(query);
  }

  /// Fetches autocomplete predictions from Google Places API
  Future<void> _getPlacePredictions(String input) async {
    try {
      // You can restrict results to a specific country with `components=country:in`
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$input'
          '&key=$_googleApiKey'
          '&components=country:in';

      debugPrint('Requesting predictions for: $input');
      final response = await http.get(Uri.parse(url));

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          debugPrint('Predictions count: ${predictions.length}');
          setState(() {
            _placePredictions =
                predictions.map((p) {
                  return {
                    'description': p['description'],
                    'place_id': p['place_id'],
                    'structured_formatting': p['structured_formatting'],
                  };
                }).toList();
          });
        } else {
          // For example, ZERO_RESULTS or REQUEST_DENIED
          debugPrint('Google API error status: ${data['status']}');
          setState(() => _placePredictions.clear());
        }
      } else {
        debugPrint('HTTP error. Code: ${response.statusCode}');
        setState(() => _placePredictions.clear());
      }
    } catch (e) {
      debugPrint('Error fetching place predictions: $e');
      setState(() => _placePredictions.clear());
    }
  }

  /// Called when the user taps on a prediction from the dropdown
  void _onPredictionTap(Map<String, dynamic> prediction) async {
    final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);
    
    // Get place details (coordinates) first
    await locationViewModel.getPlaceDetails(prediction['place_id']);
    
    if (locationViewModel.errorMessage.isEmpty) {
      final structuredFormatting = prediction['structured_formatting'] as Map<String, dynamic>;
      final mainText = structuredFormatting['main_text'] ?? '';
      final secondaryText = structuredFormatting['secondary_text'] ?? '';

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmLocationScreen(
            placeName: mainText,
            address: secondaryText,
          ),
        ),
      );

      if (result != null) {
        setState(() {
          _selectedPlace = prediction;
          _searchController.text = prediction['description'] ?? '';
          _placePredictions.clear();
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locationViewModel.errorMessage)),
      );
    }
  }

  /// Called when "Next" is pressed
  void _onNextPressed() {
    if (_selectedPlace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first.')),
      );
      return;
    }
    // TODO: Navigate to the next screen or handle the selected location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: ${_selectedPlace!['description']}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarycolor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Top: progress bar (step 4)
            !widget.isFromAllAddress?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: const ProgressBar(currentStep: 4),
            ):
            SizedBox(height: SizeConfig.getProportionateScreenHeight(30),),

            // White container that fills remaining space
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row with back arrow + title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(17, 32, 17, 0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Enter your home location',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Search field with a search icon to the left
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 4.0),
                              child: Icon(Icons.search, color: Colors.black),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,

                                  hintText: 'Enter your area or apartment name',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: GestureDetector(
                        onTap: () async {
                          final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);
                          await locationViewModel.getCurrentLocation();
                          
                          if (locationViewModel.errorMessage.isEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConfirmLocationScreen(
                                  placeName: locationViewModel.placeName,
                                  address: locationViewModel.fullAddress,
                                  isFromAllAddress: widget.isFromAllAddress,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(locationViewModel.errorMessage)),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/location.svg',
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Use my current location',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.activeButton,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // List of predictions below the text field
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 14,
                      ),
                      child: Divider(height: 1, color: Colors.grey.shade300),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Text(
                        '${_placePredictions.length} SEARCH RESULTS',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: ListView.builder(
                          itemCount: _placePredictions.length,
                          itemBuilder: (context, index) {
                            final prediction = _placePredictions[index];
                            final structuredFormatting =
                                prediction['structured_formatting']
                                    as Map<String, dynamic>;
                            final title =
                                structuredFormatting['main_text'] ?? '';
                            final secondaryText =
                                structuredFormatting['secondary_text'] ?? '';

                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/location.svg',
                                        color: Colors.grey.shade400,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        title.length > 34
                                            ? title.substring(0, 34) + '...'
                                            : title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(secondaryText),
                                  onTap: () => _onPredictionTap(prediction),
                                ),
                                // const Divider(height: 1),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

        
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
