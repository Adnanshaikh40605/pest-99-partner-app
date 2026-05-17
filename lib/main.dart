import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/api_client.dart';
import 'providers/auth_provider.dart';
import 'providers/bookings_provider.dart';
import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/booking_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Pest99PartnerApp());
}

class Pest99PartnerApp extends StatelessWidget {
  const Pest99PartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService(api))..init()),
        ChangeNotifierProvider(create: (_) => BookingsProvider(BookingService(api))),
      ],
      child: MaterialApp(
        title: 'Pest 99 Partner',
        theme: buildAppTheme(),
        home: const _Root(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.loggedIn) return const LoginScreen();
    return const HomeShell();
  }
}
