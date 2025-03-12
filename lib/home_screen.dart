import 'dart:async'; // For the Timer
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

  // Last known position of the marker to draw polyline
  LatLng? _lastMarkerPosition;

  // Timer for location updates
  Timer? _locationUpdateTimer;

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

  // Method to get current location
  Future<void> _getCurrentLocation() async {
    if (await _checkPermissionStatus()) {
      if (await _isGpsServiceEnabled()) {
        _currentPosition = await Geolocator.getCurrentPosition();
        _currentLocationText =
        'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}';

        // Move camera to new position (Automatic Map Animation)
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              zoom: 16,
              bearing: _bearing,
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

  // Method to start real-time location updates
  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _getCurrentLocation(); // Get and update location every 10 seconds
    });
  }

  // Method to stop real-time location updates
  void _stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
  }

  // Method to add a marker to the map
  void _addMarker(LatLng position) {
    final Marker marker = Marker(
      markerId: MarkerId(DateTime.now().millisecondsSinceEpoch.toString()), // Unique ID
      position: position,
      infoWindow: InfoWindow(
        title: "My current location", // Title of the info window
        snippet: "Latitude: ${position.latitude}, Longitude: ${position
            .longitude}", // Snippet
      ),
      onTap: () {
        print('Marker tapped!');
      },
    );

    setState(() {
      _markers.add(marker); // Add marker

      // Only add polyline if current position is available
      if (_currentPosition != null) {
        _addPolyline(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            position);
      }

      // Update last marker position
      _lastMarkerPosition = position;
    });
  }

  // Method to add polyline between two points
  void _addPolyline(LatLng start, LatLng end) {
    final Polyline polyline = Polyline(
      polylineId: PolylineId('user_tracking'), // Single polyline ID
      points: [start, end], // Points for the polyline
      color: Colors.blue,
      width: 4,
    );

    setState(() {
      _polylines.clear(); // Clear previous polyline
      _polylines.add(polyline); // Add updated polyline
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Initial location fetch
    _startLocationUpdates(); // Start real-time location updates
    _initializeNotifications();
  }

  @override
  void dispose() {
    _stopLocationUpdates(); // Stop location updates when the widget is disposed
    super.dispose();
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
          ],
        ),
      ),
    );
  }
}
