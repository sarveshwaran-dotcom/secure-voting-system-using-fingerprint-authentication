# TN 2026 Secure Digital Voting System

A secure, biometric-enabled mobile voting simulation system built with Flutter and Firebase for Tamil Nadu elections.

![Flutter](https://img.shields.io/badge/Flutter-3.11+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 🎯 Features

### ✅ Authentication & Security
- **Mobile OTP Verification** - Firebase Auth with SMS OTP
- **Biometric Authentication** - Fingerprint/Face ID verification
- **Device Binding** - One device per voter
- **AES-256 Encryption** - End-to-end vote encryption
- **Rate Limiting** - Protection against OTP abuse
- **Root/Jailbreak Detection** - Security validation

### 🗳️ Voting System
- **Party Listing** - Display all Tamil Nadu parties with:
  - Leader photos
  - Party symbols
  - Party flags
  - Vote buttons
- **Vote Confirmation** - Clear confirmation dialog
- **One-Time Voting** - Strict enforcement of one vote per person
- **Anonymous Voting** - No voter-vote linkage stored
- **Vote Lock** - Permanent lock after vote submission

### 🎨 Beautiful UI/UX
- **Material 3 Design** - Modern, clean interface
- **Gradient Backgrounds** - Premium visual appeal
- **Smooth Animations** - Fade, slide, and pulse effects
- **Confetti Celebration** - Success animation after voting
- **Responsive Layout** - Works on all screen sizes

## 🏗️ Architecture

### Clean Architecture
```
lib/
├── core/                    # Core utilities
│   ├── constants/           # App constants
│   ├── theme/               # Theme configuration
│   ├── utils/               # Helper utilities
│   └── errors/              # Error handling
├── features/
│   ├── auth/                # Authentication feature
│   │   ├── domain/          # Entities & repositories
│   │   ├── data/            # Models & data sources
│   │   └── presentation/    # UI & state management
│   ├── voting/              # Voting feature
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   └── admin/               # Admin dashboard
│       ├── domain/
│       ├── data/
│       └── presentation/
└── main.dart
```

### Tech Stack
- **Frontend**: Flutter 3.11+
- **State Management**: Riverpod
- **Backend**: Firebase
  - Firebase Auth (OTP)
  - Cloud Firestore (Database)
  - Firebase Storage (Images)
  - Cloud Functions (Validation)
- **Security**: 
  - local_auth (Biometric)
  - flutter_secure_storage
  - encrypt (AES-256)
  - safe_device (Root detection)

## 🚀 Getting Started

### Prerequisites
- Flutter 3.11 or higher
- Dart 3.0 or higher
- Firebase account
- Android Studio / VS Code
- Android device with biometric sensor (for testing)

### Installation

1. **Install dependencies**
```bash
flutter pub get
```

2. **Firebase Setup** (See FIREBASE_SETUP.md for detailed instructions)

3. **Run the app**
```bash
flutter run
```

## 🔐 Security Features

### Authentication
- ✅ OTP verification (2-minute expiry)
- ✅ Maximum 3 OTP attempts
- ✅ Biometric verification required
- ✅ Maximum 3 biometric attempts
- ✅ 5-minute lock after failed attempts
- ✅ Device binding per voter

### Encryption
- ✅ AES-256 vote encryption
- ✅ Secure key storage
- ✅ No plaintext vote data
- ✅ HTTPS-only communication

### Privacy
- ✅ No voter-vote linkage
- ✅ Biometric processed locally
- ✅ Anonymous vote storage
- ✅ Zero-knowledge architecture

## ⚠️ Disclaimer

**This is a SIMULATION system for educational and demonstration purposes only.**

For actual election use:
- Legal compliance is required
- Election Commission approval needed
- Professional security audit mandatory
- Data protection laws must be followed
- Accessibility standards required

---

**Built with ❤️ for democracy in Tamil Nadu**
