import '../datasource/location_datasource.dart';
import '../datasource/prayer_datasource.dart';
import '../models/location_model.dart';
import '../models/prayer_time_model.dart';
import '../models/qibla_model.dart';
import 'prayer_repo.dart';

class PrayerRepoImp implements PrayerRepo {
  final LocationDataSource locationDataSource;
  final PrayerDataSource prayerDataSource;

  PrayerRepoImp({
    required this.locationDataSource,
    required this.prayerDataSource,
  });

  @override
  Future<LocationModel> getLocation() {
    return locationDataSource.getCurrentLocation();
  }

  @override
  List<PrayerTimeModel> getPrayerTimes(
    LocationModel location,
  ) {
    return prayerDataSource.getPrayerTimes(
      location,
    );
  }

  @override
  DateTime getTomorrowFajr(
    LocationModel location,
  ) {
    return prayerDataSource.getTomorrowFajr(
      location,
    );
  }

  @override
  QiblaModel getQibla(
    LocationModel location,
  ) {
    return prayerDataSource.getQibla(
      location,
    );
  }
}