import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'pest_logo.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.showAvatar = true,
    this.showBack = false,
    this.onBack,
    this.centerLogo = true,
    this.title,
  });

  final bool showAvatar;
  final bool showBack;
  final VoidCallback? onBack;
  final bool centerLogo;
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenEdge,
          vertical: 12,
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              if (showBack)
                IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48),
                  ),
                )
              else if (showAvatar)
                CircleAvatar(
                  radius: 20,
                  backgroundImage: const NetworkImage(AppAssets.technicianAvatar),
                  backgroundColor: AppColors.surfaceContainerHigh,
                )
              else
                const SizedBox(width: 40),
              Expanded(
                child: centerLogo
                    ? const Center(child: PestLogo(height: 32))
                    : Text(
                        title ?? '',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: AppColors.onSurfaceVariant),
                style: IconButton.styleFrom(minimumSize: const Size(40, 40)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
