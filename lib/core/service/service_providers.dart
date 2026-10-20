import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheltame_tenant_app/core/service/otp_autofill_service.dart';

final otpAutofillServiceProvider = Provider<OtpAutofillService>((ref) {
  final service = OtpAutofillService();

  ref.onDispose(service.dispose);

  return service;
});
