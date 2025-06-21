// lib/services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 💡 สำคัญ: เปลี่ยน IP address นี้ให้ตรงกับ IP ของ Backend ของคุณ
  // ถ้าคุณรัน Emulator/Simulator บนเครื่องเดียวกับ Backend สามารถใช้ 10.0.2.2 สำหรับ Android Emulator
  // หรือ localhost สำหรับ iOS Simulator/desktop
  static const String _baseUrl = 'http://192.168.1.100:3000/api/auth'; 

  // ฟังก์ชันสำหรับการเข้าสู่ระบบ
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String token = responseData['token'];

        // บันทึกสถานะล็อกอินและ Token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('jwtToken', token);

        return {'success': true, 'message': 'เข้าสู่ระบบสำเร็จ'};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'เข้าสู่ระบบไม่สำเร็จ'};
      }
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'};
    }
  }

  // ฟังก์ชันสำหรับการออกจากระบบ
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('jwtToken'); // ลบ Token ออกจาก SharedPreferences
  }

  // ฟังก์ชันตรวจสอบสถานะการล็อกอิน (ใช้ใน AuthCheckScreen)
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final String? token = prefs.getString('jwtToken');

    // อาจจะเพิ่ม logic ตรวจสอบความถูกต้องของ token (เช่น หมดอายุ) ที่นี่
    // แต่สำหรับการเริ่มต้น แค่มี token และสถานะ loggedIn ก็เพียงพอ
    return loggedIn && token != null;
  }

  // ตัวอย่างการเรียก API ที่ต้องการ JWT Token
  // คุณสามารถเพิ่ม method อื่นๆ สำหรับการเรียก API ที่ต้องมีการยืนยันตัวตนได้ที่นี่
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');

    if (token == null) {
      return {'success': false, 'message': 'ไม่พบ Token, กรุณาเข้าสู่ระบบใหม่'};
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'), // ต้องแน่ใจว่า Backend มี Endpoint /api/auth/profile
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Token หมดอายุหรือไม่ถูกต้อง
        await logout(); // ล้างสถานะล็อกอิน
        return {'success': false, 'message': 'Session หมดอายุ, กรุณาเข้าสู่ระบบใหม่'};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'เกิดข้อผิดพลาดในการดึงข้อมูลโปรไฟล์'};
      }
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'};
    }
  }
}