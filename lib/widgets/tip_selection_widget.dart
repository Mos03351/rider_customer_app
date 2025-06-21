// lib/widgets/tip_selection_widget.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';

class TipSelectionWidget extends StatefulWidget {
  final ValueChanged<double> onTipSelected;
  final double currentTip;

  const TipSelectionWidget({
    Key? key,
    required this.onTipSelected,
    this.currentTip = 0.0,
  }) : super(key: key);

  @override
  State<TipSelectionWidget> createState() => _TipSelectionWidgetState();
}

class _TipSelectionWidgetState extends State<TipSelectionWidget> {
  final List<double> _tipOptions = [0.0, 10.0, 20.0, 30.0, 50.0];
  double _selectedTip = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedTip = widget.currentTip;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ให้ทิปไรเดอร์ (ไม่บังคับ)',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tipOptions.length,
            itemBuilder: (context, index) {
              final tipAmount = _tipOptions[index];
              final isSelected = _selectedTip == tipAmount;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(
                    tipAmount == 0.0 ? 'ไม่ให้ทิป' : '฿${tipAmount.toInt()}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isSelected ? AppTheme.invertedTextColor : AppTheme.textColor, // สีข้อความตามสถานะ
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedTip = selected ? tipAmount : 0.0;
                    });
                    widget.onTipSelected(_selectedTip);
                  },
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.cardColor, // ใช้ cardColor
                  shadowColor: Colors.transparent,
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor, // ใช้ dividerColor
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}