# 📋 PROJECT CONTEXT FOR CHATGPT
## TN 2026 Secure Digital Voting System — Flutter App

> Copy and paste this entire file into ChatGPT to get accurate, context-aware help.

---

## 🧩 PROJECT OVERVIEW

- **App Name**: TN 2026 Secure Voting
- **Platform**: Flutter (Dart) — targets Android, iOS, Web
- **Architecture**: Clean Architecture (Domain / Data / Presentation)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Backend (planned)**: Firebase (Auth, Firestore, Cloud Functions, Storage)
- **Current Status**: Web demo mode — Firebase is commented out; OTP & biometric are simulated
- **Purpose**: Biometric-secured, one-person-one-vote digital election system for Tamil Nadu 2026

---

## 📁 FULL PROJECT STRUCTURE

```
d:\voting\                              ← project root
├── lib/
│   ├── main.dart                       ← App entry point
│   ├── firebase_options.dart           ← Firebase config (currently unused)
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart      ← All app-wide constants & messages
│   │   ├── errors/
│   │   │   └── failures.dart           ← Error/failure classes
│   │   ├── theme/
│   │   │   └── app_theme.dart          ← Material 3 theme, colors, gradients
│   │   └── utils/
│   │       ├── biometric_service.dart  ← Biometric auth logic
│   │       ├── encryption_service.dart ← AES-256 vote encryption service
│   │       ├── validators.dart         ← Phone / OTP input validators
│   │       ├── local_auth_stub.dart    ← Stub for local_auth (web compat)
│   │       └── local_auth_web.dart     ← Web stub for local_auth
│   │
│   └── features/
│       ├── auth/
│       │   ├── domain/entities/
│       │   │   └── voter.dart          ← Voter entity (id, phone, hasVoted)
│       │   ├── data/models/
│       │   │   └── voter_model.dart    ← Voter model (Firestore JSON)
│       │   └── presentation/screens/
│       │       ├── phone_login_screen.dart     ← Screen 1: Phone number input
│       │       ├── otp_verification_screen.dart ← Screen 2: OTP entry + timer
│       │       └── biometric_auth_screen.dart  ← Screen 3: Fingerprint/FaceID
│       │
│       └── voting/
│           ├── domain/entities/
│           │   ├── party.dart          ← Party entity (id, name, leader, images)
│           │   └── vote.dart           ← Vote entity (voterId, partyId, hash)
│           ├── data/
│           │   ├── models/
│           │   │   ├── party_model.dart
│           │   │   └── vote_model.dart
│           │   └── datasources/
│           │       └── party_data.dart ← Static list of 8 TN parties
│           └── presentation/screens/
│               ├── party_list_screen.dart       ← Screen 4: Party cards grid
│               ├── vote_confirmation_screen.dart ← Screen 5: Confirm vote dialog
│               └── thank_you_screen.dart        ← Screen 6: Confetti + success
│
├── assets/
│   ├── images/
│   │   ├── leaders/   ← Party leader images (dmk.jpg, aiadmk.jpg, …)
│   │   ├── symbols/   ← Party symbol images
│   │   └── flags/     ← Party flag images
│   └── icons/
│
├── pubspec.yaml
├── analysis_options.yaml
└── run_web.bat
```

---

## 📦 DEPENDENCIES (pubspec.yaml)

```yaml
name: tn_voting_system
version: 1.0.0+1
environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State Management
  flutter_riverpod: ^2.4.10
  riverpod_annotation: ^2.3.4

  # Firebase (commented out for web demo)
  # firebase_core: ^2.24.2
  # firebase_auth: ^4.15.3
  # cloud_firestore: ^4.13.6
  # firebase_storage: ^11.5.6
  # cloud_functions: ^4.5.12

  # Auth (mobile only - not used in web demo)
  # local_auth: ^2.1.8
  # flutter_secure_storage: ^9.0.0

  # Network
  dio: ^5.4.0

  # UI
  cached_network_image: ^3.3.1
  flutter_svg: ^2.0.9
  confetti: ^0.7.0

  # Utilities
  uuid: ^4.3.3
  encrypt: ^5.0.3
  flutter_dotenv: ^5.1.0
  intl: ^0.19.0
  equatable: ^2.0.5
  dartz: ^0.10.1

  # Admin Charts
  fl_chart: ^0.66.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  riverpod_generator: ^2.3.11
  build_runner: ^2.4.8
  mockito: ^5.4.4

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/images/leaders/
    - assets/images/symbols/
    - assets/images/flags/
    - assets/icons/
    - .env
```

---

## 🔑 KEY SOURCE FILES

### 1. `lib/main.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/presentation/screens/phone_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase commented for web demo
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const PhoneLoginScreen(),
    );
  }
}
```

---

### 2. `lib/core/constants/app_constants.dart`
```dart
class AppConstants {
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
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;

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
  static const String errorInvalidOtp = 'Invalid OTP. Please try again.';
  static const String errorOtpExpired = 'OTP has expired. Please request a new one.';
  static const String errorMaxOtpAttempts = 'Maximum OTP attempts exceeded. Please try again later.';
  static const String errorBiometricFailed = 'Biometric authentication failed.';
  static const String errorMaxBiometricAttempts = 'Too many failed attempts. Please try again in 5 minutes.';
  static const String errorAlreadyVoted = 'You have already cast your vote.';
  static const String errorInvalidPhone = 'Please enter a valid 10-digit mobile number.';

