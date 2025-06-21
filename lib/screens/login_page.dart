// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/widgets/login_form.dart'; // Import LoginForm
import 'package:rider_customer_app/screens/home_screen.dart'; // สำหรับนำทางเมื่อ Login สำเร็จ
import 'package:rider_customer_app/services/auth_service.dart'; // Import AuthService สำหรับ logout ใน AppDrawer

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.car_rental,
                size: 100,
                color: Colors.blue[600],
              ),
              const SizedBox(height: 30),
              const Text(
                'ยินดีต้อนรับสู่ GoRide!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'เข้าสู่ระบบเพื่อเริ่มต้นการเดินทางของคุณ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // ใช้ LoginForm Widget ที่แยกออกมา
              LoginForm(
                onLoginSuccess: () {
                  // เมื่อ LoginForm แจ้งว่า Login สำเร็จ
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}