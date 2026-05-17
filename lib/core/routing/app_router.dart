import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/accepted/accepted_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/booking_detail/booking_detail_screen.dart';
import '../../features/bookings/bookings_screen.dart';
import '../../features/completed/completed_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/referral/refer_client_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../shared/widgets/app_bottom_nav.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fadePage(state, const SplashScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _slidePage(state, const LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _slidePage(state, const RegisterScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                pageBuilder: (context, state) => const NoTransitionPage(child: BookingsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/accepted',
                pageBuilder: (context, state) => const NoTransitionPage(child: AcceptedScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/completed',
                pageBuilder: (context, state) => const NoTransitionPage(child: CompletedScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/booking/:id',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _slidePage(state, BookingDetailScreen(bookingId: id));
        },
      ),
      GoRoute(
        path: '/refer-client',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _slidePage(state, const ReferClientScreen()),
      ),
      GoRoute(
        path: '/referral-success',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _slidePage(state, const ReferralSuccessScreen()),
      ),
    ],
  );
}

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.04, 0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
