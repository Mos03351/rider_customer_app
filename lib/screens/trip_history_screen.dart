import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:intl/intl.dart'; // สำหรับการฟอร์แมตวันที่และเวลา

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _pastTrips = [];

  @override
  void initState() {
    super.initState();
    _fetchPastTrips();
  }

  Future<void> _fetchPastTrips() async {
    setState(() {
      _isLoading = true;
    });
    // TODO: ดึงข้อมูลประวัติการเดินทางจาก Backend จริงๆ
    // จำลองข้อมูลสำหรับการแสดงผล
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _pastTrips = [
        {
          'id': 'TRIP-001-XYZ',
          'dateTime': DateTime(2025, 6, 15, 10, 30),
          'pickup': 'บ้าน (123/4 หมู่ 5 สันป่าม่วง)',
          'destination': 'โรงเรียนลำพูน',
          'driverName': 'สมชาย ใจดี',
          'carType': 'Economy',
          'price': 95.0,
          'status': 'Completed',
        },
        {
          'id': 'TRIP-002-ABC',
          'dateTime': DateTime(2025, 6, 10, 14, 0),
          'pickup': 'ตลาดหนองดอก',
          'destination': 'สถานีรถไฟลำพูน',
          'driverName': 'สุดา ยิ้มหวาน',
          'carType': 'Motorbike',
          'price': 40.0,
          'status': 'Completed',
        },
        {
          'id': 'TRIP-003-DEF',
          'dateTime': DateTime(2025, 5, 28, 18, 45),
          'pickup': 'บิ๊กซี ลำพูน',
          'destination': 'บ้านเพื่อน (หมู่บ้านจัดสรร)',
          'driverName': 'ไพศาล รักลูกค้า',
          'carType': 'Premium',
          'price': 150.0,
          'status': 'Completed',
        },
        {
          'id': 'TRIP-004-GHI',
          'dateTime': DateTime(2025, 5, 20, 9, 0),
          'pickup': 'โรงแรมลำพูน',
          'destination': 'สนามบินเชียงใหม่',
          'driverName': 'วินัย ขับไว',
          'carType': 'Van',
          'price': 350.0,
          'status': 'Cancelled', // ตัวอย่างการเดินทางที่ถูกยกเลิก
        },
      ];
      _isLoading = false;
    });
  }

  void _viewTripDetails(Map<String, dynamic> trip) {
    // TODO: อาจจะนำทางไปยังหน้าจอรายละเอียดการเดินทางแต่ละครั้งที่ละเอียดกว่านี้
    // เช่น TripDetailsScreen(tripData: trip)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ดูรายละเอียดการเดินทาง ${trip['id']}'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
    print('Trip Details: ${trip['id']}');
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
          ? Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor)),
            )
          : _pastTrips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off,
                        size: 80,
                        color: AppTheme.lightTextColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ยังไม่มีประวัติการเดินทาง',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.lightTextColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'เริ่มต้นการเดินทางครั้งแรกของคุณได้เลย!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightTextColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _pastTrips.length,
                  itemBuilder: (context, index) {
                    final trip = _pastTrips[index];
                    final DateTime tripDateTime = trip['dateTime'];
                    final String formattedDate = DateFormat('d MMMM yyyy').format(tripDateTime); // 15 มิถุนายน 2025
                    final String formattedTime = DateFormat('HH:mm น.').format(tripDateTime); // 10:30 น.

                    // กำหนดสีตามสถานะการเดินทาง
                    Color statusColor = AppTheme.successColor;
                    if (trip['status'] == 'Cancelled') {
                      statusColor = AppTheme.errorColor;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      elevation: Theme.of(context).cardTheme.elevation,
                      shape: Theme.of(context).cardTheme.shape,
                      child: InkWell( // ทำให้ Card กดได้
                        onTap: () => _viewTripDetails(trip),
                        borderRadius: BorderRadius.circular(15), // ต้องตรงกับ Card shape
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$formattedDate - $formattedTime',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      trip['status'],
                                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                              _buildLocationRow(
                                context,
                                icon: Icons.circle,
                                label: 'จาก:',
                                location: trip['pickup'],
                                iconColor: AppTheme.successColor,
                              ),
                              _buildDashedLine(context), // เส้นประ
                              _buildLocationRow(
                                context,
                                icon: Icons.location_on,
                                label: 'ถึง:',
                                location: trip['destination'],
                                iconColor: AppTheme.primaryColor,
                              ),
                              const SizedBox(height: 10),
                              _buildInfoRow(
                                context,
                                icon: Icons.person,
                                label: 'คนขับ:',
                                value: trip['driverName'],
                                iconColor: AppTheme.accentColor,
                              ),
                              _buildInfoRow(
                                context,
                                icon: Icons.directions_car,
                                label: 'ประเภทรถ:',
                                value: trip['carType'],
                                iconColor: AppTheme.lightTextColor,
                              ),
                              const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  '฿${trip['price'].toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // Helper Widget สำหรับแสดงจุดรับ/ส่ง
  Widget _buildLocationRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String location,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.lightTextColor),
                ),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget สำหรับแสดงข้อมูลทั่วไป (คนขับ, ประเภทรถ)
  Widget _buildInfoRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 12),
          Text(
            '$label ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.lightTextColor),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // CustomPainter สำหรับเส้นประ (คัดลอกมาจากไฟล์อื่นๆ)
  Widget _buildDashedLine(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0, top: 2.0, bottom: 2.0),
      child: SizedBox(
        height: 15, // ปรับความสูงให้สั้นลงเล็กน้อย
        child: CustomPaint(
          painter: _DashedLinePainter(color: AppTheme.dividerColor),
        ),
      ),
    );
  }
}

// CustomPainter สำหรับเส้นประ (คัดลอกมาจาก scheduled_screen.dart/confirm_booking_screen.dart)
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    this.strokeWidth = 1.0, // ปรับให้บางลงเล็กน้อย
    this.dashWidth = 4.0,
    this.dashSpace = 3.0,
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