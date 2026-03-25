# TN 2026 Voting System - Visual Architecture

## 🎯 Application Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                     TN 2026 VOTING SYSTEM                        │
│                    Secure Digital Voting                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  SPLASH SCREEN   │
                    │  (App Startup)   │
                    └──────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    AUTHENTICATION FLOW                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────┐      ┌─────────────────┐     ┌───────────┐ │
│  │ Phone Login    │  →   │ OTP Verify      │  →  │ Biometric │ │
│  │ • Enter phone  │      │ • 6-digit OTP   │     │ • Finger  │ │
│  │ • Validation   │      │ • 2-min timer   │     │ • Face ID │ │
│  │ • Send OTP     │      │ • Resend option │     │ • 3 tries │ │
│  └────────────────┘      └─────────────────┘     └───────────┘ │
│         │                        │                      │        │
│         └────────────────────────┴──────────────────────┘        │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       VOTING FLOW                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────┐      ┌─────────────────┐     ┌───────────┐ │
│  │ Party List     │  →   │ Confirm Vote    │  →  │ Thank You │ │
│  │ • 8 Parties    │      │ • Party details │     │ • Confetti│ │
│  │ • Leader photo │      │ • Warning msg   │     │ • Success │ │
│  │ • Symbol+Flag  │      │ • Confirm/Back  │     │ • Lock    │ │
│  └────────────────┘      └─────────────────┘     └───────────┘ │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 🏗️ Clean Architecture Layers

```
┌────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                        SCREENS                            │  │
│  │  • PhoneLoginScreen    • BiometricAuthScreen             │  │
│  │  • OTPVerificationScreen  • PartyListScreen              │  │
│  │  • VoteConfirmationScreen • ThankYouScreen               │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    STATE MANAGEMENT                       │  │
│  │                   (Riverpod Providers)                    │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                       ENTITIES                            │  │
│  │  • Voter (id, phone, hasVoted, deviceId)                 │  │
│  │  • Party (name, leader, symbol, flag)                    │  │
│  │  • Vote (partyId, timestamp, encryptedData)              │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                     REPOSITORIES                          │  │
│  │  (Interfaces for data operations)                        │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                        MODELS                             │  │
│  │  • VoterModel (extends Voter + JSON)                     │  │
│  │  • PartyModel (extends Party + JSON)                     │  │
│  │  • VoteModel (extends Vote + JSON)                       │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                     DATA SOURCES                          │  │
│  │  • PartyData (sample TN parties)                         │  │
│  │  • Firebase Firestore (backend - ready)                  │  │
│  │  • Firebase Storage (images - ready)                     │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                       CORE UTILITIES                            │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ • EncryptionService (AES-256)                            │  │
│  │ • BiometricService (local_auth + attempts)               │  │
│  │ • Validators (phone, OTP)                                │  │
│  │ • AppConstants (all config)                              │  │
│  │ • AppTheme (Material 3)                                  │  │
│  │ • Failures (error handling)                              │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

## 🔐 Security Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                    SECURITY LAYERS                              │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Layer 1: AUTHENTICATION                                        │
│  ├─ Phone OTP (Firebase Auth)                                  │
│  ├─ 2-minute expiry, 3 attempts max                            │
│  └─ Rate limiting (Firebase Functions)                         │
│                                                                 │
│  Layer 2: BIOMETRIC                                             │
│  ├─ Local device biometric (fingerprint/Face ID)               │
│  ├─ 3 attempts max, 5-minute lock                              │
│  └─ No biometric data sent to server                           │
│                                                                 │
│  Layer 3: DEVICE BINDING                                        │
│  ├─ Unique device_id per voter                                 │
│  ├─ Stored in secure storage                                   │
│  └─ One device per voter enforcement                           │
│                                                                 │
│  Layer 4: ENCRYPTION                                            │
│  ├─ AES-256 vote encryption                                    │
│  ├─ Keys in flutter_secure_storage                             │
│  └─ Encrypted before transmission                              │
│                                                                 │
│  Layer 5: ANONYMITY                                             │
│  ├─ No voter_id in votes collection                            │
│  ├─ Only party_id + encrypted_data                             │
│  └─ Zero-knowledge vote storage                                │
│                                                                 │
│  Layer 6: AUDIT                                                 │
│  ├─ All actions logged (no PII)                                │
│  ├─ Timestamp + action + device_info                           │
│  └─ Admin-only access                                          │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

## 🗄️ Database Schema (Firestore)

```
┌─────────────────────────────────────────────────────────────┐
│                     FIRESTORE COLLECTIONS                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📁 voters/                                                  │
│  ├─ {voter_id}                                              │
│  │  ├─ id: "uuid"                                           │
│  │  ├─ mobile_number: "+919876543210"                      │
│  │  ├─ has_voted: false                                     │
│  │  ├─ device_id: "unique-device-id"                       │
│  │  ├─ created_at: Timestamp                                │
│  │  └─ last_login: Timestamp                                │
│  │                                                           │
│  📁 parties/                                                 │
│  ├─ {party_id}                                              │
│  │  ├─ id: "uuid"                                           │
│  │  ├─ name: "DMK"                                          │
│  │  ├─ leader_name: "M. K. Stalin"                         │
│  │  ├─ leader_image_url: "gs://..."                        │
│  │  ├─ symbol_url: "gs://..."                              │
│  │  ├─ flag_url: "gs://..."                                │
│  │  ├─ is_active: true                                      │
│  │  └─ order: 1                                             │
│  │                                                           │
│  📁 votes/                        ⚠️ NO VOTER LINKAGE        │
│  ├─ {vote_id}                                               │
│  │  ├─ id: "uuid"                                           │
│  │  ├─ party_id: "party-uuid"    ✅ Only party, no voter   │
│  │  ├─ timestamp: Timestamp                                 │
│  │  └─ encrypted_data: "aes256..."                         │
│  │                                                           │
│  📁 audit_logs/                   🔒 Admin Only              │
│  ├─ {log_id}                                                │
│  │  ├─ action: "vote_submitted"                            │
│  │  ├─ timestamp: Timestamp                                 │
│  │  ├─ ip_address: "x.x.x.x"                               │
│  │  └─ device_info: "Android 13"                           │
│  │                                                           │
└─────────────────────────────────────────────────────────────┘
```

## 📦 Dependencies Map

```
┌────────────────────────────────────────────────────────────────┐
│                     PACKAGE ECOSYSTEM                           │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  STATE MANAGEMENT                                               │
│  ├─ flutter_riverpod (state)                                   │
│  ├─ riverpod_annotation (code gen)                             │
│  └─ riverpod_generator (build)                                 │
│                                                                 │
│  BACKEND (Firebase)                                             │
│  ├─ firebase_core       ┐                                      │
│  ├─ firebase_auth       │ Authentication                       │
│  ├─ cloud_firestore     │ Database                             │
│  ├─ firebase_storage    │ File storage                         │
│  └─ cloud_functions     ┘ Server logic                         │
│                                                                 │
│  SECURITY                                                       │
│  ├─ local_auth                  (biometric)                    │
│  ├─ flutter_secure_storage      (encrypted storage)            │
│  ├─ encrypt                     (AES-256)                      │
│  ├─ safe_device                 (root detection)               │
│  └─ flutter_jailbreak_detection (jailbreak check)              │
│                                                                 │
│  UI/UX                                                          │
│  ├─ cached_network_image  (image caching)                      │
│  ├─ confetti              (celebration)                        │
│  ├─ flutter_svg           (SVG support)                        │
│  └─ fl_chart              (analytics charts)                   │
│                                                                 │
│  UTILITIES                                                      │
│  ├─ uuid                (unique IDs)                           │
│  ├─ device_info_plus    (device details)                       │
│  ├─ intl                (internationalization)                 │
│  ├─ equatable           (value equality)                       │
│  ├─ dartz               (functional programming)               │
│  └─ dio                 (HTTP client)                          │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

