import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/location_model.dart';

class LocationDataSource {
  final Geocoding _geocoding = Geocoding(
    locale: const Locale('ar', 'EG'),
  );

  Future<LocationModel> getCurrentLocation() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        'خدمة الموقع غير مفعلة على الجهاز',
      );
    }

    var permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        'تم رفض إذن الموقع',
      );
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        'إذن الموقع مرفوض بشكل دائم، فعّله من إعدادات التطبيق',
      );
    }

    final position =
        await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    String city = '';
    String country = '';

    try {
      final placemarks =
          await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;

        city =
            placemark.locality?.trim().isNotEmpty == true
                ? placemark.locality!.trim()
                : placemark.subAdministrativeArea
                        ?.trim() ??
                    placemark.administrativeArea
                        ?.trim() ??
                    '';

        country =
            placemark.country?.trim() ?? '';
      }
    } catch (_) {
      // Coordinates are still valid even if
      // reverse geocoding fails.
    }

    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      city: city,
      country: country,
    );
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}