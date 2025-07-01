import 'package:http/http.dart' as http;

class MacVendorService {
  Future<String> getVendor(String mac) async {
    final url = Uri.parse('https://api.macvendors.com/$mac');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Unknown Vendor";
    }
  }
}
