class AppConstants {
  // App Info
  static const String appName = 'TN 2026 Secure Voting';
  static const String appVersion = '1.0.0';
  
  // Authentication
  static const int otpLength = 6;
  static const int otpExpiryMinutes = 2;
  static const int maxOtpAttempts = 3;
  static const int maxBiometricAttempts = 3;
  static const int biometricLockMinutes = 5;
  
  // Phone Number
  static const String phoneNumberPrefix = '+91';
  static const int phoneNumberLength = 10;
  
  // API Timeouts
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30; // seconds
  
  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyHasVoted = 'has_voted';
  static const String storageKeyDeviceId = 'device_id';
  static const String storageKeyBiometricEnabled = 'biometric_enabled';
  
  // Firestore Collections
  static const String collectionVoters = 'voters';
  static const String collectionParties = 'parties';
  static const String collectionVotes = 'votes';
  static const String collectionAuditLogs = 'audit_logs';
  static const String collectionAdmins = 'admins';
  
  // Error Messages
  static const String errorNoInternet = 'No internet connection. Please check your network.';
  static const String errorServerError = 'Server error. Please try again later.';
  static const String errorInvalidOtp = 'Invalid OTP. Please try again.';
  static const String errorOtpExpired = 'OTP has expired. Please request a new one.';
  static const String errorMaxOtpAttempts = 'Maximum OTP attempts exceeded. Please try again later.';
  static const String errorBiometricFailed = 'Biometric authentication failed.';
  static const String errorMaxBiometricAttempts = 'Too many failed attempts. Please try again in 5 minutes.';
  static const String errorAlreadyVoted = 'You have already cast your vote.';
  static const String errorInvalidPhone = 'Please enter a valid 10-digit mobile number.';
  static const String errorBiometricNotAvailable = 'Biometric authentication is not available on this device.';
  static const String errorRootDetected = 'This app cannot run on rooted/jailbroken devices.';
  
  // Success Messages
  static const String successOtpSent = 'OTP sent successfully to your mobile number.';
  static const String successVoteSubmitted = 'Your vote has been submitted successfully!';
  static const String successLogout = 'Logged out successfully.';
  
  // Info Messages
  static const String infoEnterPhone = 'Enter your registered mobile number to continue.';
  static const String infoEnterOtp = 'Enter the 6-digit OTP sent to your mobile number.';
  static const String infoBiometricRequired = 'Please authenticate using your fingerprint to proceed.';
  static const String infoSelectParty = 'Select the party you want to vote for.';
  static const String infoConfirmVote = 'Are you sure you want to vote for this party? This action cannot be undone.';
  static const String infoVotingComplete = 'Thank you for exercising your democratic right!';
  
  // Encryption
  static const String encryptionKeyPrefix = 'TN2026_VOTE_';
  
  // Admin
  static const String adminRole = 'admin';
  static const String voterRole = 'voter';
  
  // Vote Status
  static const String voteStatusPending = 'pending';
  static const String voteStatusSubmitted = 'submitted';
  static const String voteStatusVerified = 'verified';
  
  // Regex Patterns
  static const String phoneNumberPattern = r'^[0-9]{10}$';
  static const String otpPattern = r'^[0-9]{6}$';
}
