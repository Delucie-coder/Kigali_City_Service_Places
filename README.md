# Kigali City Services & Places Directory

Flutter mobile application for browsing and managing Kigali public services and lifestyle locations.

This implementation is structured to satisfy the assignment architecture requirements now, while keeping Firebase integration intentionally deferred until you confirm.

## Current Status

- `Implemented`: Full UI, auth flow screens, email verification gate (simulated), listings CRUD, search, category filtering, detail page, embedded map, navigation launch, bottom navigation, settings screen, state management, service/repository separation.
- `Deferred`: Firebase Authentication and Cloud Firestore wiring (to be done when you say "connect to Firebase").

## Features

- Authentication screens: `Login`, `Sign Up`, `Verify Email`
- Protected app shell after verification
- Bottom navigation with required tabs:
	- `Directory`
	- `My Listings`
	- `Map View`
	- `Settings`
- Listings CRUD with required fields:
	- Place/Service name
	- Category
	- Address
	- Contact number
	- Description
	- Latitude/Longitude
	- Created by UID
	- Timestamp
- Search by name and filter by category
- Listing detail page with embedded `GoogleMap` marker
- External turn-by-turn navigation via Google Maps URL launch
- Settings with user profile details + notification preference toggle (local simulation)

## Architecture (Clean Separation)

The app avoids direct backend calls inside UI widgets.

- `models/`: data models (`AppUser`, `Listing`)
- `services/interfaces/`: backend contracts (`AuthService`, `ListingService`)
- `services/mock/`: in-memory mock backend implementations
- `repositories/`: bridge from state layer to services
- `state/`: Provider-based app state (`AuthProvider`, `ListingProvider`)
- `screens/`: UI pages
- `widgets/`: reusable components (`ListingCard`)

Data flow:

`UI -> Provider -> Repository -> Service -> Provider stream update -> UI rebuild`

## Tech Stack

- Flutter
- Provider (state management)
- google_maps_flutter
- url_launcher
- uuid
- intl
- google_fonts

## Run Locally

```bash
flutter pub get
flutter run
```

## Firebase Integration Plan (When Approved)

Once you tell me to proceed, these are the exact upgrades:

1. Add Firebase packages:
	 - `firebase_core`
	 - `firebase_auth`
	 - `cloud_firestore`
2. Run FlutterFire CLI and generate `firebase_options.dart`.
3. Replace:
	 - `MockAuthService` with `FirebaseAuthService`
	 - `MockListingService` with `FirestoreListingService`
4. Enforce real email verification using Firebase Auth (`currentUser.reload`, `emailVerified`).
5. Create/update user profiles in Firestore collection `users`.
6. Store listings in Firestore collection `listings` with ownership checks by UID.
7. Keep all UI unchanged as much as possible because architecture is already backend-ready.

## Suggested Firestore Structure

- `users/{uid}`
	- `email`
	- `displayName`
	- `notificationsEnabled`
	- `createdAt`

- `listings/{listingId}`
	- `name`
	- `category`
	- `address`
	- `contactNumber`
	- `description`
	- `latitude`
	- `longitude`
	- `createdBy`
	- `timestamp`

## Important for Android Map Display

To render Google Maps on Android, add your Maps API key in `android/app/src/main/AndroidManifest.xml` under `<application>`:

```xml
<meta-data
		android:name="com.google.android.geo.API_KEY"
		android:value="YOUR_GOOGLE_MAPS_API_KEY" />
```

## Assignment Evidence Checklist

Use this project as your base for:

- Reflection document with Firebase integration challenges and fixes
- GitHub repo with meaningful incremental commits
- Demo video showing:
	- auth flow
	- create/edit/delete listing
	- search/filter
	- detail + map + navigation
	- Firebase Console changes (after Firebase connection step)
- Design summary describing schema + provider flow + trade-offs