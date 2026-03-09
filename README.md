# Kigali City Services & Places Directory

Flutter mobile application for browsing and managing Kigali public services and lifestyle locations.

This application is a fully functional directory solution integrating **Firebase Authentication** for user management and **Cloud Firestore** for real-time data persistence. It demonstrates a robust implementation of CRUD operations, geolocation services, and state management.

## Project Overview

The application satisfies all assignment requirements including:
- **Authentication**: Secure Signup/Login with Email & Password.
- **Real-time Database**: Listings and Reviews stored in Cloud Firestore.
- **State Management**: Built using the `Provider` package ensures UI reactivity.
- **Geolocation**: Integrated mapping and navigation features.

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
- `services/firebase/`: concrete Firebase implementations
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

## Firestore Database Structure

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