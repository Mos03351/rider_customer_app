// lib/screens/trip_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/screens/home_screen.dart'; // เพื่อกลับหน้าหลัก

class TripSummaryScreen extends StatefulWidget {
  final String pickupLocation;
  final String destination;
  final String driverName;
  final double pricePaid;
  final String tripId;

  const TripSummaryScreen({
    Key? key,
    required this.pickupLocation,
    required this.destination,
    required this.driverName,
    required this.pricePaid,
    required this.tripId,
  }) : super(key: key);

  @override
  State<TripSummaryScreen> createState() => _TripSummaryScreenState();
}

class _TripSummaryScreenState extends State<TripSummaryScreen> {
  int _starRating = 5; // คะแนนเริ่มต้น

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สรุปการเดินทาง',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        automaticallyImplyLeading: false, // ไม่ให้ผู้ใช้กลับไปหน้า InTrip
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: AppTheme.successColor),
            const SizedBox(height: 20),
            Text(
              'เดินทางถึงจุดหมายแล้ว!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'ขอบคุณที่ใช้บริการของเรา',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.lightTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Card สรุปรายละเอียด
            Card(
              elevation: Theme.of(context).cardTheme.elevation,
              shape: Theme.of(context).cardTheme.shape,
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow(
                      context,
                      label: 'รหัสการเดินทาง:',
                      value: widget.tripId,
                      icon: Icons.receipt_long,
                      iconColor: AppTheme.lightTextColor,
                    ),
                    const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                    _buildSummaryRow(
                      context,
                      label: 'จุดรับ:',
                      value: widget.pickupLocation,
                      icon: Icons.circle,
                      iconColor: AppTheme.successColor,
                    ),
                    _buildSummaryRow(
                      context,
                      label: 'ปลายทาง:',
                      value: widget.destination,
                      icon: Icons.location_on,
                      iconColor: AppTheme.primaryColor,
                    ),
                    const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                    _buildSummaryRow(
                      context,
                      label: 'คนขับ:',
                      value: widget.driverName,
                      icon: Icons.person,
                      iconColor: AppTheme.accentColor,
                    ),
                    const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                    _buildSummaryRow(
                      context,
                      label: 'ค่าเดินทางทั้งหมด:',
                      value: '฿${widget.pricePaid.toStringAsFixed(2)}',
                      icon: Icons.payments,
                      iconColor: AppTheme.primaryColor,
                      isBoldValue: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ส่วนให้คะแนนคนขับ
            Text(
              'ให้คะแนนคนขับของคุณ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _starRating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: AppTheme.highlightColor, // ใช้สีเหลืองสำหรับดาว
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _starRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'เพิ่มความคิดเห็น (ไม่บังคับ)',
                alignLabelWithHint: true,
                border: Theme.of(context).inputDecorationTheme.border,
                enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                filled: Theme.of(context).inputDecorationTheme.filled,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              ),
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),

            // ปุ่ม "ตกลง" / "ส่งคะแนน"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('คะแนน: $_starRating ดาว, ความคิดเห็น: (TODO) ');
                  // TODO: ส่งคะแนนและข้อมูลการเดินทางไปยัง Backend
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ส่งคะแนนเรียบร้อยแล้ว!'),
                      backgroundColor: AppTheme.successColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                  Navigator.pushAndRemoveUntil( // กลับไปหน้าหลักและล้าง Stack
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text('ให้คะแนนและดำเนินการต่อ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget สำหรับแสดงสรุปข้อมูลแต่ละบรรทัด
  Widget _buildSummaryRow(BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? iconColor,
    bool isBoldValue = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor ?? AppTheme.primaryColor),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTextColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
                color: isBoldValue ? AppTheme.primaryColor : AppTheme.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}