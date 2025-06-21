// lib/main.dart

import 'package:flutter/material.dart';
import 'package:rider_customer_app/screens/auth_check_screen.dart';
import 'package:rider_customer_app/screens/home_screen.dart';
import 'package:rider_customer_app/screens/profile_screen.dart';
import 'package:rider_customer_app/screens/history_screen.dart';
import 'package:rider_customer_app/screens/scheduled_screen.dart';
import 'package:rider_customer_app/screens/help_screen.dart';
import 'package:rider_customer_app/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ไปไหนดี?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const AuthCheckScreen(),
      // <<< เพิ่มบรรทัดนี้เพื่อซ่อน Debug Banner
      debugShowCheckedModeBanner: false, // <<<<<<<<<<<<<<<<
      // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      routes: {
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/history': (context) => const HistoryScreen(),
        '/scheduled': (context) => const ScheduledScreen(),
        '/help': (context) => const HelpScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}