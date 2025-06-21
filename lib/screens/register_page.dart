// lib/screens/register_page.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/widgets/register_form.dart'; // Import RegisterForm

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ลงทะเบียน'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add, // Icon ที่เกี่ยวข้องกับการลงทะเบียน
                size: 100,
                color: Colors.blue[600],
              ),
              const SizedBox(height: 30),
              const Text(
                'สร้างบัญชีใหม่',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'กรอกข้อมูลของคุณเพื่อลงทะเบียน',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // ใช้ RegisterForm Widget ที่แยกออกมา
              RegisterForm(
                onRegisterSuccess: () {
                  // เมื่อลงทะเบียนสำเร็จ จะกลับไปหน้า Login
                  Navigator.pop(context); // กลับไปหน้าก่อนหน้า (LoginPage)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}