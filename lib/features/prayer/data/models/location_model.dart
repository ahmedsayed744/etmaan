class LocationModel {
  final double latitude;
  final double longitude;
  final String city;
  final String country;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
  });

  String get displayName {
    if (city.isEmpty && country.isEmpty) {
      return 'موقع غير معروف';
    }

    if (country.isEmpty) {
      return city;
    }

    if (city.isEmpty) {
      return country;
    }

    return '$city، $country';
  }
}