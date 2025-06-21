// lib/main.dart

import 'package:flutter/material.dart';
import 'package:rider_customer_app/screens/auth_check_screen.dart';
import 'package:rider_customer_app/screens/home_screen.dart';
import 'package:rider_customer_app/screens/login_page.dart'; // ตรวจสอบว่ามีการ import แล้ว
import 'package:rider_customer_app/screens/register_page.dart'; // <<< เพิ่มการ import หน้าลงทะเบียน
import 'package:rider_customer_app/screens/profile_screen.dart'; 
import 'package:rider_customer_app/screens/history_screen.dart';
import 'package:rider_customer_app/screens/scheduled_screen.dart';
import 'package:rider_customer_app/screens/help_screen.dart';
import 'package:rider_customer_app/screens/settings_screen.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/screens/search_destination_screen.dart'; // <<< เพิ่มการ import
import 'package:rider_customer_app/screens/confirm_booking_screen.dart'; // <<< เพิ่มการ import
import 'package:rider_customer_app/screens/rider_matching_screen.dart'; // <<< เพิ่ม import
import 'package:rider_customer_app/screens/scheduled_booking_confirm_screen.dart'; // <<< เพิ่ม import


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ไปไหนดี?', 
      theme: AppTheme.lightTheme, // <<< ใช้ธีมที่คุณสร้างขึ้น
      home: const AuthCheckScreen(), 
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginPage(), // เพิ่ม login route ไว้ถ้าจะใช้
        '/register': (context) => const RegisterPage(), // <<< เพิ่ม Register Page Route
        '/profile': (context) => const ProfileScreen(), 
        '/history': (context) => const HistoryScreen(),
        '/scheduled': (context) => const ScheduledScreen(),
        '/help': (context) => const HelpScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/search_destination': (context) => const SearchDestinationScreen(),
      },
    );
  }
}