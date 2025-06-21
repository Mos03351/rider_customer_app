// lib/widgets/payment_method_selector.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String?> onMethodChanged;

  const PaymentMethodSelector({
    Key? key,
    required this.selectedMethod,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // เพิ่มเงาเล็กน้อย
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // ขอบมนขึ้น
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0), // ปรับ padding
        child: Column(
          children: [
            _buildPaymentOption(
              context,
              'เงินสด',
              Icons.money,
              selectedMethod == 'เงินสด',
              () => onMethodChanged('เงินสด'),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.dividerColor),
            _buildPaymentOption(
              context,
              'บัตรเครดิต/เดบิต',
              Icons.credit_card,
              selectedMethod == 'บัตรเครดิต/เดบิต',
              () => onMethodChanged('บัตรเครดิต/เดบิต'),
            ),
            const Divider(height: 1, thickness: 1, color: AppTheme.dividerColor),
            _buildPaymentOption(
              context,
              'PromptPay',
              Icons.qr_code, // ไอคอนสำหรับ PromptPay
              selectedMethod == 'PromptPay',
              () => onMethodChanged('PromptPay'),
            ),
            // TODO: เพิ่มช่องทางชำระเงินอื่นๆ
          ],
        ),
      ),
    );
  }

  // Helper Widget สำหรับแต่ละตัวเลือกการชำระเงิน
  Widget _buildPaymentOption(BuildContext context, String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : AppTheme.lightTextColor,
        size: 26, // ขนาดไอคอนใหญ่ขึ้นเล็กน้อย
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isSelected ? AppTheme.textColor : AppTheme.lightTextColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppTheme.primaryColor, size: 26) // ไอคอน Checkmark
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0), // คง padding ด้านข้าง
      dense: false, // ไม่ให้ compact มากเกินไป
    );
  }
}