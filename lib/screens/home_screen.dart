import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';

// Import Widgets ที่แยกออกมา
import 'package:rider_customer_app/widgets/car_type_card.dart';
import 'package:rider_customer_app/widgets/location_input.dart';
import 'package:rider_customer_app/widgets/date_time_selection.dart';
import 'package:rider_customer_app/widgets/toggle_tab.dart';
import 'package:rider_customer_app/widgets/app_drawer.dart'; // <<< Import AppDrawer ที่นี่

// Import Utilities (Logic) ที่แยกออกมา
import 'package:rider_customer_app/utils/location_permission_handler.dart';

// Import Models
import 'package:rider_customer_app/models/car_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController mapController = MapController();
  final LatLng _center = const LatLng(13.736717, 100.523186); // ตำแหน่งเริ่มต้น (กรุงเทพฯ)
  LatLng? _currentLocation; // ตำแหน่งปัจจุบันของผู้ใช้
  LatLng? _destinationLocation; // ตำแหน่งปลายทาง

  String _pickupAddress = 'กำลังค้นหาตำแหน่งปัจจุบัน...';
  String _destinationAddress = 'ป้อนจุดหมายปลายทางของคุณ';

  bool _isScheduledRide = false; // สถานะเรียกรถด่วน / จองล่วงหน้า
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String _selectedCarType = 'Standard'; // ประเภทรถที่เลือก

  // ใช้ Model CarType แทน Map<String, String>
  final List<CarType> _carTypes = [
    CarType(name: 'Standard', price: '฿90', time: '2-5 min'),
    CarType(name: 'Premium', price: '฿120', time: '3-6 min'),
    CarType(name: 'SUV', price: '฿150', time: '5-8 min'),
  ];

  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันดึงตำแหน่งปัจจุบันจาก LocationPermissionHandler
    LocationPermissionHandler.determinePosition(
      context: context, // ส่ง context เพื่อแสดง SnackBar
      onLocationDetermined: (position) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          mapController.move(_currentLocation!, 15.0);
          _pickupAddress = 'ตำแหน่งปัจจุบันของคุณ (lat: ${_currentLocation!.latitude.toStringAsFixed(2)}, lon: ${_currentLocation!.longitude.toStringAsFixed(2)})';
        });
      },
      onError: (message) {
        // Handle error, e.g., show a dialog or SnackBar
        if (mounted) { // ตรวจสอบว่า Widget ยังอยู่บน tree ก่อนแสดง SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
    );
  }

  // ฟังก์ชันแสดง Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)), // จองล่วงหน้าได้ 30 วัน
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // ฟังก์ชันแสดง Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // ทำให้ body อยู่ด้านหลัง AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // ทำให้ AppBar โปร่งใส
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            // 💡 แก้ไขปัญหาเมนูไม่ขึ้น: ใช้ Builder เพื่อให้ได้ BuildContext ที่ถูกต้องสำหรับ Scaffold.of()
            child: Builder(
              builder: (BuildContext innerContext) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(innerContext).openDrawer(); // ใช้ innerContext
                  },
                );
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.black),
                onPressed: () {
                  // ไปหน้าโปรไฟล์ (ในแอปจริงอาจจะ push ไปหน้าใหม่)
                  Navigator.pushNamed(context, '/profile'); // ใช้ named route
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // แผนที่ (FlutterMap)
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? _center, // ใช้ตำแหน่งปัจจุบันหรือตำแหน่งเริ่มต้น
              initialZoom: 15.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all, // ให้สามารถเลื่อนและซูมแผนที่ได้
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter_ride_app', // ระบุ package name
              ),
              // Marker สำหรับตำแหน่งปัจจุบัน
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                    ),
                  ],
                ),
              // Marker สำหรับตำแหน่งปลายทาง
              if (_destinationLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _destinationLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  ],
                ),
            ],
          ),

          // ปุ่มสำหรับกลับไปตำแหน่งปัจจุบัน
          if (_currentLocation != null)
            Positioned(
              bottom: 300, // ปรับตำแหน่งให้ไม่ชนกับ bottom sheet
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  mapController.move(_currentLocation!, 15.0); // เมื่อกดจะย้ายแผนที่ไปที่ตำแหน่งปัจจุบัน
                },
                mini: true,
                backgroundColor: Colors.white,
                child: const Icon(Icons.my_location, color: Colors.blue), // ไอคอน My Location
              ),
            ),

          // Bottom Sheet สำหรับการป้อนข้อมูลและเลือกประเภทรถ
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ให้ Column ใช้ขนาดเท่าที่จำเป็น
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // สลับระหว่างเรียกรถด่วน / จองล่วงหน้า
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ToggleTab( // ใช้ Widget ที่แยกออกมา
                            text: 'เรียกด่วน',
                            isSelected: !_isScheduledRide,
                            onTap: () {
                              setState(() {
                                _isScheduledRide = false;
                              });
                            },
                          ),
                          ToggleTab( // ใช้ Widget ที่แยกออกมา
                            text: 'จองล่วงหน้า',
                            isSelected: _isScheduledRide,
                            onTap: () {
                              setState(() {
                                _isScheduledRide = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ช่องป้อนจุดรับ
                  LocationInput( // ใช้ Widget ที่แยกออกมา
                    icon: Icons.my_location,
                    label: 'จุดรับ',
                    address: _pickupAddress,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('คุณสามารถย้ายแผนที่เพื่อเลือกจุดรับได้')),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // ช่องป้อนจุดส่ง
                  LocationInput( // ใช้ Widget ที่แยกออกมา
                    icon: Icons.location_on,
                    label: 'ปลายทาง',
                    address: _destinationAddress,
                    onTap: () {
                      // **ในแอปจริง คุณจะนำทางผู้ใช้ไปยังหน้าค้นหาหรือเลือกบนแผนที่**
                      // สำหรับตอนนี้ เราจะสมมุติว่ามีการเลือกปลายทาง
                      setState(() {
                        _destinationAddress = 'ศูนย์การค้าสยามพารากอน';
                        _destinationLocation = const LatLng(13.746654, 100.534891); // ตัวอย่าง LatLng สยามพารากอน
                      });

                      // ขยับแผนที่ให้เห็นทั้งจุดรับและจุดส่ง
                      if (_currentLocation != null && _destinationLocation != null) {
                        final bounds = LatLngBounds.fromPoints([_currentLocation!, _destinationLocation!]);
                        mapController.fitCamera(
                          CameraFit.bounds(
                            bounds: bounds,
                            padding: const EdgeInsets.all(100.0), // Padding รอบแผนที่
                          ),
                        );
                      } else if (_destinationLocation != null) {
                        mapController.move(_destinationLocation!, 15.0);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // สำหรับจองล่วงหน้า: เลือกวันเวลา
                  if (_isScheduledRide)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DateTimeSelection( // ใช้ Widget ที่แยกออกมา
                                icon: Icons.calendar_today,
                                label: 'วันที่',
                                value: DateFormat('dd/MM/yyyy').format(_selectedDate),
                                onTap: () => _selectDate(context),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DateTimeSelection( // ใช้ Widget ที่แยกออกมา
                                icon: Icons.access_time,
                                label: 'เวลา',
                                value: _selectedTime.format(context),
                                onTap: () => _selectTime(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                  // ส่วนเลือกประเภทรถ
                  const Text(
                    'เลือกประเภทรถ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100, // กำหนดความสูงเพื่อให้ Card เลื่อนแนวนอนได้
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _carTypes.length,
                      itemBuilder: (context, index) {
                        final carType = _carTypes[index];
                        return CarTypeCard( // ใช้ Widget ที่แยกออกมา
                          carType: carType, // ส่ง Object CarType ไป
                          isSelected: _selectedCarType == carType.name,
                          onTap: () {
                            setState(() {
                              _selectedCarType = carType.name;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ปุ่มยืนยัน
                  SizedBox(
                    width: double.infinity, // ให้ปุ่มเต็มความกว้าง
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentLocation == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('กรุณารอสักครู่เพื่อดึงตำแหน่งปัจจุบัน')),
                          );
                          return;
                        }
                        if (_destinationLocation == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('กรุณาเลือกจุดหมายปลายทาง')),
                          );
                          return;
                        }

                        // แสดงข้อความยืนยัน (หรือส่งข้อมูลไป Backend)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isScheduledRide
                                  ? 'ยืนยันการจองรถ ${_selectedCarType} ไป ${_destinationAddress} วันที่ ${DateFormat('dd/MM/yyyy').format(_selectedDate)} เวลา ${_selectedTime.format(context)}'
                                  : 'กำลังเรียกรถ ${_selectedCarType} ไป ${_destinationAddress}',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blue, // สีปุ่ม
                      ),
                      child: Text(
                        _isScheduledRide ? 'ยืนยันการจอง' : 'เรียกรถตอนนี้',
                        style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // 💡 ใช้ AppDrawer ที่แยกออกมา
      drawer: const AppDrawer(),
    );
  }
}