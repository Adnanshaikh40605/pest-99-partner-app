class PartnerBooking {
  PartnerBooking({
    required this.id,
    this.code,
    required this.serviceType,
    this.serviceCategory,
    this.bookingType,
    this.clientName,
    this.clientMobile,
    this.clientAddress,
    this.locationDisplay,
    this.scheduleDatetime,
    this.timeSlot,
    this.status,
    this.partnerStatus,
    this.price,
    this.priceDisplay,
    this.paymentStatus,
    this.paymentMode,
    this.bookingTag,
    this.canViewClientPhone = false,
    this.canStartJob = false,
    this.canCompleteJob = false,
    this.jobStartSelfieUrl,
    this.notes,
  });

  final int id;
  final String? code;
  final String serviceType;
  final String? serviceCategory;
  final String? bookingType;
  final String? clientName;
  final String? clientMobile;
  final String? clientAddress;
  final String? locationDisplay;
  final String? scheduleDatetime;
  final String? timeSlot;
  final String? status;
  final String? partnerStatus;
  final String? price;
  final String? priceDisplay;
  final String? paymentStatus;
  final String? paymentMode;
  final String? bookingTag;
  final bool canViewClientPhone;
  final bool canStartJob;
  final bool canCompleteJob;
  final String? jobStartSelfieUrl;
  final String? notes;

  factory PartnerBooking.fromJson(Map<String, dynamic> json) {
    return PartnerBooking(
      id: json['id'] as int,
      code: json['code'] as String?,
      serviceType: '${json['service_type'] ?? ''}',
      serviceCategory: json['service_category'] as String?,
      bookingType: json['booking_type'] as String?,
      clientName: json['client_name'] as String?,
      clientMobile: json['client_mobile'] as String?,
      clientAddress: json['client_address'] as String?,
      locationDisplay: json['location_display'] as String?,
      scheduleDatetime: json['schedule_datetime'] as String?,
      timeSlot: json['time_slot'] as String?,
      status: json['status'] as String?,
      partnerStatus: json['partner_status'] as String?,
      price: json['price']?.toString(),
      priceDisplay: json['price_display'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paymentMode: json['payment_mode'] as String?,
      bookingTag: json['booking_tag'] as String?,
      canViewClientPhone: json['can_view_client_phone'] == true,
      canStartJob: json['can_start_job'] == true,
      canCompleteJob: json['can_complete_job'] == true,
      jobStartSelfieUrl: json['job_start_selfie_url'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

class BookingCounts {
  BookingCounts({required this.available, required this.accepted, required this.completed});

  final int available;
  final int accepted;
  final int completed;

  factory BookingCounts.fromJson(Map<String, dynamic> json) => BookingCounts(
        available: json['available'] as int? ?? 0,
        accepted: json['accepted'] as int? ?? 0,
        completed: json['completed'] as int? ?? 0,
      );
}
