enum OtpEntrySource { registration, login }

class OtpScreenArguments {
  const OtpScreenArguments({
    required this.phoneNumber,
    required this.source,
    this.resendAvailableAt,
  });

  final String phoneNumber;
  final OtpEntrySource source;
  final DateTime? resendAvailableAt;
}
