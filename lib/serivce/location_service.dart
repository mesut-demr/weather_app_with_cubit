import 'package:geolocator/geolocator.dart';

class LocationService {

Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      throw Exception('Konum alınamadı: $e');
    }
  }

  Stream<Position> listenLocationChanges() {
    return Geolocator.getPositionStream();
  }
}
