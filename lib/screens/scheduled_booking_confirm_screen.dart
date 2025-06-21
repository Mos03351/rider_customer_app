import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:intl/intl.dart'; // สำหรับการฟอร์แมตวันที่และเวลา

class ScheduledBookingConfirmScreen extends StatelessWidget {
  final String pickupLocation;
  final String destination;
  final DateTime scheduledTime;
  final String? carType; // ทำให้เป็น optional ตามที่แก้ไขใน home_screen.dart

  const ScheduledBookingConfirmScreen({
    Key? key,
    required this.pickupLocation,
    required this.destination,
    required this.scheduledTime,
    this.carType, // ไม่ต้องใส่ required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(scheduledTime); // เช่น Monday, 1 July 2025
    final String formattedTime = DateFormat('HH:mm น.').format(scheduledTime); // เช่น 08:00 น.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ยืนยันการจองล่วงหน้า',
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
            // Header: สรุปข้อมูลการจอง
            Text(
              'ตรวจสอบรายละเอียดการจองของคุณ',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
            ),
            const SizedBox(height: 16),

            // Card แสดงรายละเอียดการเดินทาง
            Card(
              elevation: 4, // เพิ่มเงาเล็กน้อย
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // ขอบมน
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // วันที่และเวลาจอง
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_today,
                      label: 'วันที่และเวลา:',
                      value: '$formattedDate, $formattedTime',
                      iconColor: AppTheme.accentColor,
                    ),
                    const Divider(height: 24, thickness: 1, color: AppTheme.dividerColor), // เส้นแบ่ง

                    // จุดรับ
                    _buildDetailRow(
                      context,
                      icon: Icons.circle,
                      label: 'จุดรับ:',
                      value: pickupLocation,
                      iconColor: AppTheme.successColor,
                    ),
                    _buildDashedLine(context), // เส้นประ
                    // จุดส่ง
                    _buildDetailRow(
                      context,
                      icon: Icons.location_on,
                      label: 'จุดส่ง:',
                      value: destination,
                      iconColor: AppTheme.primaryColor,
                    ),
                    const Divider(height: 24, thickness: 1, color: AppTheme.dividerColor),

                    // ประเภทรถ (ถ้ามี)
                    if (carType != null)
                      _buildDetailRow(
                        context,
                        icon: Icons.directions_car,
                        label: 'ประเภทรถ:',
                        value: carType!,
                        iconColor: AppTheme.highlightColor,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ปุ่มยืนยันการจอง
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Logic สำหรับยืนยันการจองล่วงหน้าจริง (ส่งข้อมูลไป Backend)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('กำลังยืนยันการจองล่วงหน้า...'),
                      backgroundColor: AppTheme.primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                  // ตัวอย่าง: ไปหน้าสำเร็จ หรือกลับหน้าหลัก
                  Navigator.popUntil(context, (route) => route.isFirst); // กลับไปหน้าแรกสุด
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('จองการเดินทางล่วงหน้าสำเร็จแล้ว!'),
                      backgroundColor: AppTheme.successColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text('ยืนยันการจอง'),
              ),
            ),
            const SizedBox(height: 12),
            // ปุ่มยกเลิก/แก้ไข
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // กลับไปหน้าก่อนหน้าเพื่อแก้ไข
                },
                style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                      foregroundColor: MaterialStateProperty.all(AppTheme.textColor),
                      side: MaterialStateProperty.all(BorderSide(color: AppTheme.dividerColor)),
                    ),
                child: const Text('แก้ไขข้อมูลการจอง'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget สำหรับแสดงรายละเอียดแต่ละบรรทัด
  Widget _buildDetailRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor ?? AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTextColor,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget สำหรับเส้นประ
  Widget _buildDashedLine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, top: 2.0, bottom: 2.0), // จัดให้ตรงกับไอคอน
      child: SizedBox(
        height: 24, // ความยาวของเส้นประ
        child: CustomPaint(
          painter: _DashedLinePainter(color: AppTheme.lightTextColor.withOpacity(0.5)),
        ),
      ),
    );
  }
}

// CustomPainter สำหรับเส้นประ (คัดลอกมาจาก scheduled_screen.dart)
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 4.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double currentY = 0;
    while (currentY < size.height) {
      canvas.drawLine(Offset(0, currentY), Offset(0, currentY + dashWidth), paint);
      currentY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}