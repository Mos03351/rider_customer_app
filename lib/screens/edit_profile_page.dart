// lib/screens/edit_profile_page.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/services/auth_service.dart';
import 'package:rider_customer_app/screens/login_page.dart';
import 'package:rider_customer_app/screens/map_address_selection_page.dart'; // <<< เพิ่ม import นี้
import 'package:latlong2/latlong.dart'; // <<< เพิ่ม import นี้

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String? currentPhone;
  final String? currentAddressText; // <<< เปลี่ยนชื่อเป็น currentAddressText
  final double? currentLatitude;    // <<< เพิ่ม
  final double? currentLongitude;   // <<< เพิ่ม

  const EditProfilePage({
    Key? key,
    required this.currentName,
    required this.currentEmail,
    this.currentPhone,
    this.currentAddressText,    // <<< เปลี่ยนชื่อ
    this.currentLatitude,       // <<< เพิ่ม
    this.currentLongitude,      // <<< เพิ่ม
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressTextController = TextEditingController(); // <<< เปลี่ยนชื่อ
  
  double? _selectedLatitude;   // <<< เก็บค่า Latitude ที่ผู้ใช้เลือก
  double? _selectedLongitude;  // <<< เก็บค่า Longitude ที่ผู้ใช้เลือก

  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _emailController.text = widget.currentEmail;
    _phoneController.text = widget.currentPhone ?? '';
    _addressTextController.text = widget.currentAddressText ?? ''; // <<< กำหนดค่าเริ่มต้น
    _selectedLatitude = widget.currentLatitude;   // <<< กำหนดค่าเริ่มต้น
    _selectedLongitude = widget.currentLongitude; // <<< กำหนดค่าเริ่มต้น
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressTextController.dispose(); // <<< Dispose
    super.dispose();
  }

  // ฟังก์ชันสำหรับบันทึกข้อมูลโปรไฟล์ที่แก้ไข
  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('โปรดกรอกข้อมูล ชื่อ และ อีเมล ให้ครบถ้วน')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.updateUserProfile(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _addressTextController.text, // <<< ส่ง address_text
      _selectedLatitude,         // <<< ส่ง latitude
      _selectedLongitude,        // <<< ส่ง longitude
    );

    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
        if (result['logout'] == true) {
           Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(builder: (context) => const LoginPage()),
             (Route<dynamic> route) => false,
           );
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ฟังก์ชันสำหรับเปิดหน้าเลือกที่อยู่บนแผนที่
  Future<void> _pickAddressFromMap() async {
    final Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapAddressSelectionPage(
          initialLocation: (_selectedLatitude != null && _selectedLongitude != null)
              ? LatLng(_selectedLatitude!, _selectedLongitude!)
              : null,
          initialAddress: _addressTextController.text.isNotEmpty
              ? _addressTextController.text
              : null,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _addressTextController.text = result['address_text'];
        _selectedLatitude = result['latitude'];
        _selectedLongitude = result['longitude'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขโปรไฟล์'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'ชื่อ-นามสกุล',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'อีเมล',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรศัพท์',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            // TextField สำหรับที่อยู่ พร้อมปุ่มเลือกจากแผนที่
            TextField(
              controller: _addressTextController,
              keyboardType: TextInputType.streetAddress,
              maxLines: 3,
              readOnly: true, // ทำให้ไม่สามารถพิมพ์เองได้ บังคับให้เลือกจากแผนที่
              decoration: InputDecoration(
                labelText: 'ที่อยู่หลัก',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton( // <<< ปุ่มสำหรับเปิดแผนที่
                  icon: const Icon(Icons.map),
                  onPressed: _pickAddressFromMap,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 30),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text('บันทึกข้อมูล', style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}