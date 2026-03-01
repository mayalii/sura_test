import 'package:latlong2/latlong.dart';

class DarkSkySite {
  final String name;
  final String nameAr;
  final String region;
  final String regionAr;
  final double latitude;
  final double longitude;
  final int bortleClass;
  final String certification;
  final String certificationAr;

  const DarkSkySite({
    required this.name,
    required this.nameAr,
    required this.region,
    required this.regionAr,
    required this.latitude,
    required this.longitude,
    required this.bortleClass,
    required this.certification,
    required this.certificationAr,
  });

  LatLng get latLng => LatLng(latitude, longitude);
}

const darkSkySites = [
  DarkSkySite(
    name: 'AlUla',
    nameAr: 'العلا',
    region: 'Medina',
    regionAr: 'المدينة المنورة',
    latitude: 26.6174,
    longitude: 37.9189,
    bortleClass: 1,
    certification: 'IDA Certified',
    certificationAr: 'معتمد من IDA',
  ),
  DarkSkySite(
    name: 'Tabuk',
    nameAr: 'تبوك',
    region: 'Tabuk',
    regionAr: 'تبوك',
    latitude: 28.3835,
    longitude: 36.5662,
    bortleClass: 2,
    certification: 'Pristine Dark Sky',
    certificationAr: 'سماء مظلمة نقية',
  ),
  DarkSkySite(
    name: 'Hail',
    nameAr: 'حائل',
    region: 'Hail',
    regionAr: 'حائل',
    latitude: 27.5114,
    longitude: 41.7208,
    bortleClass: 2,
    certification: 'Pristine Dark Sky',
    certificationAr: 'سماء مظلمة نقية',
  ),
  DarkSkySite(
    name: 'Al Baha',
    nameAr: 'الباحة',
    region: 'Al Baha',
    regionAr: 'الباحة',
    latitude: 20.0000,
    longitude: 41.4667,
    bortleClass: 3,
    certification: 'Dark Sky Reserve',
    certificationAr: 'محمية سماء مظلمة',
  ),
  DarkSkySite(
    name: 'Asir',
    nameAr: 'عسير',
    region: 'Asir',
    regionAr: 'عسير',
    latitude: 18.2164,
    longitude: 42.5053,
    bortleClass: 2,
    certification: 'Pristine Dark Sky',
    certificationAr: 'سماء مظلمة نقية',
  ),
  DarkSkySite(
    name: 'NEOM',
    nameAr: 'نيوم',
    region: 'Tabuk',
    regionAr: 'تبوك',
    latitude: 27.9500,
    longitude: 35.3000,
    bortleClass: 1,
    certification: 'IDA Certified',
    certificationAr: 'معتمد من IDA',
  ),
  DarkSkySite(
    name: 'Empty Quarter',
    nameAr: 'الربع الخالي',
    region: 'Najran',
    regionAr: 'نجران',
    latitude: 20.0000,
    longitude: 50.0000,
    bortleClass: 1,
    certification: 'Pristine Dark Sky',
    certificationAr: 'سماء مظلمة نقية',
  ),
];
