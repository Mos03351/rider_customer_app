// lib/services/auth_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:3000/api/auth'; // อย่าลืมเปลี่ยน IP ให้ถูกต้อง

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
        final Map<String, dynamic> userData = responseData['user']; // <<< ดึงข้อมูล User จาก Response

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('jwtToken', token);
        // *** บันทึกชื่อและอีเมลผู้ใช้ลง SharedPreferences ***
        await prefs.setString('userName', userData['name'] ?? 'ผู้ใช้งาน');
        await prefs.setString('userEmail', userData['email'] ?? 'user@example.com');


        return {'success': true, 'message': 'เข้าสู่ระบบสำเร็จ'};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'เข้าสู่ระบบไม่สำเร็จ'};
      }
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'};
    }
  }

  // --- เพิ่มฟังก์ชันสำหรับการลงทะเบียนตรงนี้ ---
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'), // Endpoint สำหรับ Register
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) { // 201 Created คือสถานะที่เหมาะสมสำหรับการลงทะเบียนสำเร็จ
        return {'success': true, 'message': 'ลงทะเบียนสำเร็จ! โปรดเข้าสู่ระบบ'};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'ลงทะเบียนไม่สำเร็จ'};
      }
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'};
    }
  }
  // --- สิ้นสุดการเพิ่มฟังก์ชัน register ---

  // ฟังก์ชันสำหรับการออกจากระบบ
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('jwtToken');
  }

  // ฟังก์ชันตรวจสอบสถานะการล็อกอิน
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final String? token = prefs.getString('jwtToken');
    return loggedIn && token != null;
  }

  // ตัวอย่างการเรียก API ที่ต้องการ JWT Token
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');

    if (token == null) {
      return {'success': false, 'message': 'ไม่พบ Token, กรุณาเข้าสู่ระบบใหม่', 'logout': true};
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body)['data']; // เข้าถึง 'data' key
        // ตรวจสอบและส่งค่า latitude, longitude, address_text กลับไป
        return {
          'success': true,
          'data': {
            'name': responseData['name'],
            'email': responseData['email'],
            'phone': responseData['phone'],
            'address_text': responseData['address_text'], // <<< รับ
            'latitude': responseData['latitude'],       // <<< รับ
            'longitude': responseData['longitude'],      // <<< รับ
          }
        };
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await logout();
        return {'success': false, 'message': 'Session หมดอายุ, กรุณาเข้าสู่ระบบใหม่', 'logout': true};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'เกิดข้อผิดพลาดในการดึงข้อมูลโปรไฟล์'};
      }
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'};
    }
  }

  // อัปเดตข้อมูลโปรไฟล์
  Future<Map<String, dynamic>> updateUserProfile(
      String name,
      String email,
      String? phone,
      String? addressText,  // <<< เปลี่ยนชื่อ
      double? latitude,     // <<< เพิ่ม
      double? longitude) async { // <<< เพิ่ม
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');

    if (token == null) {
      return {'success': false, 'message': 'ไม่พบ Token, กรุณาเข้าสู่ระบบใหม่', 'logout': true};
    }

    try {
      final response = await http.put( // หรือ http.post ตามที่คุณเลือกใน Backend
        Uri.parse('$_baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'address_text': addressText, // <<< ส่ง
          'latitude': latitude,       // <<< ส่ง
          'longitude': longitude,      // <<< ส่ง
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // อัปเดตข้อมูลใน SharedPreferences ทันทีหลังจากอัปเดตสำเร็จ
        await prefs.setString('userName', name);
        await prefs.setString('userEmail', email);
        await prefs.setString('userPhone', phone ?? '');
        await prefs.setString('userAddressText', addressText ?? ''); // <<< บันทึก
        await prefs.setDouble('userLatitude', latitude ?? 0.0);    // <<< บันทึก (ใช้ 0.0 เป็น default ถ้า null)
        await prefs.setDouble('userLongitude', longitude ?? 0.0);   // <<< บันทึก (ใช้ 0.0 เป็น default ถ้า null)

        return {'success': true, 'message': responseData['message'] ?? 'อัปเดตข้อมูลสำเร็จ'};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        await logout();
        return {'success': false, 'message': 'Session หมดอายุ, กรุณาเข้าสู่ระบบใหม่', 'logout': true};
      } else {
        final errorData = json.decode(response.body);
        return {'success': false, 'message': errorData['message'] ?? 'อัปเดตข้อมูลไม่สำเร็จ'};
      }
    } catch (e) {
      return {'success': false, 'message': 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e'};
    }
  }
}