import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _defaultCenter = LatLng(10.7769, 106.7009);

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('hcmc'),
      position: _defaultCenter,
      infoWindow: InfoWindow(
        title: 'TP.HCM',
        snippet: 'Demo marker cho Google Maps Flutter',
      ),
    ),
  };

  GoogleMapController? _mapController;
  MapType _mapType = MapType.normal;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _toggleMapType() {
    setState(() {
      _mapType = _mapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<void> _goToMarker() async {
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_defaultCenter, 15),
    );
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
              initialCameraPosition: const CameraPosition(
                target: _defaultCenter,
                zoom: 14,
              ),
              markers: _markers,
              mapType: _mapType,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMarker,
        icon: const Icon(Icons.place),
        label: const Text('Đi tới marker'),
      ),
    );
  }
}
