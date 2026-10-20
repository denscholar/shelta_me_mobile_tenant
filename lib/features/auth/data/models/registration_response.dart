class RegistrationResponse {
  const RegistrationResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.phoneNumber,
    required this.role,
    required this.phoneVerified,
  });

  final bool success;
  final String code;
  final String message;
  final String phoneNumber;
  final String role;
  final bool phoneVerified;

  factory RegistrationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    if (rawData is! Map) {
      throw const FormatException(
        'Registration response does not contain valid data.',
      );
    }

    final data = Map<String, dynamic>.from(rawData);

    final phoneNumber =
        data['phone_number'] as String? ?? '';

    if (phoneNumber.isEmpty) {
      throw const FormatException(
        'Registration response does not contain a phone number.',
      );
    }

    return RegistrationResponse(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      phoneNumber: phoneNumber,
      role: data['role'] as String? ?? '',
      phoneVerified:
          data['phone_verified'] as bool? ?? false,
    );
  }
}