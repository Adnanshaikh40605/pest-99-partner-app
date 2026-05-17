import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/mappers/booking_mapper.dart';
import '../../core/models/booking_type.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/booking.dart' as api;
import '../../providers/bookings_provider.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/booking_cards.dart';
import '../../shared/widgets/service_modals.dart';

class AcceptedScreen extends StatefulWidget {
  const AcceptedScreen({super.key});

  @override
  State<AcceptedScreen> createState() => _AcceptedScreenState();
}

class _AcceptedScreenState extends State<AcceptedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingsProvider>().refreshAll();
    });
  }

  Future<void> _primaryAction(BuildContext context, api.PartnerBooking raw) async {
    final bookings = context.read<BookingsProvider>();

    if (raw.canCompleteJob) {
      final mode = await showEndServiceModal(context);
      if (mode == null || !context.mounted) return;
      final payment = mode == PaymentMode.online ? 'Online' : 'Cash';
      final ok = await bookings.completeJob(raw.id, payment);
      if (!context.mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service completed')),
        );
        context.go('/completed');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(bookings.error ?? 'Could not complete')),
        );
      }
      return;
    }

    if (raw.canStartJob) {
      final path = await showSelfieVerificationModal(context);
      if (path == null || !context.mounted) return;
      final ok = await bookings.startJob(raw.id, path);
      if (!context.mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job started — selfie uploaded')),
        );
        await bookings.refreshAll();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(bookings.error ?? 'Could not start job')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingsProvider>();

    return Scaffold(
      appBar: const AppTopBar(),
      body: RefreshIndicator(
        onRefresh: bookings.refreshAll,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            16,
            AppSpacing.screenEdge,
            100,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Accepted Jobs', style: Theme.of(context).textTheme.headlineSmall),
                Text('${bookings.accepted.length} active'),
              ],
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            if (bookings.accepted.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(child: Text('No accepted jobs yet')),
              )
            else
              ...bookings.accepted.map((raw) {
                final ui = BookingMapper.fromPartner(raw);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: AcceptedBookingCard(
                    booking: ui,
                    onViewDetails: () => context.push('/booking/${raw.id}'),
                    onPrimaryAction: () => _primaryAction(context, raw),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
