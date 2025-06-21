// lib/screens/auth_check_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/screens/home_screen.dart';
import 'package:rider_customer_app/screens/login_page.dart';
import 'package:rider_customer_app/services/auth_service.dart'; // Import AuthService

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final bool loggedIn = await AuthService.isLoggedIn(); // ใช้ AuthService ตรวจสอบ

    // ตรวจสอบว่า Widget ยัง Mount อยู่ก่อนที่จะใช้ Navigator
    if (mounted) {
      if (loggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // แสดง Loading ขณะตรวจสอบสถานะ
      ),
    );
  }
}