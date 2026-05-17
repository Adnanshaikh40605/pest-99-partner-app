import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/api_client.dart';
import 'core/routing/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/bookings_provider.dart';
import 'services/auth_service.dart';
import 'services/booking_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final api = ApiClient();
  final auth = AuthProvider(AuthService(api))..init();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: api),
        ChangeNotifierProvider<AuthProvider>.value(value: auth),
        ChangeNotifierProvider(create: (_) => BookingsProvider(BookingService(api))),
      ],
      child: Pest99PartnerApp(router: AppRouter(auth).router),
    ),
  );
}
