<<<<<<< HEAD
# Taartu Mobile App

**Version:** 1.0.0+100  
**Status:** Production Ready ✅

A cross-platform mobile application for the Taartu booking marketplace, built with Flutter and featuring a commission-only business model.

## 🚀 Features

### Core Functionality
- **Role-based Authentication**: Business owners and clients
- **Commission-only Model**: 5%-15% commission range, zero subscription fees
- **Team Management**: Employee rate configuration and splits
- **Booking System**: Complete booking flow with price breakdown
- **Multi-platform Support**: iOS, Android, and Web

### Business Features
- **Commission Management**: Configurable commission rates
- **Employee Splits**: Individual employee compensation tracking
- **Price Calculator**: Automated commission and split calculations
- **Dashboard Analytics**: Business insights and booking management

### Technical Features
- **Modern Architecture**: Flutter 3.x with Riverpod state management
- **Responsive Design**: Material 3 design system
- **Cross-platform**: Single codebase for iOS, Android, and Web
- **Testing**: Comprehensive unit and integration tests

## 📱 Supported Platforms

- ✅ **iOS**: 12.0+ (iPhone/iPad)
- ✅ **Android**: API 21+ (Android 5.0+)
- ✅ **Web**: Modern browsers (Chrome, Safari, Firefox, Edge)

## 🛠 Development Setup

### Prerequisites
- Flutter 3.32.7+
- Dart 3.8.0+
- Android Studio / Xcode
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/taartu/taartu_mobile.git
   cd taartu_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Run tests
flutter test

# Run analysis
flutter analyze

# Build for different platforms
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android App Bundle
flutter build ios --release          # iOS App
flutter build web --release          # Web App
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```
**Coverage:** 22 tests passing ✅

### Integration Tests
```bash
flutter drive --driver=test_driver/app_test_test.dart --target=lib/main.dart
```
**Note:** Requires WebDriver setup for web testing

### Static Analysis
```bash
flutter analyze --no-fatal-warnings
```
**Status:** 12 issues (8 deprecated test methods, 4 unused convenience constructors) ✅

## 📦 Build Artifacts

### Android
- **APK**: `build/app/outputs/flutter-apk/app-release.apk` (25.1MB)
- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab` (45.1MB)

### iOS
- **App**: `build/ios/iphoneos/Runner.app` (62.8MB)
- **Note**: Requires manual code signing for App Store deployment

### Web
- **Build**: `build/web/` directory
- **Optimized**: Tree-shaken assets, minified code

## 🚀 Deployment

### Android Play Store
1. Build App Bundle: `flutter build appbundle --release`
2. Upload `app-release.aab` to Google Play Console
3. Configure store listing and release

### iOS App Store
1. Build iOS app: `flutter build ios --release`
2. Open in Xcode: `open ios/Runner.xcworkspace`
3. Configure signing and upload to App Store Connect

### Web Deployment
1. Build web app: `flutter build web --release`
2. Deploy `build/web/` directory to your web server
3. Configure HTTPS and domain

### Backend API
The app connects to the Taartu Laravel API at `https://api.taartu.com`

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the project root:
```env
API_BASE_URL=https://api.taartu.com
MIXPANEL_TOKEN=your_mixpanel_token
```

### Feature Flags
Key configuration in `lib/src/core/config/feature_flags.dart`:
- Commission range: 5%-15%
- Default commission rate: 10%
- Business model: Commission-only

## 📊 Performance Metrics

### Build Performance
- **Web Build**: ~21 seconds
- **Android APK**: ~65 seconds
- **iOS App**: ~68 seconds

### App Size
- **Android APK**: 25.1MB
- **Android AAB**: 45.1MB
- **iOS App**: 62.8MB
- **Web Assets**: Optimized with tree-shaking

## 🔒 Security

### API Security
- Laravel Sanctum authentication
- CSRF protection enabled
- CORS properly configured
- Environment variables secured

### App Security
- No sensitive data in code
- Secure API communication
- Input validation implemented
- Error handling without data leakage

## 📈 Business Model

### Commission Structure
- **Range**: 5% - 15% (configurable per business)
- **Default**: 10%
- **Model**: Commission-only, zero subscription fees

### Employee Splits
- **Types**: Percentage or flat rate
- **Tracking**: Individual employee compensation
- **Calculation**: Automated based on booking amounts

## 🐛 Known Issues

### Minor Issues
- Android NDK version mismatch (non-critical)
- Deprecated test methods (Flutter 3.x compatibility)
- Unused convenience constructors (future use)

### Integration Testing
- Requires WebDriver setup for web testing
- iOS simulator integration needs proper configuration

## 📞 Support

For technical support or questions:
- **Repository**: https://github.com/taartu/taartu_mobile
- **API Documentation**: https://api.taartu.com/docs
- **Business Support**: Contact Taartu team

## 📄 License

This project is proprietary software owned by Taartu.

---

**Last Updated:** December 2024  
**Audit Status:** ✅ Production Ready  
**Version:** 1.0.0+100 
=======
# taartu_mobile
Taartu Mobile App - Flutter marketplace for salon bookings 
>>>>>>> e9bdb02d0c070f765d94be83a8dc7ec284d752ad
