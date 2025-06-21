// lib/screens/review_driver_screen.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';
import 'package:rider_customer_app/screens/home_screen.dart';
import 'package:rider_customer_app/widgets/star_rating_widget.dart';
import 'package:rider_customer_app/widgets/tip_selection_widget.dart';

class ReviewDriverScreen extends StatefulWidget {
  final String driverName;
  final String tripId;

  const ReviewDriverScreen({
    Key? key,
    required this.driverName,
    required this.tripId,
  }) : super(key: key);

  @override
  State<ReviewDriverScreen> createState() => _ReviewDriverScreenState();
}

class _ReviewDriverScreenState extends State<ReviewDriverScreen> {
  double _rating = 0.0;
  final TextEditingController _commentController = TextEditingController();
  List<String> _selectedFeedbackOptions = [];
  double _selectedTipAmount = 0.0;

  final List<String> _feedbackOptions = [
    'ขับขี่ปลอดภัย',
    'สุภาพ',
    'รถสะอาด',
    'ตรงเวลา',
    'แนะนำเส้นทางดี',
    'อื่นๆ',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onRatingChanged(double rating) {
    setState(() {
      _rating = rating;
    });
  }

  void _onFeedbackOptionSelected(String option, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedFeedbackOptions.add(option);
      } else {
        _selectedFeedbackOptions.remove(option);
      }
    });
  }

  void _onTipSelected(double tip) {
    setState(() {
      _selectedTipAmount = tip;
    });
  }

  void _submitReview() {
    print('Submitting review for Trip ID: ${widget.tripId}');
    print('Driver: ${widget.driverName}');
    print('Rating: $_rating stars');
    print('Comment: ${_commentController.text}');
    print('Feedback Options: $_selectedFeedbackOptions');
    print('Tip Amount: ฿$_selectedTipAmount');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor)),
              const SizedBox(height: 20),
              Text(
                'กำลังส่งรีวิว...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ขอบคุณสำหรับรีวิวของคุณ!'),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ให้คะแนนและรีวิว',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'คุณพึงพอใจกับการเดินทางนี้แค่ไหน?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, size: 60, color: AppTheme.invertedTextColor),
            ),
            const SizedBox(height: 10),
            Text(
              widget.driverName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            StarRatingWidget(
              rating: _rating,
              onRatingChanged: _onRatingChanged,
            ),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'แสดงความคิดเห็นเพิ่มเติม (ไม่บังคับ)',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'เขียนรีวิวของคุณที่นี่...',
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'สิ่งที่ประทับใจ (เลือกได้หลายข้อ)',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _feedbackOptions.map((option) {
                  final isSelected = _selectedFeedbackOptions.contains(option);
                  return FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      _onFeedbackOptionSelected(option, selected);
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor, // ใช้ dividerColor
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: TipSelectionWidget(
                onTipSelected: _onTipSelected,
                currentTip: _selectedTipAmount,
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _rating > 0 ? _submitReview : null,
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width - 32, 50)),
              ),
              child: Text(
                'ส่งรีวิว',
                style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet()),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                'ข้าม',
                style: Theme.of(context).textButtonTheme.style?.textStyle?.resolve(MaterialState.values.toSet()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}