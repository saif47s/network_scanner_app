import 'package:dart_ping/dart_ping.dart';

class PingService {
  Future<List<PingData>> pingHost(String ip, {int count = 4}) async {
    final ping = Ping(ip, count: count);
    final responses = <PingData>[];
    await for (final data in ping.stream) {
      responses.add(data);
    }
    return responses;
  }
}
