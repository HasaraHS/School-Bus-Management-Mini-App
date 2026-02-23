import 'user.dart';

class School {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<User>? users;

  School({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.users,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String && value.trim().isNotEmpty) {
        return double.parse(value);
      }
      throw FormatException('Invalid coordinate value: $value');
    }

    return School(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      users: json['users'] != null
           ? (json['users'] as List).map((u) => User.fromJson(u)).toList()
          : null,
    );

  }
}
