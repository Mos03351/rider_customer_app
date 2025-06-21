// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/services/auth_service.dart';
import 'package:rider_customer_app/screens/edit_profile_page.dart';
import 'package:rider_customer_app/screens/login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'กำลังโหลด...';
  String _userEmail = 'กำลังโหลด...';
  String _userPhone = 'ยังไม่มีเบอร์โทร';
  String _userAddressText = 'ยังไม่มีที่อยู่'; // <<< เปลี่ยนชื่อ
  double? _userLatitude;   // <<< เพิ่ม
  double? _userLongitude;  // <<< เพิ่ม

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    final AuthService authService = AuthService();
    final result = await authService.fetchUserProfile();

    if (mounted) {
      if (result['success']) {
        setState(() {
          _userName = result['data']['name'] ?? 'ไม่ระบุชื่อ';
          _userEmail = result['data']['email'] ?? 'ไม่ระบุอีเมล';
          _userPhone = result['data']['phone'] ?? 'ยังไม่มีเบอร์โทร';
          _userAddressText = result['data']['address_text'] ?? 'ยังไม่มีที่อยู่'; // <<< อัปเดต
          _userLatitude = result['data']['latitude'];   // <<< อัปเดต
          _userLongitude = result['data']['longitude'];  // <<< อัปเดต
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
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

  Future<void> _navigateToEditProfile() async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentName: _userName,
          currentEmail: _userEmail,
          currentPhone: _userPhone,
          currentAddressText: _userAddressText, // <<< ส่ง
          currentLatitude: _userLatitude,       // <<< ส่ง
          currentLongitude: _userLongitude,     // <<< ส่ง
        ),
      ),
    );

    if (result == true) {
      _fetchUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ของฉัน'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _userName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _userEmail,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const Divider(height: 40),
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.phone, color: Colors.blue),
                      title: const Text('เบอร์โทรศัพท์'),
                      subtitle: Text(_userPhone),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: _navigateToEditProfile,
                      ),
                    ),
                  ),
                  // แสดงที่อยู่หลักพร้อมพิกัด
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.blue),
                      title: const Text('ที่อยู่หลัก'),
                      subtitle: Text(
                        _userAddressText +
                        ((_userLatitude != null && _userLongitude != null)
                            ? '\n(Lat: ${_userLatitude!.toStringAsFixed(6)}, Lon: ${_userLongitude!.toStringAsFixed(6)})'
                            : ''),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: _navigateToEditProfile,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _navigateToEditProfile,
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('แก้ไขโปรไฟล์', style: TextStyle(fontSize: 18, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}