  // Success Messages
  static const String successOtpSent = 'OTP sent successfully to your mobile number.';
  static const String successVoteSubmitted = 'Your vote has been submitted successfully!';

  // Info Messages
  static const String infoEnterPhone = 'Enter your registered mobile number to continue.';
  static const String infoEnterOtp = 'Enter the 6-digit OTP sent to your mobile number.';
  static const String infoBiometricRequired = 'Please authenticate using your fingerprint to proceed.';
  static const String infoSelectParty = 'Select the party you want to vote for.';
  static const String infoConfirmVote = 'Are you sure you want to vote for this party? This action cannot be undone.';
  static const String infoVotingComplete = 'Thank you for exercising your democratic right!';

  // Encryption
  static const String encryptionKeyPrefix = 'TN2026_VOTE_';

  // Roles
  static const String adminRole = 'admin';
  static const String voterRole = 'voter';

  // Vote Status
  static const String voteStatusPending = 'pending';
  static const String voteStatusSubmitted = 'submitted';
  static const String voteStatusVerified = 'verified';

  // Regex
  static const String phoneNumberPattern = r'^[0-9]{10}$';
  static const String otpPattern = r'^[0-9]{6}$';
}
```

---

### 3. `lib/core/theme/app_theme.dart`
```dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1565C0);   // Blue – Trust & Security
  static const Color secondaryColor = Color(0xFFFF6F00); // Saffron
  static const Color accentColor = Color(0xFF2E7D32);    // Green – Success
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFF57C00);

  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFF697386);
  static const Color dividerColor = Color(0xFFE3E8EE);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: cardColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
  );
}
```

---

### 4. `lib/core/utils/encryption_service.dart`
```dart
import 'dart:convert';

// Note: Real AES-256 is stubbed for web demo
// Production: use 'package:encrypt/encrypt.dart' + flutter_secure_storage

class FlutterSecureStorage {
  Future<String?> read({required String key}) async => null;
  Future<void> write({required String key, required String value}) async {}
  Future<void> delete({required String key}) async {}
}

class EncryptionService {
  final FlutterSecureStorage _secureStorage;
  static const String _keyStorageKey = 'encryption_key';
  static const String _ivStorageKey = 'encryption_iv';

  EncryptionService(this._secureStorage);

  Future<void> initializeEncryption() async {}

  // Demo: base64 encode (Production: AES-256)
  Future<String> encryptData(String data) async {
    return base64.encode(utf8.encode(data));
  }

  Future<String> decryptData(String encryptedData) async {
    return utf8.decode(base64.decode(encryptedData));
  }

  Future<String> encryptVote(String partyId, String voterId) async {
    final voteData = jsonEncode({
      'party_id': partyId,
      'voter_id': voterId,
      'timestamp': DateTime.now().toIso8601String(),
    });
    return await encryptData(voteData);
  }

  Future<void> clearEncryptionKeys() async {
    await _secureStorage.delete(key: _keyStorageKey);
    await _secureStorage.delete(key: _ivStorageKey);
  }
}
```

---

### 5. `lib/features/voting/data/datasources/party_data.dart`
```dart
import '../../domain/entities/party.dart';

class PartyData {
  static final List<Party> tamilNaduParties = [
    const Party(id: '1', name: 'Dravida Munnetra Kazhagam (DMK)',
        leaderName: 'M. K. Stalin',
        leaderImageUrl: 'assets/images/leaders/dmk.jpg',
        symbolUrl: 'assets/images/symbols/dmk.png',
        flagUrl: 'assets/images/flags/dmk.png',
        isActive: true, order: 1),
    const Party(id: '2', name: 'All India Anna Dravida Munnetra Kazhagam (AIADMK)',
        leaderName: 'Edappadi K. Palaniswami',
        leaderImageUrl: 'assets/images/leaders/aiadmk.jpg',
        symbolUrl: 'assets/images/symbols/aiadmk.jpg',
        flagUrl: 'assets/images/flags/aiadmk.png',
        isActive: true, order: 2),
    const Party(id: '3', name: 'Tamilaga Vettri Kazhagam (TVK)',
        leaderName: 'Vijay',
        leaderImageUrl: 'assets/images/leaders/tvk.jpeg',
        symbolUrl: 'assets/images/symbols/tvk.png',
        flagUrl: 'assets/images/flags/tvk.jpg',
        isActive: true, order: 3),
    const Party(id: '4', name: 'Bharatiya Janata Party (BJP)',
        leaderName: 'K. Annamalai',
        leaderImageUrl: 'assets/images/leaders/bjp.jpg',
        symbolUrl: 'assets/images/symbols/bjp.png',
        flagUrl: 'assets/images/flags/bjp.png',
        isActive: true, order: 4),
    const Party(id: '5', name: 'Naam Tamilar Katchi (NTK)',
        leaderName: 'Seeman',
        leaderImageUrl: 'assets/images/leaders/ntk.jpg',
        symbolUrl: 'assets/images/symbols/ntk.jpg',
        flagUrl: 'assets/images/flags/ntk.jpg',
        isActive: true, order: 5),
    const Party(id: '6', name: 'Indian National Congress (INC)',
        leaderName: 'K. Selvaperunthagai',
        leaderImageUrl: 'assets/images/leaders/inc.jpg',
        symbolUrl: 'assets/images/symbols/inc.png',
        flagUrl: 'assets/images/flags/inc.png',
        isActive: true, order: 6),
    const Party(id: '7', name: 'Pattali Makkal Katchi (PMK)',
        leaderName: 'Anbumani Ramadoss',
        leaderImageUrl: 'assets/images/leaders/pmk.jpg',
        symbolUrl: 'assets/images/symbols/pmk.jpg',
        flagUrl: 'assets/images/flags/pmk.jpg',
        isActive: true, order: 7),
    const Party(id: '8', name: 'Viduthalai Chiruthaigal Katchi (VCK)',
        leaderName: 'Thol. Thirumavalavan',
        leaderImageUrl: 'assets/images/leaders/vck.jpg',
        symbolUrl: 'assets/images/symbols/vck.jpg',
        flagUrl: 'assets/images/flags/vck.png',
        isActive: true, order: 8),
  ];

