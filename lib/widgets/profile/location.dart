import 'package:ecommerce/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                target: LatLng(37.7749, -122.4194), 
                zoom: 12,
              ),
              // onMapCreated: (GoogleMapController controller) {

              // },
            ),
          ),
        ],
      ),
    );
  }
}