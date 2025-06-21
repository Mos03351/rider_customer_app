import 'package:flutter/material.dart';

class ScheduledScreen extends StatelessWidget {
  const ScheduledScreen({Key? key}) : super(key: key);

  // ข้อมูลจำลองของการจองล่วงหน้า
  final List<Map<String, String>> _scheduledRides = const [
    {
      'date': '25 มิ.ย. 2568',
      'time': '08:00 น.',
      'from': 'บ้าน',
      'to': 'โรงเรียน',
      'carType': 'Standard',
      'status': 'ยืนยันแล้ว',
    },
    {
      'date': '28 มิ.ย. 2568',
      'time': '14:30 น.',
      'from': 'ห้างสรรพสินค้า',
      'to': 'สนามบินดอนเมือง',
      'carType': 'SUV',
      'status': 'รอคนขับ',
    },
    {
      'date': '01 ก.ค. 2568',
      'time': '10:00 น.',
      'from': 'โรงแรม',
      'to': 'สถานีรถไฟฟ้าหมอชิต',
      'carType': 'Premium',
      'status': 'กำลังจะมาถึง',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('การจองล่วงหน้า'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _scheduledRides.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีการจองล่วงหน้า',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _scheduledRides.length,
              itemBuilder: (context, index) {
                final ride = _scheduledRides[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${ride['date']} - ${ride['time']}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ride['carType']!,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.my_location, color: Colors.blue, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'จาก: ${ride['from']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'ถึง: ${ride['to']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'สถานะ: ${ride['status']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: ride['status'] == 'ยืนยันแล้ว' ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('ยกเลิกการจอง')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
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
    );
  }
}