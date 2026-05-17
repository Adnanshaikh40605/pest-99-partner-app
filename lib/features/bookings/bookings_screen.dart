import 'package:flutter/material.dart';

import '../../core/data/demo_data.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/booking_cards.dart';
import '../../shared/widgets/segmented_tabs.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bookings = _tabIndex == 0 ? DemoData.availableBookings : DemoData.acceptedBookings;

    return Scaffold(
      appBar: const AppTopBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StickySegmentedHeader(
            labels: const ['Available', 'Accepted'],
            selectedIndex: _tabIndex,
            onChanged: (i) => setState(() => _tabIndex = i),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                AppSpacing.sectionGap,
                AppSpacing.screenEdge,
                100,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _tabIndex == 0 ? 'New Bookings' : 'Accepted Jobs',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      '${bookings.length} requests',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.elementGap),
                ...bookings.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.elementGap),
                    child: _tabIndex == 0
                        ? AvailableBookingCard(
                            booking: b,
                            onAccept: () {},
                            onReject: () {},
                          )
                        : AcceptedBookingCard(booking: b),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
