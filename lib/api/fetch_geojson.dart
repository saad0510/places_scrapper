part of 'index.dart';

Future<Map<String, dynamic>> fetchGeojson(String placeId) async {
  const url = 'https://api.geoapify.com/v2/place-details';
  const headers = {'Accept': 'application/geo+json'};
  final params = {'id': placeId, 'lang': 'en', 'apiKey': '202d8c0a3a9d433b8a22394c4d487990'};

  final uri = Uri.parse(url).replace(queryParameters: params);
  final res = await http.get(uri, headers: headers);
  assert(res.statusCode == 200);

  return Map.from(jsonDecode(res.body) ?? {});
}
