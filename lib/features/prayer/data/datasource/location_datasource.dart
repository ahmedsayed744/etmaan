import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

class LocationDataSource {
  final Geocoding _geocoding = Geocoding(locale: const Locale('ar'));

  Future<LocationModel> getCurrentLocation() async {
    final cache = CacheHelper();
    Position? position;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (serviceEnabled) {
        var permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (_) {
      // GPS position fetch failed or timed out (e.g. offline indoors)
    }

    if (position != null) {
      await cache.saveData(
        key: CacheKeys.lastLatitude,
        value: position.latitude,
      );
      await cache.saveData(
        key: CacheKeys.lastLongitude,
        value: position.longitude,
      );

      String city = '';
      String country = '';

      try {
        final placemarks = await _geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;

          city = placemark.locality?.trim().isNotEmpty == true
              ? placemark.locality!.trim()
              : placemark.subAdministrativeArea?.trim() ??
                    placemark.administrativeArea?.trim() ??
                    '';

          country = placemark.country?.trim() ?? '';

          if (city.isNotEmpty) {
            await cache.saveData(key: CacheKeys.lastCity, value: city);
          }
          if (country.isNotEmpty) {
            await cache.saveData(key: CacheKeys.lastCountry, value: country);
          }
        }
      } catch (_) {
        // Coordinates are still valid even if reverse geocoding fails offline.
      }

      if (city.isEmpty) {
        city = (cache.getData(key: CacheKeys.lastCity) as String?) ?? '';
      }
      if (country.isEmpty) {
        country = (cache.getData(key: CacheKeys.lastCountry) as String?) ?? '';
      }

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        city: city,
        country: country,
      );
    }

    // Reuse last saved coordinates when GPS is temporarily unavailable offline
    final savedLat = cache.getData(key: CacheKeys.lastLatitude);
    final savedLng = cache.getData(key: CacheKeys.lastLongitude);

    if (savedLat is double && savedLng is double) {
      final savedCity =
          (cache.getData(key: CacheKeys.lastCity) as String?) ?? '';
      final savedCountry =
          (cache.getData(key: CacheKeys.lastCountry) as String?) ?? '';

      return LocationModel(
        latitude: savedLat,
        longitude: savedLng,
        city: savedCity,
        country: savedCountry,
      );
    }

    // No GPS position and no saved coordinates: check standard permission errors
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة الموقع غير مفعلة على الجهاز');
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('تم رفض إذن الموقع');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('إذن الموقع مرفوض بشكل دائم، فعّله من إعدادات التطبيق');
    }

    throw Exception('تعذر تحديد موقع الجهاز');
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
