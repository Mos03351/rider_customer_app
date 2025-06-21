import 'package:flutter/material.dart';
import 'package:rider_customer_app/models/car_type.dart'; // Import Model

class CarTypeCard extends StatelessWidget {
  final CarType carType; // รับ Object CarType แทน String
  final bool isSelected;
  final VoidCallback onTap;

  const CarTypeCard({
    Key? key,
    required this.carType,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        // 💡 แก้ไขปัญหา RenderFlex overflow: เพิ่ม mainAxisSize.min
        child: Column(
          mainAxisSize: MainAxisSize.min, // ให้ Column ใช้พื้นที่เท่าที่จำเป็น
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              carType.name == 'Standard'
                  ? Icons.directions_car
                  : carType.name == 'Premium'
                      ? Icons.local_taxi
                      : Icons.car_rental,
              size: 36, // 💡 ลดขนาด Icon ลงเล็กน้อย (จาก 40 เป็น 36)
              color: isSelected ? Colors.blue : Colors.grey[700],
            ),
            Text(
              carType.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            Text(
              carType.price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            Text(
              carType.time,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}