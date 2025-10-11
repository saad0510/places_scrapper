part of 'index.dart';

Future<Map<String, dynamic>> createHexagons(List<LatLng> points) async {
  const url = 'http://localhost:5000/hexagons';
  const headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
  final body = {'points': points._expandLatLng()};

  final uri = Uri.parse(url);
  final res = await http.post(uri, headers: headers, body: jsonEncode(body));
  assert(res.statusCode == 200);

  return Map.from(jsonDecode(res.body) ?? {});
}
