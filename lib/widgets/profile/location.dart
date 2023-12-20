import 'dart:async';

import 'package:ecommerce/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProfileWidget extends StatefulWidget {
  const LocationProfileWidget({Key? key}) : super(key: key);

  @override
  State<LocationProfileWidget> createState() => _LocationProfileWidgetState();
}

class _LocationProfileWidgetState extends State<LocationProfileWidget> {
  String location = 'Null, Press Button';
  double Lat = 20.00000000;
  double Long = 77.00000000;
  String address = 'search';
  TextEditingController locationController = TextEditingController();
  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    locationController.text =
        context.read<ProfileProvider>().userProfile!.location!;

    _getGeoLocationPosition().then((position) {
      _updateCameraPosition(position);
    });
  }

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  void updateGeoLocation() async {
    // Close keyboard
    FocusScope.of(context).unfocus();

    if (locationController.text.isNotEmpty) {
      await context
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
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLatLong(Position position) async {
    setState(() {
      Lat = position.latitude;
      Long = position.longitude;
    });
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
      await context.read<ProfileProvider>().updateGeoLocation(locationController.text);

      // Update the camera position on the map
      _updateCameraPosition(position);

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

  void _updateCameraPosition(Position position) {
  _mapController.future.then((controller) {
    controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: Theme.of(context).colorScheme.secondary,
      hintText: 'Location',
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.background),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
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
                        onPressed: () async {
                          updateGeoLocation();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<Position>(
                        future: _getGeoLocationPosition(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Error getting location'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.my_location),
                              );
                            } else {
                              return IconButton(
                                onPressed: () async {
                                  await getCurrentLocation(snapshot.data!);
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
          SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(Lat, Long),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}
