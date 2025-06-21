// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/screens/login_page.dart';
import 'package:rider_customer_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import นี้ถูกต้องแล้ว

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _userName = 'ผู้ใช้งาน'; // สถานะสำหรับชื่อผู้ใช้
  String _userEmail = 'user@example.com'; // สถานะสำหรับอีเมลผู้ใช้

  @override
  void initState() {
    super.initState();
    _loadUserData(); // โหลดข้อมูลผู้ใช้เมื่อ Widget ถูกสร้าง
  }

  // ฟังก์ชันสำหรับโหลดข้อมูลผู้ใช้จาก SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'ผู้ใช้งาน';
      _userEmail = prefs.getString('userEmail') ?? 'user@example.com';
    });
  }

  // ฟังก์ชันสำหรับออกจากระบบ
  Future<void> _logout() async { // ไม่ต้องรับ BuildContext ตรงๆ แล้ว เพราะเป็น StatefulWidget
    final AuthService authService = AuthService();
    await authService.logout();

    // ตรวจสอบว่า Widget ยังคงอยู่ใน Widget Tree ก่อนใช้งาน Navigator
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // ใช้ UserAccountsDrawerHeader เพื่อแสดงข้อมูลผู้ใช้
          UserAccountsDrawerHeader(
            accountName: Text(
              _userName, // แสดงชื่อผู้ใช้จาก State
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              _userEmail, // แสดงอีเมลผู้ใช้จาก State
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('โปรไฟล์'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('ประวัติการเดินทาง'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('การจองล่วงหน้า'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/scheduled');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('ช่วยเหลือ'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/help');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('ตั้งค่า'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('ออกจากระบบ', style: TextStyle(color: Colors.red)),
            onTap: _logout, // เรียกใช้ _logout โดยตรง
          ),
        ],
      ),
    );
  }
}