import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineManager {
  static Set<Polyline> _polylines = {};

  // Add a polyline between two points
  static void addPolyline(LatLng start, LatLng end) {
    String polylineId = 'polyline_${DateTime.now().millisecondsSinceEpoch}';
    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineId),
        points: [start, end],
        color: Colors.blue,
        width: 5,
      ),
    );
  }

  // Get all polylines
  static Set<Polyline> getPolylines() {
    return _polylines;
  }

  // Clear all polylines
  static void clearPolylines() {
    _polylines.clear();
  }
}
