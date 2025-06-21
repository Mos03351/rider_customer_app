import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ช่วยเหลือ'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'คำถามที่พบบ่อย (FAQ)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            _buildExpansionTile(
              title: 'ฉันจะเรียกรถได้อย่างไร?',
              content: 'คุณสามารถเรียกรถได้โดยการป้อนจุดรับและจุดหมายปลายทาง จากนั้นเลือกประเภทรถที่ต้องการและกดยืนยันการเรียกรถ',
            ),
            _buildExpansionTile(
              title: 'ฉันสามารถจองรถล่วงหน้าได้หรือไม่?',
              content: 'ได้ครับ! คุณสามารถสลับโหมดเป็น "จองล่วงหน้า" และเลือกวันที่และเวลาที่คุณต้องการให้รถไปรับได้',
            ),
            _buildExpansionTile(
              title: 'มีค่าใช้จ่ายเท่าไหร่?',
              content: 'ค่าใช้จ่ายจะแสดงให้เห็นเมื่อคุณเลือกประเภทรถและป้อนจุดหมายปลายทางแล้ว โปรดตรวจสอบราคาก่อนยืนยันการเดินทาง',
            ),
            _buildExpansionTile(
              title: 'ฉันจะยกเลิกการเดินทางได้อย่างไร?',
              content: 'คุณสามารถยกเลิกการเดินทางที่กำลังจะมาถึงได้ที่หน้า "การจองล่วงหน้า" หรือ "ประวัติการเดินทาง" (หากยังอยู่ในสถานะที่ยกเลิกได้)',
            ),
            _buildExpansionTile(
              title: 'ทำไมฉันถึงไม่ได้รับอนุญาตให้เข้าถึงตำแหน่ง?',
              content: 'โปรดตรวจสอบการตั้งค่าความเป็นส่วนตัวในโทรศัพท์ของคุณ และอนุญาตให้แอปเข้าถึงตำแหน่งเมื่อใช้งานแอป',
            ),
            const SizedBox(height: 30),
            const Text(
              'ติดต่อเรา',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('ส่งอีเมลถึงเรา'),
              subtitle: const Text('support@yourapp.com'),
              onTap: () {
                // TODO: เพิ่ม Logic สำหรับเปิดแอปอีเมล
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กำลังเปิดแอปอีเมล...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text('โทรหาเรา'),
              subtitle: const Text('02-123-4567'),
              onTap: () {
                // TODO: เพิ่ม Logic สำหรับโทรออก
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('กำลังโทรออก...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method เพื่อสร้าง ExpansionTile ได้ง่ายขึ้น
  Widget _buildExpansionTile({required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}