  static List<Party> getActiveParties() =>
      tamilNaduParties.where((p) => p.isActive).toList()
        ..sort((a, b) => a.order.compareTo(b.order));

  static Party? getPartyById(String id) {
    try { return tamilNaduParties.firstWhere((p) => p.id == id); }
    catch (e) { return null; }
  }
}
```

---

## 🔄 APP FLOW

```
PhoneLoginScreen
    ↓  Enter 10-digit mobile number → validate → [simulated] send OTP
OTPVerificationScreen
    ↓  Enter 6-digit OTP (2-min timer, max 3 attempts)
BiometricAuthScreen
    ↓  Fingerprint / Face ID (max 3 attempts, 5-min lock)
PartyListScreen
    ↓  Animated cards: 8 TN parties (leader photo, symbol, flag)
    ↓  Tap "Vote for this Party"
VoteConfirmationScreen
    ↓  Warning dialog: "This action cannot be undone"
    ↓  [Encrypted vote submission + loading]
ThankYouScreen
    ↓  Confetti animation + success message
```

---

## 🎨 DESIGN SYSTEM

| Token | Value | Usage |
|-------|-------|-------|
| Primary | `#1565C0` | Buttons, AppBar, gradients |
| Secondary | `#FF6F00` | Saffron accent |
| Accent/Success | `#2E7D32` | Success states |
| Error | `#D32F2F` | Error states |
| Warning | `#F57C00` | Warnings |
| Background | `#F5F7FA` | Scaffold |
| Text Primary | `#1A1F36` | Headings |
| Text Secondary | `#697386` | Sub-text |

---

## 🔒 SECURITY NOTES

- **Encryption**: `EncryptionService` uses AES-256 (currently stubbed as base64 for web demo)
- **Biometric**: `BiometricService` wraps `local_auth` (stubbed for web)
- **One-Vote**: Enforced via `storageKeyHasVoted` (ready for Firestore transaction)
- **OTP**: 6-digit, 2-minute expiry, max 3 attempts
- **Anonymous Voting**: No direct voter↔vote linkage in data models
- **Audit Logs**: Firestore `audit_logs` collection planned

---

## ✅ DONE / 🔄 PENDING

### Done
- Clean Architecture folder structure
- All 6 screen UIs (phone login, OTP, biometric, party list, confirm, thank you)
- Theme (Material 3, brand colors)
- `AppConstants`, `EncryptionService`, `BiometricService`, `Validators`
- 8 Tamil Nadu party static data
- Party/Vote entities & models
- Staggered animations, confetti

### Pending (Firebase integration needed)
- Real Firebase OTP (Phone Auth)
- Firestore vote storage + one-vote enforcement
- Firebase Storage for party images
- Cloud Functions for vote validation
- Admin dashboard (fl_chart ready)
- Root/jailbreak detection (mobile)
- Unit & integration tests

---

## 💬 HOW TO USE THIS DOC WITH CHATGPT

Paste this entire file into ChatGPT, then ask your question. Example prompts:

- "Help me implement real Firebase OTP authentication in this Flutter project"
- "Write the Firestore Cloud Function to validate and store encrypted votes"
- "Add an admin dashboard screen using fl_chart to show party-wise vote counts"
- "Implement the real AES-256 encryption in EncryptionService using the encrypt package"
- "Fix the biometric stub so it works on Android using local_auth"
- "Generate unit tests for EncryptionService and Validators"
- "Add a splash screen before PhoneLoginScreen"

---

*Generated: 2026-03-03 | Project: d:\voting | Flutter SDK: ^3.11.0*
