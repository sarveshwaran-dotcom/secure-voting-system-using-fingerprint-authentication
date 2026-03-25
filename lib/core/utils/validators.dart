import '../constants/app_constants.dart';

class Validators {
  // Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }

    // Remove any whitespace and special characters
    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length != AppConstants.phoneNumberLength) {
      return AppConstants.errorInvalidPhone;
    }

    if (!RegExp(AppConstants.phoneNumberPattern).hasMatch(cleanedValue)) {
      return AppConstants.errorInvalidPhone;
    }

    return null;
  }

  // Validate OTP
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }

    if (value.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }

    if (!RegExp(AppConstants.otpPattern).hasMatch(value)) {
      return 'OTP must contain only numbers';
    }

    return null;
  }

  // Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.length == 10) {
      return '${AppConstants.phoneNumberPrefix} ${cleaned.substring(0, 5)} ${cleaned.substring(5)}';
    }
    
    return phoneNumber;
  }

  // Clean phone number (remove formatting)
  static String cleanPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  }

  // Get full phone number with country code
  static String getFullPhoneNumber(String phoneNumber) {
    final cleaned = cleanPhoneNumber(phoneNumber);
    return '${AppConstants.phoneNumberPrefix}$cleaned';
  }

  // Validate name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (value.length > 100) {
      return 'Name must be less than 100 characters';
    }

    return null;
  }

  // Sanitize input
  static String sanitizeInput(String input) {
    return input.trim();
  }
}
