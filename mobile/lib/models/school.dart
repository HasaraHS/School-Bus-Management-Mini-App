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
    return School(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      users: json['users'] != null
           ? (json['users'] as List).map((u) => User.fromJson(u)).toList()
          : null,
    );

  }
}