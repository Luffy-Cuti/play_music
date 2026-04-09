import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _defaultCenter = LatLng(10.7769, 106.7009);

  late LatLng _currentCenter;
  late Set<Marker> _markers;

  GoogleMapController? _mapController;
  MapType _mapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _currentCenter = _defaultCenter;
    _markers = _buildMarker(_currentCenter);
    _setCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarker(LatLng position) {
    return {
      Marker(
        markerId: const MarkerId('current_location'),
        position: position,
        infoWindow: const InfoWindow(
          title: 'Vị trí hiện tại',
          snippet: 'Lấy từ GPS của thiết bị',
        ),
      ),
    };
  }

  Future<void> _setCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final current = LatLng(position.latitude, position.longitude);
      if (!mounted) return;

      setState(() {
        _currentCenter = current;
        _markers = _buildMarker(current);
      });
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(current, 16),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không lấy được vị trí hiện tại, đang dùng vị trí mặc định.',
          ),
        ),
      );
    }
  }

  void _toggleMapType() {
    setState(() {
      _mapType = _mapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Test UI'),
        actions: [
          IconButton(
            onPressed: _toggleMapType,
            icon: const Icon(Icons.layers),
            tooltip: 'Đổi kiểu bản đồ',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.amber.shade100,
            child: const Text(
              'Trang này dùng để test thư viện google_maps_flutter.\nNếu bản đồ không hiện, hãy kiểm tra API key Android/iOS trong README.',
              style: TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentCenter,
                zoom: 14,
              ),
              markers: _markers,
              mapType: _mapType,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (controller) async {
                _mapController = controller;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _setCurrentLocation,
        icon: const Icon(Icons.my_location),
        label: const Text('Lấy vị trí máy'),
      ),
    );
  }
}
