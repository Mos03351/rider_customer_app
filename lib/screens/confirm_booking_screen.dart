import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/widgets/payment_method_selector.dart';
import 'package:rider_customer_app/widgets/promo_code_input.dart';
import 'package:rider_customer_app/screens/in_trip_screen.dart'; // ถ้ามีการใช้งานจริง
import 'package:rider_customer_app/screens/rider_matching_screen.dart';
import 'package:rider_customer_app/screens/scheduled_booking_confirm_screen.dart';
import 'package:intl/intl.dart'; // **เพิ่ม import นี้**

// เพิ่ม CustomPainter สำหรับเส้นประ (เหมือนใน scheduled_screen.dart)
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

class ConfirmBookingScreen extends StatefulWidget {
  final String pickupLocation;
  final String destination;
  final bool isScheduled;
  final DateTime? scheduledTime; // สำหรับการจองล่วงหน้า

  const ConfirmBookingScreen({
    Key? key,
    required this.pickupLocation,
    required this.destination,
    this.isScheduled = false,
    this.scheduledTime, // เพิ่ม parameter สำหรับเวลาที่ถูกจองล่วงหน้า
  }) : super(key: key);

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  String _selectedPaymentMethod = 'เงินสด';
  String? _promoCode;
  double _estimatedPrice = 0.0;
  String _selectedCarType = 'Economy'; // กำหนดค่าเริ่มต้นที่ดีกว่า
  List<Map<String, dynamic>> _carTypes = [];

  @override
  void initState() {
    super.initState();
    _loadCarTypes();
  }

  void _loadCarTypes() {
    setState(() {
      _carTypes = [
        {'name': 'Economy', 'price_multiplier': 1.0, 'icon': Icons.directions_car, 'desc': 'รถยนต์นั่งทั่วไป'},
        {'name': 'Premium', 'price_multiplier': 1.8, 'icon': Icons.local_taxi, 'desc': 'รถหรูพร้อมคนขับระดับพรีเมียม'},
        {'name': 'Motorbike', 'price_multiplier': 0.7, 'icon': Icons.two_wheeler, 'desc': 'ทางเลือกที่รวดเร็วสำหรับการเดินทางคนเดียว'},
        {'name': 'Van', 'price_multiplier': 2.5, 'icon': Icons.airport_shuttle, 'desc': 'เหมาะสำหรับการเดินทางเป็นกลุ่ม'},
      ];
      if (!_carTypes.any((type) => type['name'] == _selectedCarType)) {
        _selectedCarType = _carTypes.isNotEmpty ? _carTypes.first['name'] : '';
      }
      _calculateEstimatedPrice(); // คำนวณราคาหลังจากโหลดประเภทรถ
    });
  }

  void _calculateEstimatedPrice() {
    double basePrice = 80.0; // ปรับ basePrice ให้เหมาะสม
    final selectedType = _carTypes.firstWhere(
      (type) => type['name'] == _selectedCarType,
      orElse: () => {'price_multiplier': 1.0},
    );
    setState(() {
      _estimatedPrice = basePrice * (selectedType['price_multiplier'] as double);
      // TODO: เพิ่ม logic คำนวณราคาจริง เช่น ระยะทาง, การจราจร
    });
  }

  void _onPaymentMethodChanged(String? method) {
    if (method != null) {
      setState(() {
        _selectedPaymentMethod = method;
      });
    }
  }

