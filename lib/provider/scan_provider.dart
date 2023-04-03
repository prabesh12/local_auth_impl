import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:scan/enum/support_state.dart';

class ScanProvider extends ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();
  final SupportState _supportState = SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  SupportState get supportState => _supportState;
  bool? get canCheckBiometrics => _canCheckBiometrics;
  List<BiometricType>? get availableBiometrics => _availableBiometrics;
  String get authorized => _authorized;
  bool get isAuthenticating => _isAuthenticating;

  Future<void> checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }

    _canCheckBiometrics = canCheckBiometrics;
    notifyListeners();
  }

  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }

    _availableBiometrics = availableBiometrics;
    notifyListeners();
  }

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      _isAuthenticating = true;
      _authorized = 'Authenticating';
      notifyListeners();
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      _isAuthenticating = false;
    } on PlatformException catch (e) {
      print(e);
      _isAuthenticating = false;
      _authorized = 'Error - ${e.message}';
      notifyListeners();
      return;
    }

    _authorized = authenticated ? 'Authorized' : 'Not Authorized';
    notifyListeners();
  }

  Future<void> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      _isAuthenticating = true;
      _authorized = 'Authenticating';
      notifyListeners();
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      _isAuthenticating = false;
      _authorized = 'Authenticating';
    } on PlatformException catch (e) {
      print(e);
      _isAuthenticating = false;
      _authorized = 'Error - ${e.message}';
      notifyListeners();
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    _authorized = message;
    notifyListeners();
  }

  void cancelAuthentication() {
    auth.stopAuthentication();
    _isAuthenticating = false;
    _authorized = 'Not Authorized';
    notifyListeners();
  }
}
