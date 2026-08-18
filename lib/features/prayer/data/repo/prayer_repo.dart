import '../models/location_model.dart';
import '../models/prayer_time_model.dart';
import '../models/qibla_model.dart';

abstract class PrayerRepo {
  Future<LocationModel> getLocation();

  List<PrayerTimeModel> getPrayerTimes(
    LocationModel location,
  );

  DateTime getTomorrowFajr(
    LocationModel location,
  );

  QiblaModel getQibla(
    LocationModel location,
  );
}