// lib/widgets/star_rating_widget.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final int starCount;
  final double size;
  final Color color;
  final Color borderColor;

  const StarRatingWidget({
    Key? key,
    this.rating = 0.0,
    required this.onRatingChanged,
    this.starCount = 5,
    this.size = 40.0,
    this.color = AppTheme.highlightColor, // ใช้ highlightColor
    this.borderColor = AppTheme.lightTextColor, // ใช้ lightTextColor
  }) : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: borderColor,
        size: size,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        size: size,
      );
    }
    return IconButton(
      onPressed: () => onRatingChanged(index + 1.0),
      icon: icon,
      tooltip: '${index + 1} ดาว',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(starCount, (index) => buildStar(context, index)),
    );
  }
}