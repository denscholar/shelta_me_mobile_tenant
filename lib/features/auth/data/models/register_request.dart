class RegisterRequest {
  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  final String firstName;
  final String lastName;
  final String? email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'role': 'tenant',
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}
