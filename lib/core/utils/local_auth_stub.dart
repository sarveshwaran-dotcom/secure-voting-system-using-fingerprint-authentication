// Stub implementation of LocalAuthentication for web
class LocalAuthentication {
  Future<bool> canCheckBiometrics = Future.value(false);
  
  Future<bool> isDeviceSupported() async => false;
  
  Future<bool> authenticate({
    required String localizedReason,
    AuthenticationOptions? options,
  }) async {
    // Always return true on web for demo
    return true;
  }
}

class AuthenticationOptions {
  final bool stickyAuth;
  final bool biometricOnly;
  
  const AuthenticationOptions({
    this.stickyAuth = false,
    this.biometricOnly = false,
  });
}
