class User {
  final String id;
  final String fullName;
  final String email;
  final String schoolId;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.schoolId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      schoolId: json['schoolId'],
    );
  }
}