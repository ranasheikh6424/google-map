import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerManager {
  static Set<Marker> _markers = {};

  // Add a marker to the map
  static void addMarker(LatLng position, String id, String title) {
    _markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(title: title),
      ),
    );
  }

  // Remove a marker by its ID
  static void removeMarker(String markerId) {
    _markers.removeWhere((marker) => marker.markerId.value == markerId);
  }

  // Get all markers
  static Set<Marker> getMarkers() {
    return _markers;
  }

  // Clear all markers
  static void clearMarkers() {
    _markers.clear();
  }
}
