part of 'index.dart';

Future<List<LatLng>> simplifyGeoJson(List<LatLng> points) async {
  const url = 'http://localhost:5000/simplify';
  const headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
  final body = {'points': points._expandLatLng()};

  final uri = Uri.parse(url);
  final res = await http.post(uri, headers: headers, body: jsonEncode(body));
  assert(res.statusCode == 200);

  final data = List.from(jsonDecode(res.body) ?? {});
  return data._decodeLatLng();
}
