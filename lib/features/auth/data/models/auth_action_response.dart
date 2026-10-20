class AuthActionResponse {
  const AuthActionResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  final bool success;
  final String code;
  final String message;
  final Map<String, dynamic>? data;

  DateTime? get resendAvailableAt {
    final value = data?['resend_available_at'];

    if (value is! String || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  int? get retryAfterSeconds {
    final value = data?['retry_after_seconds'];

    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  factory AuthActionResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    Map<String, dynamic>? parsedData;

    if (rawData is Map) {
      parsedData = Map<String, dynamic>.from(rawData);
    }

    return AuthActionResponse(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: parsedData,
    );
  }
}
