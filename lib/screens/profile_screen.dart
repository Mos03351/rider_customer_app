import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ของฉัน'),
        backgroundColor: Colors.blue, // สี AppBar ที่แตกต่างกันเล็กน้อย
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // ใช้ SingleChildScrollView เพื่อให้เลื่อนได้ถ้าข้อมูลเยอะ
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'ชื่อผู้ใช้: คุณผู้ใช้งาน',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'อีเมล: user@example.com',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'เบอร์โทรศัพท์: 081-234-5678',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // ปุ่มแก้ไขโปรไฟล์
            ElevatedButton.icon(
              onPressed: () {
                // TODO: เพิ่ม Logic สำหรับแก้ไขโปรไฟล์
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เปิดหน้าจอแก้ไขโปรไฟล์')),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                'แก้ไขโปรไฟล์',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ส่วนข้อมูลอื่นๆ เช่น ที่อยู่, วิธีชำระเงิน (ถ้ามี)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: const ListTile(
                leading: Icon(Icons.location_on, color: Colors.blue),
                title: Text('ที่อยู่โปรด'),
                subtitle: Text('บ้านเลขที่ 123, ถนนสุขุมวิท, กทม.'),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: const ListTile(
                leading: Icon(Icons.security, color: Colors.blue),
                title: Text('รหัสผ่านและการรักษาความปลอดภัย'),
                subtitle: Text('จัดการการตั้งค่าความปลอดภัยของคุณ'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}