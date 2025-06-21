// lib/widgets/trip_summary_card.dart
import 'package:flutter/material.dart';
import 'package:rider_customer_app/config/app_theme.dart';

class TripSummaryCard extends StatelessWidget {
  final String pickupLocation;
  final String destination;
  final double estimatedPrice;

  const TripSummaryCard({
    Key? key,
    required this.pickupLocation,
    required this.destination,
    required this.estimatedPrice,
  }) : super(key: key);

  // ลบ _buildDivider ออกไป เพราะจะใช้ Divider() โดยตรงใน build method

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สรุปการเดินทาง',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: 20, thickness: 1, color: AppTheme.dividerColor), // แก้ไขตรงนี้
            _buildLocationRow(context, Icons.circle, 'จุดรับ', pickupLocation, AppTheme.successColor),
            const SizedBox(height: 10),
            _buildLocationRow(context, Icons.location_on, 'ปลายทาง', destination, AppTheme.primaryColor),
            const Divider(height: 20, thickness: 1, color: AppTheme.dividerColor), // แก้ไขตรงนี้
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ราคาโดยประมาณ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                ),
                Text(
                  '฿${estimatedPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context, IconData icon, String label, String location, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.lightTextColor),
              ),
              Text(
                location,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}