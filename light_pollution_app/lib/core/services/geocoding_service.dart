import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../features/map/models/location_data.dart';

class GeocodingService {
  static const _reverseUrl = 'https://nominatim.openstreetmap.org/reverse';
  static const _searchUrl = 'https://nominatim.openstreetmap.org/search';

  Future<SelectedLocation> reverseGeocode(LatLng latLng) async {
    try {
      final uri = Uri.parse(
        '$_reverseUrl?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json&addressdetails=1',
      );

      final response = await http.get(uri, headers: {
        'User-Agent': 'SuraLightPollutionApp/1.0',
      });

      if (response.statusCode != 200) {
        return SelectedLocation(latLng: latLng);
      }

      final data = json.decode(response.body);
      if (data is! Map<String, dynamic>) {
        return SelectedLocation(latLng: latLng);
      }

      final address = data['address'] as Map<String, dynamic>?;

      String? name;
      if (address != null) {
        name = address['city'] ??
            address['town'] ??
            address['village'] ??
            address['hamlet'] ??
            address['county'];
      }

      return SelectedLocation(
        latLng: latLng,
        name: name,
        region: address?['state'],
        country: address?['country'],
      );
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');
      return SelectedLocation(latLng: latLng);
    }
  }

  Future<List<SelectedLocation>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse(
        '$_searchUrl?q=${Uri.encodeComponent(query)}&format=json&limit=5&addressdetails=1',
      );

      final response = await http.get(uri, headers: {
        'User-Agent': 'SuraLightPollutionApp/1.0',
      });

      if (response.statusCode != 200) return [];

      final data = json.decode(response.body);
      if (data is! List) return [];

      return data.map((item) {
        final lat = double.tryParse(item['lat']?.toString() ?? '') ?? 0.0;
        final lon = double.tryParse(item['lon']?.toString() ?? '') ?? 0.0;
        final address = item['address'] as Map<String, dynamic>?;

        return SelectedLocation(
          latLng: LatLng(lat, lon),
          name: address?['city'] ?? address?['town'] ?? item['display_name']?.toString().split(',').first,
          region: address?['state'],
          country: address?['country'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Place search failed: $e');
      return [];
    }
  }
}
