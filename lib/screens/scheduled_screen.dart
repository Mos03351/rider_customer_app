import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:intl/intl.dart'; // เพิ่ม import สำหรับ DateFormat

class ScheduledScreen extends StatefulWidget {
  const ScheduledScreen({Key? key}) : super(key: key);

  @override
  State<ScheduledScreen> createState() => _ScheduledScreenState();
}

class _ScheduledScreenState extends State<ScheduledScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _scheduledTrips = [];

  @override
  void initState() {
    super.initState();
    _fetchScheduledTrips();
  }

  Future<void> _fetchScheduledTrips() async {
    setState(() {
      _isLoading = true;
    });
    // TODO: ดึงข้อมูลการจองล่วงหน้าจาก Backend
    // จำลองข้อมูลสำหรับการแสดงผล
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _scheduledTrips = [
        {
          'id': 'trip_001', // เพิ่ม ID สำหรับการจัดการที่ง่ายขึ้น
          'dateTime': DateTime(2025, 7, 1, 8, 0), // ใช้ DateTime object
          'pickup': 'บ้าน (123/4 หมู่ 5 สันป่าม่วง)',
          'destination': 'สนามบินลำปาง (อาคารผู้โดยสารขาออก)',
          'status': 'Upcoming',
        },
        {
          'id': 'trip_002',
          'dateTime': DateTime(2025, 7, 10, 14, 30),
          'pickup': 'มหาวิทยาลัย (อาคารเรียนรวม)',
          'destination': 'โรงพยาบาล (แผนกฉุกเฉิน)',
          'status': 'Upcoming',
        },
        // ตัวอย่างรายการที่อาจถูกยกเลิก (สำหรับการทดสอบ)
        // {
        //   'id': 'trip_003',
        //   'dateTime': DateTime(2025, 6, 20, 10, 0),
        //   'pickup': 'ที่ทำงาน',
        //   'destination': 'ร้านอาหาร',
        //   'status': 'Cancelled',
        // },
      ];
      _isLoading = false;
    });
  }

  void _cancelScheduledTrip(int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'ยืนยันการยกเลิก',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
          ),
          content: Text(
            'คุณแน่ใจหรือไม่ที่ต้องการยกเลิกการจองนี้? การกระทำนี้ไม่สามารถย้อนกลับได้',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTextColor,
                ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'ไม่',
                style: Theme.of(context).textButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet())?.copyWith(color: AppTheme.textColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // TODO: Logic สำหรับยกเลิกการจองล่วงหน้าจริง (เรียก API)
                setState(() {
                  _scheduledTrips.removeAt(index); // จำลองการลบรายการ
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ยกเลิกการจองแล้ว'),
                    backgroundColor: AppTheme.successColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStateProperty.all(AppTheme.errorColor),
                    foregroundColor: MaterialStateProperty.all(AppTheme.invertedTextColor),
                  ),
              child: const Text('ใช่, ยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'การจองล่วงหน้า',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLoading
            ? Center(
                key: const ValueKey('loading'),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor)),
              )
            : _scheduledTrips.isEmpty
                ? Center(
                    key: const ValueKey('empty'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 80,
                          color: AppTheme.lightTextColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'คุณยังไม่มีการจองล่วงหน้า',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.lightTextColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'วางแผนการเดินทางของคุณล่วงหน้าได้เลย!',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightTextColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: พาผู้ใช้กลับไปหน้าหลักเพื่อจอง
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('จองการเดินทางใหม่'),
                          style: Theme.of(context).elevatedButtonTheme.style,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    key: const ValueKey('list'),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _scheduledTrips.length,
                    itemBuilder: (context, index) {
                      final trip = _scheduledTrips[index];
                      final DateTime tripDateTime = trip['dateTime'];
                      final String formattedDate = DateFormat('EEEE, d MMM yyyy').format(tripDateTime); // เช่น Monday, 1 Jul 2025
                      final String formattedTime = DateFormat('HH:mm').format(tripDateTime); // เช่น 08:00

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '$formattedDate - $formattedTime น.',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      trip['status'],
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.circle, color: AppTheme.successColor, size: 16),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'จาก: ${trip['pickup']}',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                                    ),
                                  ),
                                ],
                              ),
                              // *** ส่วนแก้ไขเส้นประ ***
                              Padding(
                                padding: const EdgeInsets.only(left: 7.0),
                                child: SizedBox(
                                  height: 20, // ความยาวของเส้นประ
                                  child: CustomPaint(
                                    painter: _DashedLinePainter(color: AppTheme.lightTextColor.withOpacity(0.5)),
                                  ),
                                ),
                              ),
                              // *** สิ้นสุดส่วนแก้ไขเส้นประ ***
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on, color: AppTheme.primaryColor, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'ถึง: ${trip['destination']}',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton(
                                  onPressed: () => _cancelScheduledTrip(index),
                                  style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                                        foregroundColor: MaterialStateProperty.all(AppTheme.errorColor),
                                        side: MaterialStateProperty.all(const BorderSide(color: AppTheme.errorColor)),
                                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 18, vertical: 10)),
                                        textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.labelLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                      ),
                                  child: const Text('ยกเลิกการจอง'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

// *** CustomPainter สำหรับเส้นประ ***
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
      ..strokeCap = StrokeCap.round; // ให้ปลายเส้นมน

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