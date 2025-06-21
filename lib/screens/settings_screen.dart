import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // อาจจะใช้สำหรับบางการตั้งค่า

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true; // สถานะจำลองสำหรับการตั้งค่าการแจ้งเตือน
  String _selectedLanguage = 'ไทย'; // สถานะจำลองสำหรับภาษา

  @override
  void initState() {
    super.initState();
    // โหลดการตั้งค่าที่บันทึกไว้ (ถ้ามี)
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'ไทย';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setString('selectedLanguage', _selectedLanguage);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('บันทึกการตั้งค่าแล้ว')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่า'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // การตั้งค่าทั่วไป
          const Text(
            'ทั่วไป',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const Divider(),
          ListTile(
            title: const Text('เปิดใช้งานการแจ้งเตือน'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSettings(); // บันทึกการตั้งค่าทันที
              },
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            title: const Text('ภาษา'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                  _saveSettings(); // บันทึกการตั้งค่าทันที
                }
              },
              items: <String>['ไทย', 'English']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 30),

          // การตั้งค่าบัญชี
          const Text(
            'บัญชี',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const Divider(),
          ListTile(
            title: const Text('เปลี่ยนรหัสผ่าน'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('เปิดหน้าเปลี่ยนรหัสผ่าน')),
              );
              // TODO: Navigator.pushNamed(context, '/change_password');
            },
          ),
          ListTile(
            title: const Text('จัดการวิธีการชำระเงิน'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('เปิดหน้าจัดการวิธีการชำระเงิน')),
              );
              // TODO: Navigator.pushNamed(context, '/payment_methods');
            },
          ),
          const SizedBox(height: 30),

          // เกี่ยวกับแอป
          const Text(
            'เกี่ยวกับ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          const Divider(),
          ListTile(
            title: const Text('เวอร์ชันแอป'),
            trailing: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('ข้อกำหนดและเงื่อนไข'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('เปิดหน้าข้อกำหนดและเงื่อนไข')),
              );
              // TODO: เปิด URL หรือหน้า Terms & Conditions
            },
          ),
          ListTile(
            title: const Text('นโยบายความเป็นส่วนตัว'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('เปิดหน้านโยบายความเป็นส่วนตัว')),
              );
              // TODO: เปิด URL หรือหน้า Privacy Policy
            },
          ),
        ],
      ),
    );
  }
}