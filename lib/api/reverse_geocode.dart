part of 'index.dart';

Future<Map<String, dynamic>> reverseGeocode(LatLng latLng) async {
  const url = 'https://api.geoapify.com/v1/geocode/reverse';
  const headers = {'Accept': 'application/json'};
  final params = {
    'lat': '${latLng.latitude}',
    'lon': '${latLng.longitude}',
    'type': 'city',
    'lang': 'en',
    'limit': '1',
    'format': 'json',
    'apiKey': '202d8c0a3a9d433b8a22394c4d487990',
  };

  final uri = Uri.parse(url).replace(queryParameters: params);
  final res = await http.get(uri, headers: headers);
  assert(res.statusCode == 200);

  final data = Map.from(jsonDecode(res.body) ?? {});
  final result = List.from(data['results'] ?? []).firstOrNull;
  return result ?? {};
}
