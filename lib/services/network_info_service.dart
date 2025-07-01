import 'package:network_info_plus/network_info_plus.dart';

class NetworkInfoService {
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<String?> getWifiName() async => await _networkInfo.getWifiName();
  Future<String?> getWifiIP() async => await _networkInfo.getWifiIP();
  Future<String?> getWifiGatewayIP() async =>
      await _networkInfo.getWifiGatewayIP();
}
