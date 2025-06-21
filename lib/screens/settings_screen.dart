// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/screens/login_page.dart';
import 'package:rider_customer_app/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    // TODO: โหลดค่าการตั้งค่าจริงจาก SharedPreferences หรือ Backend
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    print('Notifications: $_notificationsEnabled');
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkModeEnabled = value;
    });
    print('Dark Mode: $_darkModeEnabled');
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตั้งค่า',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'การแจ้งเตือน',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            // แก้ไข: ใช้ Divider() โดยตรงแล้วปรับ height/thickness/color
            const Divider(height: 16, thickness: 1, color: AppTheme.dividerColor),
            Card(
              child: SwitchListTile(
                title: Text('เปิดใช้งานการแจ้งเตือน', style: Theme.of(context).textTheme.bodyLarge),
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'รูปลักษณ์',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            // แก้ไข: ใช้ Divider() โดยตรงแล้วปรับ height/thickness/color
            const Divider(height: 16, thickness: 1, color: AppTheme.dividerColor),
            Card(
              child: SwitchListTile(
                title: Text('โหมดกลางคืน (Dark Mode)', style: Theme.of(context).textTheme.bodyLarge),
                value: _darkModeEnabled,
                onChanged: _toggleDarkMode,
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all(AppTheme.errorColor),
                  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50)),
                ),
                child: Text(
                  'ออกจากระบบ',
                  style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet()),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'เวอร์ชันแอป: 1.0.0',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}