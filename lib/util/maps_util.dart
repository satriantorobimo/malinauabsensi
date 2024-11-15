import 'package:url_launcher/url_launcher.dart';

class MapUtil {
  MapUtil._();

  static Future<void> openMap(double latitude, double longitude) async {
    try {
      const String markerLabel = 'Here';
      final url = Uri.parse(
          'geo:$latitude,$longitude?q=$latitude,$longitude($markerLabel)');
      await launchUrl(url);
    } catch (error) {
      throw ('cannot open');
    }
  }
}
