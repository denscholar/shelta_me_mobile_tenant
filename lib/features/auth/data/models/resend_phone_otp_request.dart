class ResendPhoneOtpRequest {
  const ResendPhoneOtpRequest({required this.phoneNumber});

  final String phoneNumber;

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber};
  }
}
