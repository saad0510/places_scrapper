part of 'index.dart';

Future<Map<String, dynamic>> getGeoJson(LatLng latLng) async {
  const url = 'http://localhost:5000/geojson';
  const headers = {'Accept': 'application/geo+json'};
  final params = {'lat': latLng.latitude.toString(), 'lng': latLng.longitude.toString()};

  final uri = Uri.parse(url).replace(queryParameters: params);
  final res = await http.get(uri, headers: headers);
  assert(res.statusCode == 200);

  return Map.from(jsonDecode(res.body) ?? {});
}
