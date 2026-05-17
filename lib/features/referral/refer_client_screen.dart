import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';

class ReferClientScreen extends StatelessWidget {
  const ReferClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer Client'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenEdge),
        children: [
          Text(
            'Refer a new client',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Share client details to earn referral rewards.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          const AppTextField(label: 'Client Name', hint: 'Enter client full name'),
          const SizedBox(height: AppSpacing.elementGap),
          const AppTextField(
            label: 'Mobile Number',
            hint: 'Enter client mobile number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.elementGap),
          const AppTextField(label: 'Area / Location', hint: 'Enter service area'),
          const SizedBox(height: AppSpacing.sectionGap),
          PrimaryButton(
            label: 'Submit Referral',
            onPressed: () => context.push('/referral-success'),
          ),
        ],
      ),
    );
  }
}

class ReferralSuccessScreen extends StatelessWidget {
  const ReferralSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text('Referral Submitted!', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Our team will contact your referral shortly.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Back to Profile',
                onPressed: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