## 🎨 UI Component Tree

```
MaterialApp
│
└─ PhoneLoginScreen
   │
   ├─ [User enters phone]
   │
   ├─ OTPVerificationScreen
   │  │
   │  ├─ [6 OTP input fields]
   │  ├─ [Countdown timer]
   │  └─ [Resend button]
   │  │
   │  └─ BiometricAuthScreen
   │     │
   │     ├─ [Fingerprint icon (pulsing)]
   │     └─ [Authenticate button]
   │     │
   │     └─ PartyListScreen
   │        │
   │        ├─ Header
   │        │  ├─ Icon
   │        │  ├─ Title
   │        │  └─ Info banner
   │        │
   │        └─ ListView
   │           └─ PartyCard (x8)
   │              ├─ Leader image
   │              ├─ Party name
   │              ├─ Leader name
   │              ├─ Symbol image
   │              ├─ Flag image
   │              └─ Vote button
   │              │
   │              └─ VoteConfirmationScreen
   │                 │
   │                 ├─ Warning icon
   │                 ├─ Info message
   │                 ├─ Party details card
   │                 ├─ Confirm button
   │                 └─ Cancel button
   │                 │
   │                 └─ ThankYouScreen
   │                    │
   │                    ├─ Confetti 🎉
   │                    ├─ Success icon
   │                    ├─ Thank you message
   │                    ├─ Info cards (3)
   │                    └─ Exit button
```

## 🔄 State Flow (Riverpod)

```
┌────────────────────────────────────────────────────────────────┐
│                      STATE MANAGEMENT FLOW                      │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  User Action → Provider → Repository → Data Source → State     │
│                                                                 │
│  Example: Vote Submission                                       │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ 1. User taps "Confirm & Submit"                          │  │
│  │    ↓                                                      │  │
│  │ 2. VotingProvider.submitVote()                           │  │
│  │    ↓                                                      │  │
│  │ 3. EncryptionService.encryptVote()                       │  │
│  │    ↓                                                      │  │
│  │ 4. VotingRepository.submitVote()                         │  │
│  │    ↓                                                      │  │
│  │ 5. FirestoreDataSource.createVote()                      │  │
│  │    ↓                                                      │  │
│  │ 6. VoterRepository.markAsVoted()                         │  │
│  │    ↓                                                      │  │
│  │ 7. Update UI state → Navigate to ThankYouScreen          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

**This visual architecture provides a clear overview of the entire system!** 🎨📐

For implementation details, see:
- `README.md` - Main documentation
- `QUICKSTART.md` - Getting started guide
- `FIREBASE_SETUP.md` - Backend setup
- `IMPLEMENTATION_PLAN.md` - Detailed plan
- `PROJECT_SUMMARY.md` - Feature summary
