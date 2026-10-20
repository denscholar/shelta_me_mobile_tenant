class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.errors,
    this.data,
  });

  final String message;
  final String? code;
  final int? statusCode;
  final dynamic errors;
  final Map<String, dynamic>? data;

  String? fieldError(String fieldName) {
    final fieldErrors = errors;

    if (fieldErrors is! Map) {
      return null;
    }

    final value = fieldErrors[fieldName];

    if (value is String && value.isNotEmpty) {
      return value;
    }

    if (value is List && value.isNotEmpty) {
      return value.first.toString();
    }

    if (value is Map) {
      final nestedValue = value[fieldName];

      if (nestedValue is String) {
        return nestedValue;
      }

      if (nestedValue is List && nestedValue.isNotEmpty) {
        return nestedValue.first.toString();
      }
    }

    return null;
  }

  String? dataString(String key) {
    final value = data?[key];

    return value is String ? value : null;
  }

  bool? dataBool(String key) {
    final value = data?[key];

    return value is bool ? value : null;
  }

  int? dataInt(String key) {
    final value = data?[key];

    return value is int ? value : null;
  }

  DateTime? dataDateTime(String key) {
    final value = dataString(key);

    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  @override
  String toString() => message;
}
