import 'dart:io';

import 'package:smart_auth/smart_auth.dart';

class OtpAutofillService {
  OtpAutofillService({SmartAuth? smartAuth})
    : _smartAuth = smartAuth ?? SmartAuth.instance;

  final SmartAuth _smartAuth;

  /// Starts Android's SMS Retriever listener.
  ///
  /// This method does not request permission to read all SMS messages.
  /// The backend SMS must include the correct application signature.
  Future<String?> listenForCode() async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final result = await _smartAuth.getSmsWithRetrieverApi();

      if (!result.hasData) {
        return null;
      }

      return result.requireData.code;
    } catch (_) {
      return null;
    }
  }

  /// Alternative Android implementation.
  ///
  /// This displays a native consent prompt asking the user to allow the
  /// application to read one specific verification SMS.
  Future<String?> listenWithUserConsent() async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final result = await _smartAuth.getSmsWithUserConsentApi();

      if (!result.hasData) {
        return null;
      }

      return result.requireData.code;
    } catch (_) {
      return null;
    }
  }

  /// Returns the Android app signature that must be included in the SMS.
  Future<String?> getAppSignature() async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      final result = await _smartAuth.getAppSignature();

      if (!result.hasData) {
        return null;
      }

      return result.requireData;
    } catch (_) {
      return null;
    }
  }

  void stopListening() {
    _smartAuth.removeSmsRetrieverApiListener();
    _smartAuth.removeUserConsentApiListener();
  }

  void dispose() {
    stopListening();
  }
}
