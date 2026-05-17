import 'package:flutter/material.dart';

import '../../core/data/demo_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/booking_cards.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.sectionGap,
          AppSpacing.screenEdge,
          100,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Completed Jobs', style: Theme.of(context).textTheme.headlineSmall),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Text(
                      'This Week',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 0),
                    ),
                    const Icon(Icons.expand_more, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.elementGap),
          ...DemoData.completedBookings.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.elementGap),
              child: CompletedBookingCard(booking: b),
            ),
          ),
        ],
      ),
    );
  }
}
