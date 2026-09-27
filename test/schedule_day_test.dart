import 'package:flutter_test/flutter_test.dart';
import 'package:pest_99_partner_app/core/constants/notification_channels.dart';
import 'package:pest_99_partner_app/core/mappers/booking_mapper.dart';
import 'package:pest_99_partner_app/core/schedule_day.dart';
import 'package:pest_99_partner_app/models/booking.dart';
import 'package:pest_99_partner_app/shared/widgets/booking_day_sections.dart';

PartnerBooking _job(int id, String schedule) => PartnerBooking(
      id: id,
      serviceType: 'Cockroach',
      scheduleDatetime: schedule,
    );

void main() {
  // 27 Sep 2026 10:00 IST
  final morningIst = DateTime.utc(2026, 9, 27, 4, 30);
  // 27 Sep 2026 22:00 IST
  final lateIst = DateTime.utc(2026, 9, 27, 16, 30);

  group('ScheduleDay IST buckets', () {
    test('today afternoon IST stays on Today', () {
      expect(
        ScheduleDay.bucketFor('2026-09-27T16:30:00+05:30', now: morningIst),
        'today',
      );
      expect(
        ScheduleDay.bucketFor('2026-09-27T11:00:00Z', now: morningIst),
        'today',
      );
    });

    test('next IST calendar day is Tomorrow', () {
      expect(
        ScheduleDay.bucketFor('2026-09-28T09:00:00+05:30', now: morningIst),
        'tomorrow',
      );
    });

    test('IST midnight stored as the previous UTC instant is Tomorrow, not missed', () {
      // 28 Sep 2026 00:00 IST == 27 Sep 2026 18:30 UTC.
      // A UTC or US-local calendar date is the 27th, so phone-local Today
      // and Tomorrow both skip it when "now" is the morning of the 27th in India.
      expect(
        ScheduleDay.bucketFor('2026-09-27T18:30:00Z', now: morningIst),
        'tomorrow',
      );
      expect(
        ScheduleDay.bucketFor('2026-09-28T00:00:00+05:30', now: morningIst),
        'tomorrow',
      );
    });

    test('late-night UTC is the next IST day and lands on Tomorrow', () {
      // 27 Sep 2026 20:00 UTC == 28 Sep 2026 01:30 IST.
      expect(
        ScheduleDay.bucketFor('2026-09-27T20:00:00Z', now: lateIst),
        'tomorrow',
      );
    });

    test('a morning IST job is Today even when UTC still says yesterday', () {
      // 27 Sep 2026 00:30 IST == 26 Sep 2026 19:00 UTC.
      expect(
        ScheduleDay.bucketFor('2026-09-26T19:00:00Z', now: morningIst),
        'today',
      );
    });

    test('same-evening IST job stays on Today', () {
      expect(
        ScheduleDay.bucketFor('2026-09-27T23:30:00+05:30', now: lateIst),
        'today',
      );
    });

    test('a zone-less schedule string is an IST wall clock, not the phone clock', () {
      expect(
        ScheduleDay.bucketFor('2026-09-28T08:00:00', now: lateIst),
        'tomorrow',
      );
    });

    test('beyond tomorrow is Later, and parse failure is not a day tab', () {
      expect(
        ScheduleDay.bucketFor('2026-09-30T10:00:00+05:30', now: morningIst),
        'later',
      );
      expect(ScheduleDay.bucketFor('not-a-date', now: morningIst), isNull);
    });
  });

  group('New Bookings day sections', () {
    test('morning IST job, midnight edge, and late UTC split into Today and Tomorrow', () {
      final sections = BookingDaySections.from(
        [
          _job(1, '2026-09-26T19:00:00Z'), // 00:30 IST 27 Sep — today
          _job(2, '2026-09-27T18:30:00Z'), // 00:00 IST 28 Sep — tomorrow
          _job(3, '2026-09-27T20:00:00Z'), // 01:30 IST 28 Sep — tomorrow
          _job(4, '2026-09-30T10:00:00+05:30'),
        ],
        now: morningIst,
      );

      expect(sections.today.map((b) => b.id), [1]);
      expect(sections.tomorrow.map((b) => b.id), [2, 3]);
      expect(sections.later.map((b) => b.id), [4]);
    });

    test('mapper label matches the IST bucket', () {
      final booking = BookingMapper.fromPartner(
        _job(9, '2026-09-27T20:00:00Z'),
        now: lateIst,
      );
      expect(booking.dayBucket, 'tomorrow');
      expect(booking.dateLabel, 'Tomorrow');
      expect(booking.timeLabel, '1:30 AM');
    });
  });

  group('notification tap payload', () {
    test('reads booking id from a local notification JSON payload', () {
      final data = notificationDataFromPayload(
        '{"type":"new_booking","booking_id":"4821","schedule_datetime":"2026-09-27T18:30:00Z"}',
      );
      expect(bookingIdFromNotificationData(data), 4821);
      expect(isNewBookingPush(data!), isTrue);
      expect(
        ScheduleDay.bucketFor(data['schedule_datetime']?.toString(), now: morningIst),
        'tomorrow',
      );
    });

    test('ignores a payload with no booking id', () {
      expect(notificationDataFromPayload('not-json'), isNull);
      expect(
        bookingIdFromNotificationData({'type': 'new_booking'}),
        isNull,
      );
    });
  });
}