  void _onPromoCodeApplied(String code) {
    setState(() {
      _promoCode = code;
      // TODO: Apply promo code logic to _estimatedPrice
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ใช้โค้ดโปรโมชั่น "${_promoCode ?? ""}" แล้ว'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _confirmBooking() {
    print('ยืนยันการจอง: ${widget.isScheduled ? "จองล่วงหน้า" : "เรียกตอนนี้"}');
    print('จุดรับ: ${widget.pickupLocation}');
    print('ปลายทาง: ${widget.destination}');
    print('ประเภทรถ: $_selectedCarType');
    print('วิธีการชำระเงิน: $_selectedPaymentMethod');
    print('รหัสโปรโมชั่น: $_promoCode');
    print('ราคาประมาณ: ฿${_estimatedPrice.toStringAsFixed(2)}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor)),
              const SizedBox(height: 20),
              Text(
                widget.isScheduled ? 'กำลังยืนยันการจองล่วงหน้า...' : 'กำลังค้นหาไรเดอร์...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // ปิด Dialog

      if (mounted) {
        if (widget.isScheduled) {
          // หากเป็นการจองล่วงหน้า จะไปที่หน้ายืนยันการจองล่วงหน้าขั้นสุดท้าย
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduledBookingConfirmScreen(
                pickupLocation: widget.pickupLocation,
                destination: widget.destination,
                scheduledTime: widget.scheduledTime!, // ส่งเวลาที่ถูกเลือกมาจาก HomeScreen
                carType: _selectedCarType, // ส่งประเภทรถที่เลือก
              ),
            ),
          );
        } else {
          // หากเป็นการเรียกตอนนี้ จะไปที่หน้าค้นหาไรเดอร์
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RiderMatchingScreen(
                pickupLocation: widget.pickupLocation,
                destination: widget.destination,
                selectedCarType: _selectedCarType, // **ส่ง selectedCarType ที่นี่**
                estimatedPrice: _estimatedPrice, // ส่งราคา
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isScheduled ? 'ยืนยันการจองล่วงหน้า' : 'ยืนยันการเดินทาง',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // สรุปการเดินทาง (จุดรับและจุดส่ง)
                  Card(
                    elevation: Theme.of(context).cardTheme.elevation,
                    shape: Theme.of(context).cardTheme.shape,
                    color: Theme.of(context).cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'รายละเอียดการเดินทาง',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                          ),
                          const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.circle, color: AppTheme.successColor, size: 16),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'จาก: ${widget.pickupLocation}',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: SizedBox(
                              height: 20,
                              child: CustomPaint(
                                painter: _DashedLinePainter(color: AppTheme.lightTextColor.withOpacity(0.5)),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on, color: AppTheme.primaryColor, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'ถึง: ${widget.destination}',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                                ),
                              ),
                            ],
                          ),
                          if (widget.isScheduled && widget.scheduledTime != null) ...[
                            const Divider(height: 20, thickness: 0.8, color: AppTheme.dividerColor),
                             Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.calendar_today, color: AppTheme.accentColor, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'เวลาจอง: ${DateFormat('d MMMM yyyy, HH:mm น.').format(widget.scheduledTime!)}', // **แก้ไขตรงนี้**
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. เลือกประเภทรถ
                  Text(
                    'เลือกประเภทรถ',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _carTypes.length,
                      itemBuilder: (context, index) {
                        final carType = _carTypes[index];
                        final isSelected = _selectedCarType == carType['name'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCarType = carType['name'];
                              _calculateEstimatedPrice();
                            });
                          },
                          child: Card(
                            color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
                            elevation: isSelected ? 8 : 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: isSelected
                                  ? const BorderSide(color: AppTheme.primaryColor, width: 2)
                                  : BorderSide.none,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: SizedBox(
                              width: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      carType['icon'] as IconData,
                                      size: 40,
                                      color: isSelected ? AppTheme.invertedTextColor : AppTheme.primaryColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      carType['name'],
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: isSelected ? AppTheme.invertedTextColor : AppTheme.textColor,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '${(carType['price_multiplier'] as double) * 100}%',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: isSelected ? AppTheme.invertedTextColor.withOpacity(0.8) : AppTheme.lightTextColor,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. วิธีการชำระเงิน
                  Text(
                    'วิธีการชำระเงิน',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  PaymentMethodSelector(
                    selectedMethod: _selectedPaymentMethod,
                    onMethodChanged: _onPaymentMethodChanged,
                  ),
                  const SizedBox(height: 20),

                  // 4. รหัสโปรโมชั่น
                  Text(
                    'รหัสโปรโมชั่น',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  PromoCodeInput(
                    onApply: _onPromoCodeApplied,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // ปุ่มยืนยันด้านล่างสุดของหน้าจอ
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ราคาประมาณ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.textColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '฿${_estimatedPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmBooking,
                    style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width - 32, 50)),
                    ),
                    child: Text(
                      widget.isScheduled ? 'ยืนยันการจองล่วงหน้า' : 'ยืนยันการเรียก',
                      style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}