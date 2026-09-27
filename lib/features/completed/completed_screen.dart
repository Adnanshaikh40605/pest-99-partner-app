import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/mappers/booking_mapper.dart';
import '../../core/theme/app_spacing.dart';
import '../../providers/bookings_provider.dart';
import '../../shared/widgets/async_error_view.dart';
import '../../shared/widgets/no_internet_view.dart';
import '../../shared/widgets/profile_aware_top_bar.dart';
import '../../shared/widgets/booking_cards.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BookingsProvider>().refreshListsLight();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingsProvider>();
    final completed = bookings.completed;
    final uiBookings = completed.map(BookingMapper.fromPartner).toList();

    return Scaffold(
      appBar: const ProfileAwareTopBar(),
      body: RefreshIndicator(
        onRefresh: () => bookings.refreshListsLight(force: true),
        child: bookings.loading && completed.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : bookings.error != null && completed.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.55,
                        child: NoInternetView.isOfflineMessage(bookings.error)
                            ? NoInternetView(
                                onRetry: () =>
                                    bookings.refreshListsLight(force: true),
                              )
                            : AsyncErrorView(
                                message: bookings.error!,
                                onRetry: () =>
                                    bookings.refreshListsLight(force: true),
                              ),
                      ),
                    ],
                  )
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenEdge,
                      AppSpacing.sectionGap,
                      AppSpacing.screenEdge,
                      100,
                    ),
                    children: [
                      Text(
                        'Completed Jobs',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.elementGap),
                      if (completed.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 48),
                          child: Center(child: Text('No completed jobs yet')),
                        )
                      else
                        ...uiBookings.map(
                          (b) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.elementGap,
                            ),
                            child: CompletedBookingCard(booking: b),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}
