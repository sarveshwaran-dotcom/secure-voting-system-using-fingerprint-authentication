
// Commented for web demo - package not available
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Stub classes for web compatibility
class AuthenticationOptions {
  final bool stickyAuth;
  final bool biometricOnly;
  const AuthenticationOptions({this.stickyAuth = false, this.biometricOnly = false});
}

class LocalAuthentication {
  Future<bool> get canCheckBiometrics async => false;
  Future<bool> isDeviceSupported() async => false;
  Future<List<String>> getAvailableBiometrics() async => [];
  Future<bool> authenticate({
    required String localizedReason,
    AuthenticationOptions? options,
  }) async => true;
}

class FlutterSecureStorage {
  Future<String?> read({required String key}) async => null;
  Future<void> write({required String key, required String value}) async {}
  Future<void> delete({required String key}) async {}
}

// BiometricType enum stub
enum BiometricType { face, fingerprint, iris, weak, strong }

class BiometricService {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;
  
  static const String _failedAttemptsKey = 'biometric_failed_attempts';
  static const String _lockTimeKey = 'biometric_lock_time';
  static const int _maxAttempts = 3;
  static const int _lockDurationMinutes = 5;

  BiometricService(this._localAuth, this._secureStorage);

  // Check if biometric is available
  Future<bool> isBiometricAvailable() async {
    return false; // Always false for web demo
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return [];
  }

  // Check if device is locked due to failed attempts
  Future<bool> isDeviceLocked() async {
    return false;
  }

  // Get remaining lock time in seconds
  Future<int> getRemainingLockTime() async {
    return 0;
  }

  // Authenticate with biometric
  Future<bool> authenticate({
    required String reason,
  }) async {
    // Always succeed for demo
    return true;
  }

  // Increment failed attempts
  Future<void> _incrementFailedAttempts() async {}

  // Reset failed attempts
  Future<void> _resetFailedAttempts() async {}

  // Get failed attempts count
  Future<int> getFailedAttempts() async {
    return 0;
  }

  // Get remaining attempts
  Future<int> getRemainingAttempts() async {
    return _maxAttempts;
  }
}
