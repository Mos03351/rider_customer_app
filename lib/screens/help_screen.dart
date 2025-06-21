// lib/screens/help_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
// import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ช่วยเหลือและติดต่อเรา',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'คำถามที่พบบ่อย (FAQ)',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            // แก้ไข: ใช้ Divider() โดยตรงแล้วปรับ height/thickness/color
            const Divider(height: 16, thickness: 1, color: AppTheme.dividerColor),
            Card(
              child: ExpansionTile(
                title: Text('วิธีเรียกไรเดอร์?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'คุณสามารถเรียกไรเดอร์ได้โดยกรอกจุดหมายปลายทางในหน้าหลัก แล้วกดปุ่ม "เรียกไรเดอร์" ครับ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ExpansionTile(
                title: Text('ยกเลิกการเดินทางทำอย่างไร?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'ขณะอยู่ในระหว่างการเดินทาง คุณสามารถกดปุ่ม "ยกเลิก" ที่มุมขวาบนของหน้าจอได้เลยครับ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'ติดต่อเรา',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            // แก้ไข: ใช้ Divider() โดยตรงแล้วปรับ height/thickness/color
            const Divider(height: 16, thickness: 1, color: AppTheme.dividerColor),
            Card(
              child: ListTile(
                leading: Icon(Icons.call, color: AppTheme.primaryColor),
                title: Text('โทรศัพท์', style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text('081-234-5678', style: Theme.of(context).textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.lightTextColor),
                onTap: () {
                  print('โทร 081-234-5678');
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.email, color: AppTheme.primaryColor),
                title: Text('อีเมล', style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text('support@your_app.com', style: Theme.of(context).textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.lightTextColor),
                onTap: () {
                  print('ส่งอีเมล support@your_app.com');
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(Icons.chat, color: AppTheme.primaryColor),
                title: Text('แชทกับเจ้าหน้าที่', style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text('บริการ 24 ชั่วโมง', style: Theme.of(context).textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.lightTextColor),
                onTap: () {
                  print('เปิดแชทกับเจ้าหน้าที่');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}