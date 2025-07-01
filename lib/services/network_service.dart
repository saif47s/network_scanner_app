import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/network_profile.dart';
import 'package:uuid/uuid.dart';

class NetworkService {
  static const String _keyNetworks = 'networks';
  static const String _keyLastNetwork = 'last_network';

  Future<List<NetworkProfile>> getNetworks() async {
    final prefs = await SharedPreferences.getInstance();
    final listString = prefs.getString(_keyNetworks);
    if (listString == null) return [];
    final List<dynamic> data = json.decode(listString);
    return data.map((e) => NetworkProfile.fromMap(e)).toList();
  }

  Future<void> saveNetworks(List<NetworkProfile> networks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(networks.map((n) => n.toMap()).toList());
    await prefs.setString(_keyNetworks, data);
  }

  Future<NetworkProfile> createNetwork(String name) async {
    final uuid = const Uuid();
    final net = NetworkProfile(id: uuid.v4(), name: name);
    final nets = await getNetworks();
    nets.add(net);
    await saveNetworks(nets);
    return net;
  }

  Future<void> renameNetwork(String id, String newName) async {
    final nets = await getNetworks();
    for (var n in nets) {
      if (n.id == id) n = NetworkProfile(id: n.id, name: newName);
    }
    await saveNetworks(nets);
  }

  Future<void> deleteNetwork(String id) async {
    final nets = await getNetworks();
    nets.removeWhere((n) => n.id == id);
    await saveNetworks(nets);
  }

  Future<String?> getLastNetworkId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastNetwork);
  }

  Future<void> setLastNetworkId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastNetwork, id);
  }
}
