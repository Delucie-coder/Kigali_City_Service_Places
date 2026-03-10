# Kigali Directory

A Flutter mobile application for discovering and managing local businesses, services, and points of interest in Kigali, Rwanda.

## 📱 Features

### Core Functionality
- **Business Directory**: Browse and search local listings by name, category, or description
- **Category Filtering**: Filter places by categories (Hospital, Police Station, Restaurant, Café, Park, Hotel, Bank, Pharmacy, Shopping Mall, School, Library, Tourist Attraction, Other)
- **Map View**: View all listings on an interactive OpenStreetMap
- **User Listings**: Create, edit, and manage your own business listings
- **Share Listings**: Share listings via external apps using the share functionality

### Authentication
- **Email & Password Authentication**: Secure user registration and login
- **Email Verification**: Verified email required for full app access
- **Session Management**: Persistent authentication state

### User Experience
- **Dark/Light Theme**: Toggle between dark and light modes
- **Responsive Design**: Modern Material Design 3 UI
- **Search Functionality**: Real-time search with instant results

## 🛠️ Technology Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.10+ |
| Language | Dart |
| Backend | Firebase (Firestore, Authentication) |
| State Management | Riverpod |
| Maps | flutter_map (OpenStreetMap) |
| Location Services | Geolocator |
| QR Codes | qr_flutter |
| Theming | Material Design 3 |

## 📁 Project Structure

```
lib2/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/
│   └── listing.dart          # Listing data model
├── services/
│   ├── auth_service.dart     # Firebase authentication
│   ├── listing_service.dart  # Firestore CRUD operations
│   └── data_seeder.dart      # Sample data seeding
├── theme/
│   ├── app_theme.dart        # Theme configuration
│   └── theme_provider.dart   # Theme state management
└── views/
    ├── auth_wrapper.dart     # Auth state wrapper
    ├── login_screen.dart     # User login
    ├── signup_screen.dart    # User registration
    ├── verify_email_screen.dart
    ├── home_screen.dart      # Main directory listing
    ├── create_listing_screen.dart
    ├── listing_detail_screen.dart
    ├── edit_listing_screen.dart
    ├── my_listings_screen.dart
    ├── map_view_screen.dart  # Map with all listings
    ├── map_screen.dart       # Alternative map view
    ├── settings_screen.dart  # App settings
    └── main_navigation.dart  # Bottom navigation
```

## 🚀 Getting Started

### Prerequisites

1. **Flutter SDK**: Version 3.10 or higher
2. **Dart SDK**: Version 3.10 or higher
3. **Firebase Project**: Create a project at [firebase.google.com](https://firebase.google.com)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd local
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   - Create a Firebase project at [firebase.google.com](https://firebase.google.com)
   - Enable **Authentication** (Email/Password provider)
   - Enable **Cloud Firestore**
   - Download `google-services.json` (Android) / `GoogleService-Info.plist` (iOS)
   - Place the config files in their respective directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Firestore Database**:
   - Create a collection named `listings` in Firestore
   - (Optional) Add sample data using the data seeder

5. Run the app:
   ```bash
   flutter run
   ```

### Build for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📋 Available Categories

- 🏥 Hospital
- 🚔 Police Station
- 📚 Library
- 🍽️ Restaurant
- ☕ Café
- 🌳 Park
- 📸 Tourist Attraction
- 🏨 Hotel
- 🏦 Bank
- 💊 Pharmacy
- 🛒 Shopping Mall
- 📖 School
- 📍 Other

## 🔧 Configuration

### Android Specific
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Requires location permissions in `AndroidManifest.xml`

### iOS Specific
- Minimum iOS: 12.0
- Requires location permissions in `Info.plist`

## 📄 Dependencies

Key dependencies used in this project:
- `flutter_riverpod: ^2.4.9` - State management
- `firebase_core: ^3.8.0` - Firebase initialization
- `firebase_auth: ^5.3.1` - Authentication
- `cloud_firestore: ^5.4.4` - Database
- `flutter_map: ^7.0.2` - OpenStreetMap integration
- `latlong2: ^0.9.1` - Geographic coordinates
- `geolocator: ^12.0.0` - Location services
- `share_plus: ^12.0.1` - Share functionality
- `google_fonts: ^6.1.0` - Typography

## 🎨 Theme

The app features a modern dark/light theme with:
- **Primary Colors**: Navy (#1A1A2E) and Cyan (#0EA5E9)
- **Dark Theme**: Dark navy background with light text
- **Light Theme**: Clean white background with dark text
- **Gradients**: Cyan to blue gradient accents

## 📱 Screenshots

The app includes the following main screens:
1. **Login/Signup** - Authentication screens
2. **Home** - Browse and search listings
3. **Listing Detail** - View full listing information
4. **Create/Edit Listing** - Add or modify listings
5. **Map View** - Geographic view of all listings
6. **My Listings** - User's personal listings
7. **Settings** - Theme toggle and app preferences

## 🔐 Security Rules

Recommended Firestore rules:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /listings/{listing} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        resource.data.createdBy == request.auth.uid;
    }
  }
}
```

## 📝 License

This project is for educational and demonstration purposes.

## 👤 Author

Created as a local directory application for Kigali, Rwanda.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- OpenStreetMap for map data

