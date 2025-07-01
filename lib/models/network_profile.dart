class NetworkProfile {
  final String id;
  final String name;

  NetworkProfile({required this.id, required this.name});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  factory NetworkProfile.fromMap(Map<String, dynamic> map) {
    return NetworkProfile(
      id: map['id'],
      name: map['name'],
    );
  }
}
