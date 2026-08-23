import 'package:etmaan/features/prayer/data/datasource/prayer_datasource.dart';
import 'package:etmaan/features/prayer/data/models/location_model.dart';
import 'package:etmaan/features/prayer/data/models/prayer_time_model.dart';
import 'package:flutter_test/flutter_test.dart';

// Cairo coordinates — well-known reference location for prayer time tests.
const _cairo = LocationModel(
  latitude: 30.0444,
  longitude: 31.2357,
  city: 'Cairo',
  country: 'Egypt',
);

// London — western longitude
const _london = LocationModel(
  latitude: 51.5074,
  longitude: -0.1278,
  city: 'London',
  country: 'UK',
);

void main() {
  group('PrayerDataSource', () {
    final ds = PrayerDataSource();

    // ──────────────────────────────────────────────────
    // getPrayerTimesForDate
    // ──────────────────────────────────────────────────

    test('returns exactly 6 prayer times', () {
      final date = DateTime(2025, 6, 15);
      final times = ds.getPrayerTimesForDate(_cairo, date);
      expect(times.length, 6);
    });

    test('prayer times include all expected types', () {
      final date = DateTime(2025, 6, 15);
      final times = ds.getPrayerTimesForDate(_cairo, date);
      final types = times.map((t) => t.type).toSet();
      expect(types, containsAll(PrayerType.values));
    });

    test('prayer times are in chronological order', () {
      final date = DateTime(2025, 6, 15);
      final times = ds.getPrayerTimesForDate(_cairo, date);
      for (var i = 0; i < times.length - 1; i++) {
        expect(times[i].time.isBefore(times[i + 1].time), isTrue,
            reason:
                '${times[i].name} must come before ${times[i + 1].name}');
      }
    });

    test('Fajr name is "الفجر"', () {
      final date = DateTime(2025, 6, 15);
      final times = ds.getPrayerTimesForDate(_cairo, date);
      final fajr = times.firstWhere((t) => t.type == PrayerType.fajr);
      expect(fajr.name, 'الفجر');
    });

    test('Isha name is "العشاء"', () {
      final date = DateTime(2025, 6, 15);
      final times = ds.getPrayerTimesForDate(_cairo, date);
      final isha = times.firstWhere((t) => t.type == PrayerType.isha);
      expect(isha.name, 'العشاء');
    });

    test('times differ for different cities (Cairo vs London)', () {
      final date = DateTime(2025, 6, 15);
      final cairoTimes = ds.getPrayerTimesForDate(_cairo, date);
      final londonTimes = ds.getPrayerTimesForDate(_london, date);
      final cairoFajr =
          cairoTimes.firstWhere((t) => t.type == PrayerType.fajr).time;
      final londonFajr =
          londonTimes.firstWhere((t) => t.type == PrayerType.fajr).time;
      expect(cairoFajr, isNot(equals(londonFajr)));
    });

    // ──────────────────────────────────────────────────
    // getTomorrowFajr
    // ──────────────────────────────────────────────────

    test('getTomorrowFajr is after today\'s Fajr', () {
      final today = DateTime.now();
      final todayTimes = ds.getPrayerTimesForDate(_cairo, today);
      final todayFajr =
          todayTimes.firstWhere((t) => t.type == PrayerType.fajr).time;
      final tomorrowFajr = ds.getTomorrowFajr(_cairo);
      expect(tomorrowFajr.isAfter(todayFajr), isTrue);
    });

    test('getTomorrowFajr is within 26 hours from now', () {
      final tomorrowFajr = ds.getTomorrowFajr(_cairo);
      final diff = tomorrowFajr.difference(DateTime.now());
      expect(diff.inHours, lessThan(27));
    });

    // ──────────────────────────────────────────────────
    // getQibla
    // ──────────────────────────────────────────────────

    test('Qibla direction for Cairo is roughly 134-136 degrees', () {
      final qibla = ds.getQibla(_cairo);
      // Cairo Qibla is approximately 135 degrees
      expect(qibla.direction, inInclusiveRange(130, 140));
    });

    test('Qibla direction for London is roughly 118-122 degrees', () {
      final qibla = ds.getQibla(_london);
      expect(qibla.direction, inInclusiveRange(115, 125));
    });

    test('Qibla direction is between 0 and 360', () {
      final qibla = ds.getQibla(_cairo);
      expect(qibla.direction, inInclusiveRange(0, 360));
    });
  });

  // ──────────────────────────────────────────────────
  // LocationModel
  // ──────────────────────────────────────────────────

  group('LocationModel.displayName', () {
    test('returns city, country when both present', () {
      expect(_cairo.displayName, 'Cairo، Egypt');
    });

    test('returns only city when country is empty', () {
      const loc = LocationModel(
        latitude: 0,
        longitude: 0,
        city: 'TestCity',
        country: '',
      );
      expect(loc.displayName, 'TestCity');
    });

    test('returns only country when city is empty', () {
      const loc = LocationModel(
        latitude: 0,
        longitude: 0,
        city: '',
        country: 'TestCountry',
      );
      expect(loc.displayName, 'TestCountry');
    });

    test('returns "موقع غير معروف" when both empty', () {
      const loc = LocationModel(
        latitude: 0,
        longitude: 0,
        city: '',
        country: '',
      );
      expect(loc.displayName, 'موقع غير معروف');
    });
  });

  // ──────────────────────────────────────────────────
  // PrayerCubit – qiblaRelativeAngle helper logic
  // ──────────────────────────────────────────────────

  group('Qibla relative angle calculation', () {
    double relativeAngle(double qiblaDir, double heading) {
      var angle = qiblaDir - heading;
      while (angle > 180) {
        angle -= 360;
      }
      while (angle < -180) {
        angle += 360;
      }
      return angle;
    }

    test('angle is 0 when facing qibla exactly', () {
      expect(relativeAngle(135, 135), 0);
    });

    test('angle is positive when qibla is clockwise from heading', () {
      expect(relativeAngle(180, 90), 90);
    });

    test('angle wraps correctly past 180', () {
      final angle = relativeAngle(10, 350);
      expect(angle, closeTo(20, 1));
    });

    test('angle stays within [-180, 180]', () {
      for (var qibla = 0; qibla <= 360; qibla += 15) {
        for (var heading = 0; heading <= 360; heading += 15) {
          final angle = relativeAngle(qibla.toDouble(), heading.toDouble());
          expect(angle, inInclusiveRange(-180, 180));
        }
      }
    });
  });
}
