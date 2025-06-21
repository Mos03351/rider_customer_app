// lib/widgets/promo_code_input.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';

class PromoCodeInput extends StatefulWidget {
  final ValueChanged<String> onApply;

  const PromoCodeInput({Key? key, required this.onApply}) : super(key: key);

  @override
  State<PromoCodeInput> createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends State<PromoCodeInput> {
  final TextEditingController _promoCodeController = TextEditingController();
  bool _isApplied = false; // สถานะว่าใช้โค้ดแล้วหรือยัง

  @override
  void dispose() {
    _promoCodeController.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    if (_promoCodeController.text.isNotEmpty) {
      widget.onApply(_promoCodeController.text);
      setState(() {
        _isApplied = true;
      });
      FocusScope.of(context).unfocus(); // ซ่อนคีย์บอร์ด
      // คุณสามารถเพิ่ม logic สำหรับแสดง Toast/SnackBar "ใช้โค้ดแล้ว" ได้ที่นี่
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _promoCodeController,
                enabled: !_isApplied, // ปิดการใช้งาน TextField เมื่อใช้โค้ดแล้ว
                decoration: InputDecoration(
                  hintText: _isApplied ? 'โค้ดถูกใช้แล้ว' : 'ใส่รหัสโปรโมชั่น',
                  prefixIcon: Icon(
                    Icons.local_offer, // ไอคอนข้อเสนอ
                    color: _isApplied ? AppTheme.lightTextColor : AppTheme.primaryColor,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _isApplied ? AppTheme.lightTextColor : AppTheme.textColor,
                      fontWeight: _isApplied ? FontWeight.w500 : FontWeight.normal,
                    ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _isApplied ? null : _applyPromoCode, // ปุ่ม disabled เมื่อ _isApplied เป็น true
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                minimumSize: MaterialStateProperty.all(const Size(80, 40)),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12)),
                backgroundColor: MaterialStateProperty.all(_isApplied ? AppTheme.lightTextColor : AppTheme.primaryColor), // สีปุ่มเมื่อใช้แล้ว/ยังไม่ใช้
              ),
              child: Text(
                _isApplied ? 'ใช้แล้ว' : 'ใช้',
                style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}