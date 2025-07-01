import 'package:http/http.dart' as http;
import '../models/device.dart';

class ScanService {
  Future<String?> getVendorFromMac(String mac) async {
    try {
      final url = Uri.parse('https://api.macvendors.com/$mac');
      final response = await http.get(url);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response.body;
      }
    } catch (e) {}
    return null;
  }

  // Updated: Accepts a list of maps with 'ip' and 'mac'
  Future<List<Device>> scanNetwork(List<Map<String, String>> ipMacList) async {
    List<Device> scannedDevices = [];
    for (final entry in ipMacList) {
      final ip = entry["ip"] ?? "";
      final mac = entry["mac"] ?? "";
      String? vendor;
      if (mac.isNotEmpty) {
        vendor = await getVendorFromMac(mac);
      }
      scannedDevices.add(Device(
        ip: ip,
        lastSeen: DateTime.now(),
        mac: mac,
        vendor: vendor,
      ));
    }
    return scannedDevices;
  }
}
