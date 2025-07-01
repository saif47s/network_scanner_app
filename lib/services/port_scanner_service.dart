import 'dart:io';

class PortScannerService {
  // Scan a list of ports on a target IP
  Future<List<int>> scanPorts(String ip, List<int> ports,
      {Duration timeout = const Duration(milliseconds: 700)}) async {
    List<int> openPorts = [];
    for (int port in ports) {
      try {
        final socket = await Socket.connect(ip, port, timeout: timeout);
        openPorts.add(port);
        socket.destroy();
      } catch (_) {
        // Closed/filtered port, ignore
      }
    }
    return openPorts;
  }
}
