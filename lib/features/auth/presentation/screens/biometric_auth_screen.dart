import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../../core/utils/local_auth_stub.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../voting/presentation/screens/party_list_screen.dart';

class BiometricAuthScreen extends StatefulWidget {
  const BiometricAuthScreen({super.key});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  int _attemptCount = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    if (!kIsWeb) {
      _checkBiometricAvailability();
    }
  }

  void _setupAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        if (mounted) {
          // On devices without biometric, show info but allow proceed
          debugPrint('Biometric not available - demo mode');
        }
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Error checking biometric: $e');
      }
    }
  }

  Future<void> _authenticate() async {
    // Web/Demo mode - skip biometric and proceed
    if (kIsWeb) {
      setState(() {
        _isAuthenticating = true;
      });

      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Success - Navigate to party list
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PartyListScreen(),
        ),
      );
      return;
    }

    // Normal biometric flow for mobile
    if (_attemptCount >= AppConstants.maxBiometricAttempts) {
      _showError(AppConstants.errorMaxBiometricAttempts);
      return;
    }

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: AppConstants.infoBiometricRequired,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!mounted) return;

      if (authenticated) {
        // Success - Navigate to party list
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PartyListScreen(),
          ),
        );
      } else {
        setState(() {
          _attemptCount++;
        });

        if (_attemptCount >= AppConstants.maxBiometricAttempts) {
          _showError(AppConstants.errorMaxBiometricAttempts);
        } else {
          _showError(
            '${AppConstants.errorBiometricFailed}\n${AppConstants.maxBiometricAttempts - _attemptCount} attempts remaining',
          );
        }
      }
    } catch (e) {
      setState(() {
        _attemptCount++;
      });
      _showError('Authentication error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
              Color(0xFF01579B),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Fingerprint Icon with Pulse Animation
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fingerprint_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Title
                const Text(
                  'Biometric Authentication',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  kIsWeb
                      ? 'Click the button below to continue\n(Web Demo Mode - No biometric required)'
                      : 'Place your finger on the sensor\nto authenticate and continue',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Authenticate Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isAuthenticating ||
                            _attemptCount >= AppConstants.maxBiometricAttempts
                        ? null
                        : _authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: Colors.white.withOpacity(0.5),
                    ),
                    child: _isAuthenticating
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fingerprint_rounded,
                                size: 24,
                                color: _attemptCount >=
                                        AppConstants.maxBiometricAttempts
                                    ? Colors.grey
                                    : AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _attemptCount >= AppConstants.maxBiometricAttempts
                                    ? 'Too Many Attempts'
                                    : 'Authenticate Now',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Attempt Counter
                if (_attemptCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _attemptCount >= AppConstants.maxBiometricAttempts
                          ? AppTheme.errorColor.withOpacity(0.2)
                          : AppTheme.warningColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$_attemptCount/${AppConstants.maxBiometricAttempts} attempts used',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Security Info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.security_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your biometric data is processed locally\nand never stored on our servers',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
