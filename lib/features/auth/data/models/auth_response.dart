import 'auth_tokens.dart';
import 'user_model.dart';

class AuthResponse {
  const AuthResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.user,
    required this.tokens,
  });

  final bool success;
  final String code;
  final String message;
  final UserModel user;
  final AuthTokens tokens;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw const FormatException(
        'Authentication response does not contain data.',
      );
    }

    final userJson = data['user'] as Map<String, dynamic>?;

    final tokenJson = data['tokens'] as Map<String, dynamic>?;

    if (userJson == null) {
      throw const FormatException(
        'Authentication response does not contain user data.',
      );
    }

    if (tokenJson == null) {
      throw const FormatException(
        'Authentication response does not contain tokens.',
      );
    }

    return AuthResponse(
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      user: UserModel.fromJson(userJson),
      tokens: AuthTokens.fromJson(tokenJson),
    );
  }
}
