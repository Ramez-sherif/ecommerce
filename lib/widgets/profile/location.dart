import 'package:ecommerce/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProfileWidget extends StatefulWidget {
  const LocationProfileWidget({Key? key}) : super(key: key);

  @override
  _LocationProfileWidgetState createState() => _LocationProfileWidgetState();
}

class _LocationProfileWidgetState extends State<LocationProfileWidget> {
  String location = 'Null, Press Button';
  String address = 'search';
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    locationController.text =
        context.read<ProfileProvider>().userProfile!.location!;
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  void updateGeoLocation() {
    // Close keyboard
    FocusScope.of(context).unfocus();

    if (locationController.text.isNotEmpty) {
      context
          .read<ProfileProvider>()
          .updateGeoLocation(locationController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location updated'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid location'),
        ),
      );
    }
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  Future<void> getCurrentLocation(Position position) async {
    try {
      await getAddressFromLatLong(position);

      // Update locationController.text with the obtained location
      locationController.text = address;

      // Update the user's location in the provider
      context.read<ProfileProvider>().updateGeoLocation(locationController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location updated'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get current location'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: 'Location',
      hintStyle: TextStyle(color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: inputDecoration,
              controller: locationController,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: updateGeoLocation,
                    icon: const Icon(Icons.edit),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<Position>(
                    future: _getGeoLocationPosition(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          // Handle error
                          return IconButton(
                            onPressed: () {
                              // Show a message that there was an error getting the location
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error getting location: ${snapshot.error}'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.my_location),
                          );
                        } else {
                          // Location permission accepted
                          return IconButton(
                            onPressed: () {
                              // Call getCurrentLocation with the obtained position
                              getCurrentLocation(snapshot.data!);
                            },
                            icon: const Icon(Icons.my_location),
                          );
                        }
                      } else {
                        // Loading state
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
