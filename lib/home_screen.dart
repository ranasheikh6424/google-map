import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'component/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleMapController _mapController;
  double _bearing = 0.0;
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};

  Position? _currentPosition;
  String? _currentLocationText;
  CameraPosition? _currentCameraPosition;



  // Firebase Notification
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  User? user = FirebaseAuth.instance.currentUser;

  // Method for showing notifications
  Future<void> _initializeNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Show notifications here
        print('Notification received: ${message.notification!.title}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened: ${message.notification!.title}');
    });

    // Get the token for the device
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  void logout() async {
    try {
      await _auth.signOut(); // Firebase sign out
      Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error logging out')));
    }
  }

  // Methods for Geo-locator permission and service checks
  Future<bool> _checkPermissionStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<void> _requestPermission() async {
    await Geolocator.requestPermission();
  }

  Future<bool> _isGpsServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> _requestGpsServices() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> _getCurrentLocation() async {
    if (await _checkPermissionStatus()) {
      if (await _isGpsServiceEnabled()) {
        _currentPosition = await Geolocator.getCurrentPosition();
        _currentLocationText =
        'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}';
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 16,
            ),
          ),
        );
        setState(() {});
      } else {
        _requestGpsServices();
      }
    } else {
      _requestPermission();
    }
  }

  // Add marker to map
  void _addMarker(LatLng position) {
    final Marker marker = Marker(
      markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()), // Unique ID
      position: position,
      infoWindow: InfoWindow(title: "Marker", snippet: "Added marker here"),
    );
    setState(() {
      _markers.add(marker);
    });
  }

  // Add polyline to map
  void _addPolyline(LatLng start, LatLng end) {
    final Polyline polyline = Polyline(
      polylineId: PolylineId(DateTime.now().millisecondsSinceEpoch.toString()), // Unique ID
      points: [start, end],
      color: Colors.blue,
      width: 4,
    );
    setState(() {
      _polylines.add(polyline);
    });
  }



  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: customDrawer(context, logout, user),
      appBar: AppBar(
        title: const Text('Google Maps'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: const CameraPosition(
              zoom: 16,
              target: LatLng(24.73694601041382, 90.40380259999998),
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            trafficEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (LatLng position) {
              _addMarker(position); // Add marker on map tap
            },
          ),
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Card(
              elevation: 5,
              color: Colors.white.withOpacity(0.7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Updated current location: ${_currentLocationText}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Permission Status: ${_currentPosition == null ? "Not Yet Granted" : "Granted"}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'GPS Status: ${_currentPosition == null ? "Fetching..." : "Active"}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentPosition != null
                          ? 'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'
                          : 'Fetching location...',
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20),
          Positioned(
            bottom: 90,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: _getCurrentLocation,
                backgroundColor: Colors.white,
                tooltip: 'Get Current Location',
                child: const Icon(Icons.gps_fixed),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                // You can hardcode the position for adding a marker
                _addMarker(LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
              },
              backgroundColor: Colors.green,
              tooltip: 'Add Marker',
              child: const Icon(Icons.add_location_alt),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                if (_currentPosition != null) {
                  // Add polyline between two points
                  _addPolyline(
                    LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    LatLng(_currentPosition!.latitude + 0.01, _currentPosition!.longitude + 0.01),
                  );
                }
              },
              backgroundColor: Colors.blue,
              tooltip: 'Add Polyline',
              child: const Icon(Icons.polymer),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
