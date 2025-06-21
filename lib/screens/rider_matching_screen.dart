// lib/screens/rider_matching_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/screens/in_trip_screen.dart';
import 'package:rider_customer_app/screens/home_screen.dart';

class RiderMatchingScreen extends StatefulWidget {
  final String pickupLocation;
  final String destination;
  final String selectedCarType; // เพิ่มพารามิเตอร์นี้
  final double estimatedPrice; // เพิ่มพารามิเตอร์นี้

  const RiderMatchingScreen({
    Key? key,
    required this.pickupLocation,
    required this.destination,
    required this.selectedCarType, // ทำให้เป็น required
    required this.estimatedPrice, // ทำให้เป็น required
  }) : super(key: key);

  @override
  State<RiderMatchingScreen> createState() => _RiderMatchingScreenState();
}

class _RiderMatchingScreenState extends State<RiderMatchingScreen> {
  bool _isMatching = true;
  String _matchingStatus = 'กำลังค้นหาไรเดอร์ที่ใกล้ที่สุด...';
  bool _foundRider = false; // สถานะเพิ่มเติมเพื่อแยกกรณีพบ/ไม่พบไรเดอร์

  @override
  void initState() {
    super.initState();
    _startMatchingProcess();
  }

  void _startMatchingProcess() {
    // จำลอง: ไรเดอร์ตอบรับภายใน 5 วินาที
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isMatching = false;
          _foundRider = true; // ตั้งค่าว่าพบไรเดอร์แล้ว
          _matchingStatus = 'ไรเดอร์ตอบรับแล้ว!';
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => InTripScreen(
                  driverName: 'นายศักดิ์ชัย มารับ',
                  vehiclePlate: 'ผบ 5678 กทม.',
                  estimatedArrivalTime: '8 นาที',
                  destination: widget.destination,
                  pickupLocation: widget.pickupLocation,
                ),
              ),
            );
          }
        });
      }
    });

    // จำลอง: หากหาไรเดอร์ไม่เจอใน 15 วินาที
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted && _isMatching) { // ตรวจสอบ _isMatching อีกครั้งก่อนแสดง dialog
        setState(() {
          _isMatching = false;
          _foundRider = false; // ตั้งค่าว่าไม่พบไรเดอร์
          _matchingStatus = 'ไม่พบไรเดอร์ในบริเวณใกล้เคียง';
        });
        _showNoRiderDialog();
      }
    });
  }

  void _showNoRiderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิด dialog โดยการแตะภายนอก
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // ขอบมนสวยงาม
          ),
          title: Text(
            'ขออภัย',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
          ),
          content: Text(
            'ขณะนี้ไม่พบไรเดอร์ ${widget.selectedCarType} ในบริเวณใกล้เคียง กรุณาลองอีกครั้งในภายหลัง หรือเลือกประเภทรถอื่น',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightTextColor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pushAndRemoveUntil( // กลับไปหน้า Home และล้าง Stack
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'ตกลง',
                style: Theme.of(context).textButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet())?.copyWith(color: AppTheme.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _cancelMatching() {
    print('Cancelling rider matching...');
    // TODO: ส่งสัญญาณยกเลิกการค้นหาไปยัง Backend
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ยกเลิกการค้นหาไรเดอร์แล้ว'),
          backgroundColor: AppTheme.warningColor, // ใช้สี warning
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pushAndRemoveUntil( // กลับไปหน้า Home และล้าง Stack
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'กำลังค้นหาไรเดอร์',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        // หน้ากำลังค้นหา ไม่ควรมีปุ่มย้อนกลับให้ผู้ใช้กดได้ง่ายๆ
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // เพิ่มข้อมูลการเดินทางและราคาที่คาดการณ์
              Card(
                elevation: Theme.of(context).cardTheme.elevation,
                shape: Theme.of(context).cardTheme.shape,
                color: Theme.of(context).cardColor,
                margin: const EdgeInsets.only(bottom: 24.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context,
                        icon: Icons.directions_car,
                        label: 'ประเภทรถ',
                        value: widget.selectedCarType,
                        iconColor: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                        context,
                        icon: Icons.attach_money,
                        label: 'ราคาประมาณ',
                        value: '฿${widget.estimatedPrice.toStringAsFixed(2)}',
                        iconColor: AppTheme.successColor,
                      ),
                      const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                      _buildDetailRow(
                        context,
                        icon: Icons.circle,
                        label: 'จาก',
                        value: widget.pickupLocation,
                        iconColor: AppTheme.successColor,
                      ),
                      _buildDashedLine(context), // เส้นประ
                      _buildDetailRow(
                        context,
                        icon: Icons.location_on,
                        label: 'ถึง',
                        value: widget.destination,
                        iconColor: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),

              // สถานะการจับคู่ไรเดอร์
              if (_isMatching) ...[
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  strokeWidth: 5,
                ),
                const SizedBox(height: 30),
                Text(
                  _matchingStatus,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: _cancelMatching,
                    style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                      side: MaterialStateProperty.all(const BorderSide(color: AppTheme.errorColor, width: 2)),
                      foregroundColor: MaterialStateProperty.all(AppTheme.errorColor),
                    ),
                    child: const Text('ยกเลิกการค้นหา'),
                  ),
                ),
              ] else ...[
                // แสดงผลเมื่อพบ/ไม่พบไรเดอร์
                Icon(
                  _foundRider ? Icons.check_circle_outline : Icons.error_outline,
                  color: _foundRider ? AppTheme.successColor : AppTheme.errorColor,
                  size: 80,
                ),
                const SizedBox(height: 30),
                Text(
                  _matchingStatus,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _foundRider ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: const Text('กลับสู่หน้าหลัก'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget สำหรับแสดงรายละเอียดแต่ละบรรทัด (คัดลอกจาก ConfirmBookingScreen)
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

  // Helper Widget สำหรับเส้นประ (คัดลอกจาก ConfirmBookingScreen)
  Widget _buildDashedLine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, top: 2.0, bottom: 2.0),
      child: SizedBox(
        height: 24,
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