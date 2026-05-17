import 'package:flutter/material.dart';

import '../../core/data/demo_data.dart';
import '../../core/models/booking_type.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/booking_cards.dart';
import '../../shared/widgets/segmented_tabs.dart';
import '../../shared/widgets/service_modals.dart';

class AcceptedScreen extends StatefulWidget {
  const AcceptedScreen({super.key});

  @override
  State<AcceptedScreen> createState() => _AcceptedScreenState();
}

class _AcceptedScreenState extends State<AcceptedScreen> {
  int _tabIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          16,
          AppSpacing.screenEdge,
          100,
        ),
        children: [
          SegmentedTabs(
            labels: const ['New', 'Accepted'],
            selectedIndex: _tabIndex,
            onChanged: (i) => setState(() => _tabIndex = i),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          ...DemoData.acceptedBookings.map(
            (booking) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: AcceptedBookingCard(
                booking: booking,
                onPrimaryAction: () async {
                  if (booking.acceptedState == AcceptedJobState.inService) {
                    final mode = await showEndServiceModal(context);
                    if (mode != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Job completed — ${mode.name}')),
                      );
                    }
                  } else {
                    await showSelfieVerificationModal(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
