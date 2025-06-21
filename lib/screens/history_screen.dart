// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _tripHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchTripHistory();
  }

  Future<void> _fetchTripHistory() async {
    setState(() {
      _isLoading = true;
    });
    // TODO: ดึงข้อมูลประวัติการเดินทางจาก Backend
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _tripHistory = [
        {
          'date': '2024-06-15',
          'pickup': 'เซ็นทรัลพลาซา ลำปาง',
          'destination': 'สถานีขนส่งผู้โดยสารจังหวัดลำปาง',
          'price': 85.0,
          'status': 'Completed',
          'driverName': 'คุณสมบัติ ใจดี',
        },
        {
          'date': '2024-06-10',
          'pickup': 'บ้าน',
          'destination': 'มหาวิทยาลัยธรรมศาสตร์ ศูนย์ลำปาง',
          'price': 150.0,
          'status': 'Completed',
          'driverName': 'คุณสุดา พัฒนา',
        },
        {
          'date': '2024-06-05',
          'pickup': 'ที่ทำงาน',
          'destination': 'ตลาดอัศวิน',
          'price': 60.0,
          'status': 'Cancelled',
          'driverName': 'คุณสมศรี มาไว',
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประวัติการเดินทาง',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor)))
          : _tripHistory.isEmpty
              ? Center(
                  child: Text(
                    'ไม่มีประวัติการเดินทาง',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.lightTextColor),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _tripHistory.length,
                  itemBuilder: (context, index) {
                    final trip = _tripHistory[index];
                    Color statusColor;
                    IconData statusIcon;

                    switch (trip['status']) {
                      case 'Completed':
                        statusColor = AppTheme.successColor;
                        statusIcon = Icons.check_circle;
                        break;
                      case 'Cancelled':
                        statusColor = AppTheme.errorColor;
                        statusIcon = Icons.cancel;
                        break;
                      default:
                        statusColor = AppTheme.lightTextColor;
                        statusIcon = Icons.info_outline;
                    }

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
                                Text(
                                  'วันที่: ${trip['date']}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(statusIcon, color: statusColor, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      trip['status'],
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // แก้ไข: ใช้ Divider() โดยตรงแล้วปรับ height/thickness
                            const Divider(height: 10, thickness: 0.5, color: AppTheme.dividerColor),
                            Row(
                              children: [
                                Icon(Icons.circle, color: AppTheme.successColor, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'จาก: ${trip['pickup']}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: AppTheme.primaryColor, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'ถึง: ${trip['destination']}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                            // แก้ไข: ใช้ Divider() โดยตรงแล้วปรับ height/thickness
                            const Divider(height: 12, thickness: 0.5, color: AppTheme.dividerColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'คนขับ: ${trip['driverName']}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightTextColor),
                                ),
                                Text(
                                  '฿${trip['price'].toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}