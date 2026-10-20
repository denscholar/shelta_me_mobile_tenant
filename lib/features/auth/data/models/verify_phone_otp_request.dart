class VerifyPhoneOtpRequest {
  const VerifyPhoneOtpRequest({required this.phoneNumber, required this.otp});

  final String phoneNumber;
  final String otp;

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'otp': otp};
  }
}
