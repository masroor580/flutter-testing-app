import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  /// ✅ Checks if biometrics are available on the device
  Future<bool> isBiometricAvailable() async {
    return await _auth.canCheckBiometrics;
  }

  /// ✅ Prompts the user for biometric authentication, returns `true` if successful
  Future<bool> authenticate({bool useStickyAuth = true}) async {
    try {
      // ✅ Prevent authentication if biometrics are unavailable
      if (!await isBiometricAvailable()) {
        print("❌ Biometric authentication not available on this device.");
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: AuthenticationOptions(
          stickyAuth: useStickyAuth, // ✅ Optional stickyAuth
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print("❌ Biometric authentication error: $e");
      return false;
    }
  }
}
