// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final int id;
  final String slug;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;
  final bool isVerified;
  UserModel({
    required this.id,
    required this.slug,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.isVerified,
  });

  String get fullName {
    return '$firstName $lastName';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      slug: json['slug'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      role: json['role'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }
}
