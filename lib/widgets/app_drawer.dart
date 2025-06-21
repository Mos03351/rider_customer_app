// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/screens/scheduled_screen.dart';
import 'package:rider_customer_app/screens/home_screen.dart';
import 'package:rider_customer_app/screens/trip_history_screen.dart'; // ตรวจสอบให้แน่ใจว่า import ถูกต้อง

// หากคุณมี login_page.dart และ auth_service.dart ให้ uncomment บรรทัดเหล่านี้
// import 'package:rider_customer_app/screens/login_page.dart';
// import 'package:rider_customer_app/services/auth_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';


class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _userName = 'ผู้ใช้งาน';
  String _userEmail = 'user@example.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // TODO: ดึงข้อมูลผู้ใช้จริงจาก SharedPreferences หรือ API
    // final prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _userName = prefs.getString('userName') ?? 'ผู้ใช้งาน';
    //   _userEmail = prefs.getString('userEmail') ?? 'user@example.com';
    // });
  }

  Future<void> _logout() async {
    // TODO: ใส่ logic ออกจากระบบจริง (เช่นเรียก AuthService)
    // final AuthService authService = AuthService();
    // await authService.logout();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ออกจากระบบแล้ว'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
      // สำหรับการทดสอบ ให้กลับหน้าหลัก
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              _userName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.invertedTextColor),
            ),
            accountEmail: Text(
              _userEmail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.invertedTextColor.withOpacity(0.8)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppTheme.highlightColor,
              child: Icon(Icons.person, size: 40, color: AppTheme.primaryColor),
            ),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: AppTheme.textColor),
            title: Text('หน้าหลัก', style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: AppTheme.textColor),
            title: Text('การจองล่วงหน้า', style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduledScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: AppTheme.textColor),
            title: Text('ประวัติการเดินทาง', style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TripHistoryScreen()), // **โค้ดบรรทัดนี้คือจุดที่เคยมีปัญหา**
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.payments, color: AppTheme.textColor),
            title: Text('วิธีการชำระเงิน', style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigator.pushNamed(context, '/payment_methods');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('ไปยังหน้าวิธีการชำระเงิน')));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: AppTheme.textColor),
            title: Text('ตั้งค่า', style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigator.pushNamed(context, '/settings');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('ไปยังหน้าตั้งค่า')));
            },
          ),
          Divider(color: AppTheme.dividerColor),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.errorColor),
            title: Text('ออกจากระบบ', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.errorColor)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}