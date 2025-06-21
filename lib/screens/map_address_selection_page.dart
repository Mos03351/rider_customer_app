// lib/screens/map_address_selection_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart'; // ตรวจสอบว่า import นี้ถูกต้อง

class MapAddressSelectionPage extends StatefulWidget {
  final LatLng? initialLocation; // พิกัดเริ่มต้น (ถ้ามี)
  final String? initialAddress;  // ที่อยู่เริ่มต้น (ถ้ามี)

  const MapAddressSelectionPage({
    Key? key,
    this.initialLocation,
    this.initialAddress,
  }) : super(key: key);

  @override
  _MapAddressSelectionPageState createState() => _MapAddressSelectionPageState();
}

class _MapAddressSelectionPageState extends State<MapAddressSelectionPage> {
  LatLng? _selectedLocation;
  String _selectedAddress = 'กำลังรอการเลือกตำแหน่ง...';
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _selectedAddress = widget.initialAddress ?? 'กำลังรอการเลือกตำแหน่ง...';

    // หากมีพิกัดเริ่มต้น ให้ Center แผนที่ไปที่นั่น
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedLocation != null) {
        _mapController.move(_selectedLocation!, 15.0); // ซูม 15.0
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกที่อยู่หลักบนแผนที่'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                // 'center' ยังคงมีใน MapOptions ของ flutter_map v6.x.x
                center: _selectedLocation ?? LatLng(13.7563, 100.5018), // Default: Bangkok
                zoom: 13.0,
                onTap: (TapPosition tapPosition, LatLng latLng) async {
                  setState(() {
                    _selectedLocation = latLng;
                    _selectedAddress = 'กำลังค้นหาที่อยู่...';
                  });
                  await _getAddressFromLatLng(latLng);
                },
              ),
              // 'layers' ยังคงมีใน FlutterMap ของ flutter_map v6.x.x
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                if (_selectedLocation != null) // แสดง Marker ถ้ามีการเลือกตำแหน่งแล้ว
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 50.0,
                        height: 50.0,
                        point: _selectedLocation!,
                        // 'builder' ยังคงมีใน Marker ของ flutter_map v6.x.x
                        child: const Icon(Icons.location_on),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'ตำแหน่งที่เลือก:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedAddress,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _selectedLocation == null || _selectedAddress == 'กำลังค้นหาที่อยู่...'
                      ? null
                      : () {
                          // ส่งข้อมูลพิกัดและที่อยู่กลับไปยังหน้า EditProfilePage
                          Navigator.pop(context, {
                            'address_text': _selectedAddress,
                            'latitude': _selectedLocation!.latitude,
                            'longitude': _selectedLocation!.longitude,
                          });
                        },
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text('ยืนยันที่อยู่นี้', style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชัน Reverse Geocoding
  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      // placemarkFromCoordinates เป็น method ของ package geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
        localeIdentifier: "th_TH", // ระบุภาษาไทย
      );

      if (mounted) { // ตรวจสอบว่า Widget ยังอยู่ใน Widget Tree
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            // สร้างที่อยู่ให้ครบถ้วนที่สุดเท่าที่จะทำได้
            _selectedAddress = [
              place.street,
              place.subLocality, // แขวง/ตำบล
              place.locality,    // เขต/อำเภอ
              place.administrativeArea, // จังหวัด
              place.postalCode,  // รหัสไปรษณีย์
              place.country,     // ประเทศ
            ].where((s) => s != null && s.isNotEmpty).join(', ');
          });
        } else {
          setState(() {
            _selectedAddress = 'ไม่พบที่อยู่สำหรับพิกัดนี้';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _selectedAddress = 'เกิดข้อผิดพลาดในการดึงข้อมูลที่อยู่: $e';
        });
      }
      print('Error geocoding: $e');
    }
  }
}