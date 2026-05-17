import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/pest_logo.dart';
import '../../shared/widgets/primary_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const PestLogo(height: 64),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenEdge,
                  24,
                  AppSpacing.screenEdge,
                  120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Account', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Join as a service partner to manage bookings.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    const AppTextField(label: 'Full Name', hint: 'Enter your full name'),
                    const SizedBox(height: AppSpacing.elementGap),
                    const AppTextField(
                      label: 'Mobile Number',
                      hint: 'Enter your mobile number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.elementGap),
                    const AppTextField(
                      label: 'Password',
                      hint: 'Create a strong password',
                      obscureText: true,
                    ),
                    const SizedBox(height: AppSpacing.elementGap),
                    AppDropdownField<String>(
                      label: 'User Type',
                      hint: 'Select your role',
                      items: const [
                        DropdownMenuItem(value: 'technician', child: Text('Technician')),
                        DropdownMenuItem(value: 'admin', child: Text('Technician Admin')),
                      ],
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenEdge,
          16,
          AppSpacing.screenEdge,
          MediaQuery.paddingOf(context).bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
          border: const Border(top: BorderSide(color: Color(0x80E4E7EC))),
        ),
        child: PrimaryButton(
          label: 'Create Account',
          onPressed: () => context.go('/login'),
        ),
      ),
    );
  }
}
