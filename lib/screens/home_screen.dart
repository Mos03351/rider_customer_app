import 'package:flutter/material.dart';
import 'package:rider_customer_app/widgets/app_drawer.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/screens/search_destination_screen.dart';
import 'package:rider_customer_app/screens/confirm_booking_screen.dart';
import 'package:rider_customer_app/screens/scheduled_booking_confirm_screen.dart';
import 'package:intl/intl.dart'; // เพิ่ม import สำหรับ DateFormat

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedPickupLocation;
  String? _selectedDestination;
  bool _isScheduledBooking = false;
  DateTime? _selectedScheduledTime;

  // ลบตัวแปรเกี่ยวกับประเภทรถ (_selectedCarType, _estimatedPrice, _carTypes) ออกจากหน้านี้

  @override
  void initState() {
    super.initState();
    _selectedPickupLocation = 'ตำแหน่งปัจจุบันของคุณ';
    // TODO: ดึงตำแหน่งปัจจุบันจริงจาก GPS
  }

  Future<void> _navigateToSearchScreen({required bool isPickup}) async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchDestinationScreen()),
    );

    if (selectedLocation != null) {
      setState(() {
        if (isPickup) {
          _selectedPickupLocation = selectedLocation as String;
        } else {
          _selectedDestination = selectedLocation as String;
        }
      });
    }
  }

  Future<void> _selectScheduledTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedScheduledTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: AppTheme.invertedTextColor,
              onSurface: AppTheme.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedScheduledTime != null
            ? TimeOfDay.fromDateTime(_selectedScheduledTime!)
            : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppTheme.primaryColor,
                onPrimary: AppTheme.invertedTextColor,
                onSurface: AppTheme.textColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedScheduledTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _proceedToBooking() {
    if (_selectedPickupLocation == null || _selectedDestination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('โปรดเลือกทั้งจุดรับและจุดส่ง'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_isScheduledBooking && _selectedScheduledTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('โปรดเลือกวันที่และเวลาสำหรับจองล่วงหน้า'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Determine which confirmation screen to navigate to based on _isScheduledBooking
    if (_isScheduledBooking) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduledBookingConfirmScreen(
            pickupLocation: _selectedPickupLocation!,
            destination: _selectedDestination!,
            scheduledTime: _selectedScheduledTime!,
            // carType จะถูกเลือกในหน้า ScheduledBookingConfirmScreen เอง
            // ดังนั้นไม่จำเป็นต้องส่งมาใน constructor (ต้องแก้ ScheduledBookingConfirmScreen ให้ carType เป็น optional หรือถูกเลือกในหน้านั้น)
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmBookingScreen(
            pickupLocation: _selectedPickupLocation!,
            destination: _selectedDestination!,
            isScheduled: _isScheduledBooking,
            // carType และ estimatedPrice จะถูกเลือก/คำนวณในหน้า ConfirmBookingScreen เอง
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ไปไหนดี?',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // แผนที่ Placeholder
          Container(
            color: AppTheme.backgroundColor,
            alignment: Alignment.center,
            child: Text(
              'พื้นที่แสดงแผนที่',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.lightTextColor),
            ),
          ),

          // UI เลือกจุดรับ-ส่ง และประเภทการจอง
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Card สำหรับจุดรับ
                  GestureDetector(
                    onTap: () => _navigateToSearchScreen(isPickup: true),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 18, color: AppTheme.successColor),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedPickupLocation ?? 'จุดรับของคุณ',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _selectedPickupLocation != null ? AppTheme.textColor : AppTheme.lightTextColor,
                                ),
                              ),
                            ),
                            Icon(Icons.edit, size: 20, color: AppTheme.lightTextColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Card สำหรับจุดส่ง
                  GestureDetector(
                    onTap: () => _navigateToSearchScreen(isPickup: false),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: AppTheme.primaryColor, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedDestination ?? 'จะไปที่ไหน?',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _selectedDestination != null ? AppTheme.textColor : AppTheme.lightTextColor,
                                ),
                              ),
                            ),
                            Icon(Icons.edit, size: 20, color: AppTheme.lightTextColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // แสดงเวลาที่เลือก ถ้าเป็นจองล่วงหน้าและมีเวลาที่เลือกแล้ว
                  if (_isScheduledBooking && _selectedScheduledTime != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18, color: AppTheme.accentColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'เวลาจอง: ${DateFormat('d MMMM, HH:mm').format(_selectedScheduledTime!)} น.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectScheduledTime(context),
                            child: Icon(Icons.edit, size: 20, color: AppTheme.lightTextColor),
                          ),
                        ],
                      ),
                    ),

                  // ตัวเลือก "เรียกตอนนี้" / "จองล่วงหน้า" (ปรับปรุง UI)
                  Container(
                    width: double.infinity,
                    height: 50, // กำหนดความสูง
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor, // พื้นหลังของ Container
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.dividerColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell( // ใช้ InkWell เพื่อให้กดได้และมี visual feedback
                            onTap: () {
                              setState(() {
                                _isScheduledBooking = false;
                                _selectedScheduledTime = null; // เคลียร์เวลา
                              });
                            },
                            borderRadius: BorderRadius.circular(10), // ขอบมน
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !_isScheduledBooking ? AppTheme.primaryColor : Colors.transparent, // สีเมื่อถูกเลือก
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'เรียกตอนนี้',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: !_isScheduledBooking ? AppTheme.invertedTextColor : AppTheme.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell( // ใช้ InkWell
                            onTap: () async {
                              await _selectScheduledTime(context);
                              if (_selectedScheduledTime != null) {
                                setState(() {
                                  _isScheduledBooking = true;
                                });
                              } else {
                                setState(() {
                                  _isScheduledBooking = false;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _isScheduledBooking ? AppTheme.primaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'จองล่วงหน้า',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: _isScheduledBooking ? AppTheme.invertedTextColor : AppTheme.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ปุ่มหลัก "เลือกประเภทรถ"
                  ElevatedButton(
                    onPressed: (_selectedPickupLocation != null && _selectedDestination != null && (!_isScheduledBooking || _selectedScheduledTime != null))
                        ? _proceedToBooking
                        : null,
                    style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      minimumSize: MaterialStateProperty.all(Size(screenSize.width - 32, 50)),
                    ),
                    child: Text(
                      'เลือกประเภทรถ', // เปลี่ยนกลับเป็น "เลือกประเภทรถ"
                      style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // ปุ่มลอยสำหรับ "ตำแหน่งปัจจุบัน"
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 100.0),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _selectedPickupLocation = 'ตำแหน่งปัจจุบันของคุณ';
                  });
                  // คุณอาจต้องการเรียก API เพื่ออัปเดตตำแหน่งจริงที่นี่
                },
                mini: true,
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.invertedTextColor,
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),
    );
  }
}