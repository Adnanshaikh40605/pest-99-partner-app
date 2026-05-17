import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api_client.dart';
import '../../core/models/booking_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/booking.dart' as api;
import '../../providers/bookings_provider.dart';
import '../../services/booking_service.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/booking_type_tag.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/service_modals.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final int bookingId;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  api.PartnerBooking? _booking;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final apiClient = context.read<ApiClient>();
      _booking = await BookingService(apiClient).getDetail(widget.bookingId);
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _startJob() async {
    final path = await showSelfieVerificationModal(context);
    if (path == null || !mounted) return;
    final ok = await context.read<BookingsProvider>().startJob(widget.bookingId, path);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job started')),
      );
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<BookingsProvider>().error ?? 'Could not start')),
      );
    }
  }

  Future<void> _endService() async {
    final mode = await showEndServiceModal(context);
    if (mode == null || !mounted) return;
    final payment = mode == PaymentMode.online ? 'Online' : 'Cash';
    final ok = await context.read<BookingsProvider>().completeJob(widget.bookingId, payment);
    if (!mounted) return;
    if (ok) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service completed')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<BookingsProvider>().error ?? 'Could not complete')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = _booking;

    return Scaffold(
      appBar: AppTopBar(
        showAvatar: false,
        showBack: true,
        centerLogo: true,
        onBack: () => context.pop(),
      ),
      body: _loading && b == null
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : b == null
                  ? const Center(child: Text('Booking not found'))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenEdge,
                        AppSpacing.sectionGap,
                        AppSpacing.screenEdge,
                        120,
                      ),
                      children: [
                        _SectionCard(
                          title: 'Customer',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.clientName ?? '—', style: Theme.of(context).textTheme.bodyLarge),
                              if (b.canViewClientPhone && b.clientMobile != null) ...[
                                const SizedBox(height: 8),
                                Text(b.clientMobile!),
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: () => launchUrl(Uri.parse('tel:${b.clientMobile}')),
                                  icon: const Icon(Icons.call),
                                  label: const Text('Call customer'),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Text(b.locationDisplay ?? b.clientAddress ?? '—'),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),
                        _SectionCard(
                          title: 'Service',
                          trailing: BookingTypeTag(type: BookingType.booking),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(b.serviceType, style: Theme.of(context).textTheme.titleMedium),
                              if (b.serviceCategory != null) Text(b.serviceCategory!),
                              const SizedBox(height: 8),
                              Text('Amount: ${b.priceDisplay ?? b.price ?? '—'}'),
                              if (b.notes != null && b.notes!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(b.notes!, style: const TextStyle(fontStyle: FontStyle.italic)),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),
                        _SectionCard(
                          title: 'Schedule',
                          child: Text('${b.scheduleDatetime ?? ''} · ${b.timeSlot ?? ''}'),
                        ),
                      ],
                    ),
      bottomNavigationBar: b == null || (!b.canStartJob && !b.canCompleteJob)
          ? null
          : Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenEdge,
                16,
                AppSpacing.screenEdge,
                MediaQuery.paddingOf(context).bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: b.canStartJob
                  ? PrimaryButton(
                      label: 'Start job (selfie)',
                      icon: Icons.camera_alt,
                      onPressed: _startJob,
                    )
                  : PrimaryButton(
                      label: 'End Service',
                      icon: Icons.check_circle,
                      onPressed: _endService,
                    ),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineSmall)),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppSpacing.elementGap),
          child,
        ],
      ),
    );
  }
}
