import 'package:adhan_dart/adhan_dart.dart';

import '../models/location_model.dart';
import '../models/prayer_time_model.dart';
import '../models/qibla_model.dart';

class PrayerDataSource {
  PrayerTimes _buildPrayerTimes(
    LocationModel location,
    DateTime date,
  ) {
    final coordinates = Coordinates(
      location.latitude,
      location.longitude,
    );

    final parameters =
        CalculationMethodParameters.egyptian();

    return PrayerTimes(
      coordinates: coordinates,
      date: date,
      calculationParameters: parameters,
      precision: true,
    );
  }

  List<PrayerTimeModel> getPrayerTimes(
    LocationModel location,
  ) {
    return getPrayerTimesForDate(
      location,
      DateTime.now(),
    );
  }

  List<PrayerTimeModel> getPrayerTimesForDate(
    LocationModel location,
    DateTime date,
  ) {
    final prayerTimes = _buildPrayerTimes(
      location,
      date,
    );

    return [
      PrayerTimeModel(
        type: PrayerType.fajr,
        name: 'الفجر',
        time: prayerTimes.fajr.toLocal(),
      ),
      PrayerTimeModel(
        type: PrayerType.sunrise,
        name: 'الشروق',
        time: prayerTimes.sunrise.toLocal(),
      ),
      PrayerTimeModel(
        type: PrayerType.dhuhr,
        name: 'الظهر',
        time: prayerTimes.dhuhr.toLocal(),
      ),
      PrayerTimeModel(
        type: PrayerType.asr,
        name: 'العصر',
        time: prayerTimes.asr.toLocal(),
      ),
      PrayerTimeModel(
        type: PrayerType.maghrib,
        name: 'المغرب',
        time: prayerTimes.maghrib.toLocal(),
      ),
      PrayerTimeModel(
        type: PrayerType.isha,
        name: 'العشاء',
        time: prayerTimes.isha.toLocal(),
      ),
    ];
  }

  DateTime getTomorrowFajr(
    LocationModel location,
  ) {
    final tomorrow = DateTime.now().add(
      const Duration(days: 1),
    );

    final prayerTimes = _buildPrayerTimes(
      location,
      tomorrow,
    );

    return prayerTimes.fajr.toLocal();
  }

  QiblaModel getQibla(
    LocationModel location,
  ) {
    final coordinates = Coordinates(
      location.latitude,
      location.longitude,
    );

    final direction = Qibla.qibla(
      coordinates,
    );

    return QiblaModel(
      direction: direction,
    );
  }
}