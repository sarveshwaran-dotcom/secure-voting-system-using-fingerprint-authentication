# Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `TN Voting System 2026`
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Add Android App

1. In Firebase Console, click "Add app" and select Android
2. Enter package name: `com.tn2026.tn_voting_system`
3. Enter app nickname: `TN Voting Android`
4. Leave SHA-1 empty for now (add later for production)
5. Click "Register app"
6. Download `google-services.json`
7. Place the file in: `android/app/google-services.json`

## Step 3: Enable Authentication

1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Phone" authentication
5. For testing, add test phone numbers:
   - Phone: `+919876543210`, Code: `123456`
   - Phone: `+919876543211`, Code: `123456`

## Step 4: Create Firestore Database

1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Select "Start in production mode"
4. Choose location: `asia-south1` (India)
5. Click "Enable"

### Create Collections

Create these collections manually or they will be created automatically:

#### 1. voters
```
Document ID: Auto-generated
Fields:
  - mobile_number: string
  - has_voted: boolean
  - device_id: string
  - created_at: timestamp
  - last_login: timestamp
```

#### 2. parties
```
Document ID: Auto-generated
Fields:
  - name: string
  - leader_name: string
  - leader_image_url: string
  - symbol_url: string
  - flag_url: string
  - is_active: boolean
  - order: number
```

#### 3. votes
```
Document ID: Auto-generated
Fields:
  - party_id: string
  - timestamp: timestamp
  - encrypted_data: string
```

#### 4. audit_logs
```
Document ID: Auto-generated
Fields:
  - action: string
  - timestamp: timestamp
  - ip_address: string
  - device_info: string
```

### Set Firestore Security Rules

Go to "Rules" tab and paste:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Voters collection
    match /voters/{voterId} {
      allow read: if request.auth != null && request.auth.uid == voterId;
      allow create: if request.auth != null;
      allow update: if request.auth != null && request.auth.uid == voterId;
    }
    
    // Parties collection - read-only
    match /parties/{partyId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    
    // Votes collection - write-only
    match /votes/{voteId} {
      allow read: if false;
      allow create: if request.auth != null;
    }
    
    // Audit logs
    match /audit_logs/{logId} {
      allow read, write: if request.auth.token.admin == true;
    }
  }
}
```

## Step 5: Enable Firebase Storage

1. In Firebase Console, go to "Storage"
2. Click "Get started"
3. Start in production mode
4. Choose location: `asia-south1`
5. Click "Done"

### Create Folders

Create these folders in Storage:
- `party_leaders/`
- `party_symbols/`
- `party_flags/`

### Set Storage Security Rules

Go to "Rules" tab and paste:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /party_leaders/{imageId} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }
    
    match /party_symbols/{imageId} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }
    
    match /party_flags/{imageId} {
      allow read: if request.auth != null;
      allow write: if request.auth.token.admin == true;
    }
  }
}
```

## Step 6: Sample Party Data

Upload sample party images to Storage and create party documents in Firestore:

### Example Party Document

```json
{
  "id": "dmk_001",
  "name": "Dravida Munnetra Kazhagam (DMK)",
  "leader_name": "M. K. Stalin",
  "leader_image_url": "https://firebasestorage.googleapis.com/.../party_leaders/stalin.jpg",
  "symbol_url": "https://firebasestorage.googleapis.com/.../party_symbols/rising_sun.png",
  "flag_url": "https://firebasestorage.googleapis.com/.../party_flags/dmk_flag.png",
  "is_active": true,
  "order": 1
}
```

## Step 7: Configure FlutterFire CLI

1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Configure Firebase for Flutter:
```bash
flutterfire configure
```

3. Select your Firebase project
4. Select platforms (Android, iOS)
5. This will create `firebase_options.dart` automatically

## Step 8: Android Configuration

### Update `android/build.gradle`

Add Google Services plugin:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

### Update `android/app/build.gradle`

Apply the plugin at the bottom:

```gradle
apply plugin: 'com.google.gms.google-services'
```

## Step 9: Permissions

### Android Permissions (`android/app/src/main/AndroidManifest.xml`)

Add these permissions:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

### iOS Permissions (`ios/Runner/Info.plist`)

Add these keys:

```xml
<key>NSFaceIDUsageDescription</key>
<string>We need Face ID to verify your identity before voting</string>
```

## Step 10: Test the Setup

1. Run the app:
```bash
flutter run
```

2. Try phone authentication
3. Test biometric authentication
4. Verify Firestore writes

## Troubleshooting

### Issue: "firebase_core not initialized"
**Solution**: Make sure you called `Firebase.initializeApp()` in `main()`

### Issue: "google-services.json not found"
**Solution**: Ensure the file is in `android/app/` directory

### Issue: Phone authentication not working
**Solution**: 
- Enable Phone auth in Firebase Console
- Add test phone numbers for development
- Check SHA-1 fingerprint for production

### Issue: Biometric not available
**Solution**: Test on a real device with biometric sensor

## Production Checklist

Before deploying to production:

- [ ] Add SHA-1 and SHA-256 fingerprints to Firebase
- [ ] Enable App Check for abuse prevention
- [ ] Set up Cloud Functions for server-side validation
- [ ] Configure proper security rules
- [ ] Set up monitoring and analytics
- [ ] Enable crash reporting
- [ ] Add rate limiting
- [ ] Test on multiple devices
- [ ] Security audit
- [ ] Legal compliance check

## Support

If you encounter issues:
1. Check [FlutterFire Documentation](https://firebase.flutter.dev/)
2. Check [Firebase Documentation](https://firebase.google.com/docs)
3. Check the error logs: `flutter logs`

---

**Note**: This is for development/simulation purposes. Production deployment requires additional security measures and legal compliance.
