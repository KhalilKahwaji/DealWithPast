// Simple map picker - tap anywhere to select location
// No extra APIs needed - just basic Google Maps SDK

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleMapPicker extends StatefulWidget {
  final LatLng? initialLocation;

  const SimpleMapPicker({Key? key, this.initialLocation}) : super(key: key);

  @override
  State<SimpleMapPicker> createState() => _SimpleMapPickerState();
}

class _SimpleMapPickerState extends State<SimpleMapPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};

  // Custom map style matching app colors (green/brown theme with high contrast)
  static const String _customMapStyle = '''[
    {
      "elementType": "geometry",
      "stylers": [{"color": "#f5f0e8"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#3a3534"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#ffffff"}]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#8b5a5a"}]
    },
    {
      "featureType": "landscape.natural",
      "elementType": "geometry",
      "stylers": [{"color": "#e8dcc8"}]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [{"color": "#d4c4a8"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [{"color": "#a8c9a3"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [{"color": "#ffffff"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#d4c4a8"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#8b5a5a"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [{"color": "#6b4545"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#7ca3b8"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#3a3534"}]
    }
  ]''';

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _addMarker(widget.initialLocation!);
    }
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selected-location'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _addMarker(position);
    });
  }

  void _confirm() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى اختيار موقع على الخريطة'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: Color(0xFF5A7C59),
        foregroundColor: Colors.white,
        title: Text(
          'اختر الموقع',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation ?? LatLng(33.8547, 35.8623), // Lebanon center
              zoom: 8,
            ),
            markers: _markers,
            onTap: _onMapTap,
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController?.setMapStyle(_customMapStyle);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Instructions
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.touch_app, color: Color(0xFF5A7C59), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'اضغط على الخريطة لاختيار الموقع',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Tajawal',
                        color: Color(0xFF3A3534),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Confirm button
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: MaterialButton(
              onPressed: _confirm,
              color: Color(0xFF5A7C59),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(vertical: 16),
              elevation: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    _selectedLocation != null
                        ? 'تأكيد الموقع'
                        : 'اختر موقعاً أولاً',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Coordinates display (if location selected)
          if (_selectedLocation != null)
            Positioned(
              bottom: 90,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'الإحداثيات: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Tajawal',
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
