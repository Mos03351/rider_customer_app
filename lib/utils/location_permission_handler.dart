import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // อย่าลืมเพิ่ม geolocator ใน pubspec.yaml

class LocationPermissionHandler {
  static Future<void> determinePosition({
    required Function(Position) onLocationDetermined, // Callback เมื่อได้ตำแหน่ง
    required Function(String) onError, // Callback เมื่อเกิดข้อผิดพลาด
    required BuildContext context, // สำหรับแสดง SnackBar
  }) async {
    bool serviceEnabled;
    LocationPermission permission;

    // ตรวจสอบว่า Location services เปิดอยู่หรือไม่
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) { // ตรวจสอบ mounted ก่อนใช้ context
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('กรุณาเปิด Location services เพื่อใช้งานแอพ')),
        );
      }
      onError('Location services are disabled.');
      return;
    }

    // ตรวจสอบสถานะการอนุญาต
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // ขออนุญาต
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('คุณไม่ได้ให้สิทธิ์เข้าถึงตำแหน่ง')),
          );
        }
        onError('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('คุณปฏิเสธการเข้าถึงตำแหน่งถาวร กรุณาไปตั้งค่าในเครื่อง')),
        );
      }
      onError('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // เมื่อได้รับอนุญาตแล้ว ให้ดึงตำแหน่ง
    try {
      Position position = await Geolocator.getCurrentPosition();
      onLocationDetermined(position); // เรียก callback พร้อมตำแหน่งที่ได้
    } catch (e) {
      onError('ไม่สามารถดึงตำแหน่งปัจจุบันได้: $e'); // เรียก callback พร้อมข้อผิดพลาด
    }
  }
}