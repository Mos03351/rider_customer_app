import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // ข้อมูลจำลองของประวัติการเดินทาง
  final List<Map<String, String>> _rideHistory = const [
    {
      'date': '20 พ.ค. 2568',
      'time': '10:30 น.',
      'from': 'บ้าน',
      'to': 'สำนักงานใหญ่',
      'price': '฿150.00',
      'status': 'สำเร็จ',
    },
    {
      'date': '18 พ.ค. 2568',
      'time': '18:45 น.',
      'from': 'สยามพารากอน',
      'to': 'สถานีรถไฟฟ้าอโศก',
      'price': '฿90.00',
      'status': 'สำเร็จ',
    },
    {
      'date': '15 พ.ค. 2568',
      'time': '09:00 น.',
      'from': 'สนามบินสุวรรณภูมิ',
      'to': 'โรงแรมสุขุมวิท',
      'price': '฿400.00',
      'status': 'สำเร็จ',
    },
    {
      'date': '10 พ.ค. 2568',
      'time': '14:15 น.',
      'from': 'ห้างสรรพสินค้า',
      'to': 'คอนโด',
      'price': '฿120.00',
      'status': 'สำเร็จ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติการเดินทาง'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _rideHistory.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีประวัติการเดินทาง',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _rideHistory.length,
              itemBuilder: (context, index) {
                final history = _rideHistory[index];
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
                              '${history['date']} - ${history['time']}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              history['price']!,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
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
                                'จาก: ${history['from']}',
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
                                'ถึง: ${history['to']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'สถานะ: ${history['status']}',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: history['status'] == 'สำเร็จ' ? Colors.green : Colors.orange,
                            ),
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