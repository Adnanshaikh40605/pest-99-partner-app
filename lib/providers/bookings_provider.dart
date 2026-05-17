import 'package:flutter/foundation.dart';

import '../core/api_exception.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingsProvider extends ChangeNotifier {
  BookingsProvider(this._service);

  final BookingService _service;

  BookingCounts counts = BookingCounts(available: 0, accepted: 0, completed: 0);
  List<PartnerBooking> available = [];
  List<PartnerBooking> accepted = [];
  List<PartnerBooking> completed = [];

  bool loading = false;
  String? error;

  Future<void> refreshAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.getCounts(),
        _service.getAvailable(),
        _service.getAccepted(),
        _service.getCompleted(),
      ]);
      counts = results[0] as BookingCounts;
      available = results[1] as List<PartnerBooking>;
      accepted = results[2] as List<PartnerBooking>;
      completed = results[3] as List<PartnerBooking>;
    } on ApiException catch (e) {
      error = e.message;
    } catch (_) {
      error = 'Could not load bookings.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> accept(int id) async {
    try {
      await _service.accept(id);
      await refreshAll();
      return true;
    } on ApiException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> reject(int id) async {
    try {
      await _service.reject(id);
      await refreshAll();
      return true;
    } on ApiException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> startJob(int id, String selfiePath) async {
    try {
      await _service.startWithSelfie(id, selfiePath);
      await refreshAll();
      return true;
    } on ApiException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeJob(int id, String paymentMode) async {
    try {
      await _service.complete(id, paymentMode);
      await refreshAll();
      return true;
    } on ApiException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    }
  }
}
