import 'package:flutter/material.dart';

import '../../core/data/demo_data.dart';
import '../../core/models/booking.dart';
import '../../core/models/booking_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/booking_type_tag.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/service_modals.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  Booking? get _booking {
    for (final b in [
      ...DemoData.acceptedBookings,
      ...DemoData.availableBookings,
    ]) {
      if (b.id == bookingId) return b;
    }
    return DemoData.acceptedBookings.first;
  }

  @override
  Widget build(BuildContext context) {
    final booking = _booking!;

    return Scaffold(
      appBar: AppTopBar(
        showAvatar: false,
        showBack: true,
        centerLogo: true,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          AppSpacing.sectionGap,
          AppSpacing.screenEdge,
          120,
        ),
        children: [
          _SectionCard(
            title: 'Customer Information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.surfaceContainerLow,
                      child: Text(
                        (booking.customerName ?? 'C').substring(0, 2).toUpperCase(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(booking.customerName ?? '', style: Theme.of(context).textTheme.bodyLarge),
                          Text('Customer', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              )),
                        ],
                      ),
                    ),
                    _CircleIconButton(icon: Icons.call, color: AppColors.primary, bg: AppColors.successBg),
                    const SizedBox(width: 8),
                    _CircleIconButton(icon: Icons.chat, color: AppColors.infoBlue, bg: const Color(0xFFEFF6FF)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(booking.address ?? booking.area)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GreenOutlineButton(
                  label: 'Open in Maps',
                  icon: Icons.map_outlined,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _SectionCard(
            title: 'Property Details',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _LabelValue('Type', booking.propertyType ?? '—')),
                    Expanded(child: _LabelValue('Size', booking.bhk ?? '—')),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: const Border(left: BorderSide(color: AppColors.warning, width: 4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notes', style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: 4),
                      Text(
                        booking.notes ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _SectionCard(
            title: 'Service Details',
            trailing: BookingTypeTag(type: booking.bookingType),
            child: Column(
              children: [
                _ServiceRow(
                  icon: Icons.pest_control,
                  iconColor: AppColors.danger,
                  iconBg: const Color(0xFFFEF2F2),
                  label: 'Pest Type',
                  value: booking.pestType,
                ),
                const SizedBox(height: 16),
                _ServiceRow(
                  icon: Icons.science_outlined,
                  iconColor: AppColors.infoBlue,
                  iconBg: const Color(0xFFEFF6FF),
                  label: 'Treatment',
                  value: booking.treatment ?? '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _SectionCard(
            title: 'Schedule',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(booking.dateLabel),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 20, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      booking.timeLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _SectionCard(
            title: 'Payment',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service Amount', style: Theme.of(context).textTheme.labelSmall),
                    Text(booking.amount ?? '—', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                StatusChip(
                  label: booking.paymentStatus == PaymentStatus.unpaid ? 'Unpaid' : 'Paid',
                  backgroundColor: const Color(0xFFFEF2F2),
                  foregroundColor: AppColors.danger,
                  icon: Icons.pending,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          16,
          AppSpacing.screenEdge,
          MediaQuery.paddingOf(context).bottom + 16,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, -4)),
          ],
        ),
        child: PrimaryButton(
          label: 'End Service',
          icon: Icons.check_circle,
          onPressed: () async {
            await showEndServiceModal(context);
          },
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

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
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
              ),
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

class _LabelValue extends StatelessWidget {
  const _LabelValue(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.color,
    required this.bg,
  });

  final IconData icon;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
