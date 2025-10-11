part of 'index.dart';

extension _ExpandLatLng on List<LatLng> {
  List<List<double>> _expandLatLng() {
    return map((e) => [e.latitude, e.longitude]).toList();
  }
}

extension _DecodeLatLng on List<dynamic> {
  List<LatLng> _decodeLatLng() {
    return map((e) => LatLng((e[0] as num).toDouble(), (e[1] as num).toDouble())).toList();
  }
}
