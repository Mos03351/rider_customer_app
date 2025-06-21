// lib/screens/in_trip_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/screens/trip_summary_screen.dart';
import 'package:rider_customer_app/screens/home_screen.dart';

class InTripScreen extends StatefulWidget {
  final String driverName;
  final String vehiclePlate;
  final String estimatedArrivalTime;
  final String destination;
  final String pickupLocation;

  const InTripScreen({
    Key? key,
    required this.driverName,
    required this.vehiclePlate,
    required this.estimatedArrivalTime,
    required this.destination,
    required this.pickupLocation,
  }) : super(key: key);

  @override
  State<InTripScreen> createState() => _InTripScreenState();
}

class _InTripScreenState extends State<InTripScreen> {
  String _currentStatus = 'ไรเดอร์กำลังเดินทางมารับ'; // สถานะเริ่มต้น
  // คุณสามารถเพิ่มตัวแปรสำหรับเวลาที่เหลือจริง, ระยะทาง
  // และใช้ StreamBuilder/FutureBuilder สำหรับอัปเดตข้อมูลจาก Backend จริงๆ

  @override
  void initState() {
    super.initState();
    _simulateTripProgress();
  }

  void _simulateTripProgress() {
    // จำลองการเปลี่ยนสถานะ
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _currentStatus = 'ไรเดอร์มาถึงจุดรับแล้ว';
        });
      }
    });
    Future.delayed(const Duration(seconds: 25), () {
      if (mounted) {
        setState(() {
          _currentStatus = 'กำลังเดินทางสู่จุดหมาย';
        });
      }
    });
    Future.delayed(const Duration(seconds: 40), () {
      if (mounted) {
        setState(() {
          _currentStatus = 'เดินทางถึงจุดหมายแล้ว';
        });
        _showTripCompletedDialog();
      }
    });
  }

  void _callDriver() {
    print('Calling driver: ${widget.driverName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('กำลังโทรหา ${widget.driverName}...'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.primaryColor, // ใช้สีธีม
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
    // TODO: ใส่ logic การโทรจริง (เช่น url_launcher)
  }

  void _chatWithDriver() {
    print('Opening chat with driver: ${widget.driverName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เปิดแชทกับ ${widget.driverName}...'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.primaryColor, // ใช้สีธีม
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
    // TODO: ใส่ logic การเปิดหน้าแชทจริง
  }

  void _cancelTrip() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'ยืนยันการยกเลิก',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'คุณแน่ใจหรือไม่ที่ต้องการยกเลิกการเดินทาง? อาจมีค่าธรรมเนียมการยกเลิก',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'ไม่',
                style: Theme.of(context).textButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet())?.copyWith(color: AppTheme.lightTextColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('ยกเลิกการเดินทางแล้ว'),
                    backgroundColor: AppTheme.errorColor,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
                // TODO: Logic ยกเลิกการเดินทางจริงบน Backend
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(backgroundColor: MaterialStateProperty.all(AppTheme.errorColor)),
              child: Text('ใช่, ยกเลิก', style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet())),
            ),
          ],
        );
      },
    );
  }

  void _showTripCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'เดินทางถึงจุดหมายแล้ว!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.successColor),
          ),
          content: Text(
            'ขอบคุณที่ใช้บริการของเรา หวังว่าคุณจะได้รับประสบการณ์ที่ดี',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textColor),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pushReplacement( // เปลี่ยนเป็น pushReplacement
                  context,
                  MaterialPageRoute(builder: (context) => TripSummaryScreen(
                    pickupLocation: widget.pickupLocation,
                    destination: widget.destination,
                    driverName: widget.driverName,
                    pricePaid: 125.0, // TODO: ราคาจริง
                    tripId: 'TRIP-${DateTime.now().millisecondsSinceEpoch}', // TODO: ID จริง
                  )),
                );
              },
              style: Theme.of(context).elevatedButtonTheme.style,
              child: const Text('ให้คะแนนการเดินทาง'),
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
          'กำลังเดินทาง',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        automaticallyImplyLeading: false, // ปิดปุ่มย้อนกลับขณะเดินทาง
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: AppTheme.invertedTextColor),
            onPressed: _cancelTrip,
            tooltip: 'ยกเลิกการเดินทาง',
          ),
        ],
      ),
      body: Stack(
        children: [
          // TODO: แทนที่ด้วยแผนที่แสดงตำแหน่งไรเดอร์และเส้นทางจริง
          Container(
            color: AppTheme.backgroundColor,
            alignment: Alignment.center,
            child: Text(
              'แผนที่ติดตามไรเดอร์และเส้นทาง',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.lightTextColor),
            ),
          ),

          // ข้อมูลไรเดอร์และตัวเลือกการติดต่อ
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'สถานะการเดินทาง: $_currentStatus',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                  ),
                  const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppTheme.accentColor,
                        child: Icon(Icons.person, size: 30, color: AppTheme.invertedTextColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.driverName,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                            ),
                            Text(
                              'ทะเบียนรถ: ${widget.vehiclePlate}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightTextColor),
                            ),
                             Text(
                              'จาก: ${widget.pickupLocation}', // แสดงจุดรับ
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.lightTextColor),
                            ),
                            Text(
                              'ถึง: ${widget.destination}', // แสดงจุดส่ง
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.lightTextColor),
                            ),
                          ],
                        ),
                      ),
                      // ปุ่มโทรและแชท (ปรับให้เป็น OutlinedButton.icon)
                      Column(
                        children: [
                          OutlinedButton.icon(
                            onPressed: _callDriver,
                            icon: Icon(Icons.call, color: AppTheme.primaryColor),
                            label: Text('โทร', style: Theme.of(context).textButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet())?.copyWith(color: AppTheme.primaryColor)),
                            style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _chatWithDriver,
                            icon: Icon(Icons.chat, color: AppTheme.primaryColor),
                            label: Text('แชท', style: Theme.of(context).textButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet())?.copyWith(color: AppTheme.primaryColor)),
                            style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'ถึงในประมาณ: ${widget.estimatedArrivalTime}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 20),
                  // ปุ่มจำลองจบทริป (สำหรับการทดสอบ)
                  // ซึ่งในแอปจริง driver จะเป็นผู้กดจบ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _showTripCompletedDialog, // เรียก Dialog จบทริป
                      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        backgroundColor: MaterialStateProperty.all(AppTheme.accentColor),
                        minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 50)),
                      ),
                      child: Text('จำลอง: จบทริป', style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet())),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}