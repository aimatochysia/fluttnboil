# 🚀 FluttnBoil

A comprehensive Flutter SaaS boilerplate with authentication, subscription management, RBAC tiers, Stripe integration, and clean architecture.

![Flutter Version](https://img.shields.io/badge/Flutter-3.8+-blue)
![Dart Version](https://img.shields.io/badge/Dart-3.8+-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### Authentication
- ✅ Email/Password login & registration
- ✅ Social authentication (Google, Apple, GitHub)
- ✅ Password reset flow
- ✅ Email verification
- ✅ Remember me functionality
- ✅ Combined or separate auth screens (configurable)
- ✅ Secure token storage

### Subscription & Payments
- ✅ Stripe integration (dummy service for demo)
- ✅ Multiple subscription tiers (Free, Pro, Enterprise)
- ✅ Monthly/Yearly billing options
- ✅ Tier upgrade/downgrade flows
- ✅ Payment intent creation
- ✅ Billing history

### RBAC (Role-Based Access Control)
- ✅ Three-tier system (Free, Pro, Enterprise)
- ✅ Permission-based feature access
- ✅ Feature limits per tier
- ✅ Paywall guards
- ✅ Upgrade prompts

### Architecture
- ✅ Clean Architecture (Domain, Data, Presentation layers)
- ✅ Riverpod state management
- ✅ GoRouter navigation with guards
- ✅ Dependency injection ready
- ✅ Repository pattern
- ✅ Error handling with Result type

### UI/UX
- ✅ Beautiful landing page
- ✅ Dashboard with stats & quick actions
- ✅ Profile management
- ✅ Tier selection popup/modal
- ✅ Reusable UI components
- ✅ Light/Dark theme support
- ✅ Responsive design

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── app/
│   └── app.dart                 # App exports
│
├── core/                        # Core functionality
│   ├── config/
│   │   ├── app_config.dart      # Main configuration
│   │   └── environment.dart     # Environment settings
│   │
│   ├── constants/
│   │   └── app_constants.dart   # Routes, keys, UI constants
│   │
│   ├── error/
│   │   ├── exceptions.dart      # Custom exceptions
│   │   └── result.dart          # Result type for error handling
│   │
│   ├── network/
│   │   └── api_client.dart      # HTTP client with interceptors
│   │
│   ├── router/
│   │   └── app_router.dart      # GoRouter configuration & guards
│   │
│   └── theme/
│       └── app_theme.dart       # Theme configuration
│
├── features/                    # Feature modules
│   │
│   ├── auth/                    # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── dummy_auth_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       └── screens/
│   │           ├── login_screen.dart
│   │           ├── signup_screen.dart
│   │           └── forgot_password_screen.dart
│   │
│   ├── dashboard/               # Dashboard feature
│   │   └── presentation/
│   │       └── screens/
│   │           └── dashboard_screen.dart
│   │
│   ├── landing/                 # Landing page feature
│   │   └── presentation/
│   │       └── screens/
│   │           └── landing_screen.dart
│   │
│   ├── profile/                 # Profile feature
│   │   └── presentation/
│   │       └── screens/
│   │           └── profile_screen.dart
│   │
│   ├── subscription/            # Subscription feature
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── dummy_stripe_service.dart
│   │   └── domain/
│   │       └── entities/
│   │           └── subscription.dart
│   │
│   └── tiers/                   # Tier/RBAC feature
│       ├── domain/
│       │   └── tier_definitions.dart
│       └── presentation/
│           └── widgets/
│               └── tier_popup.dart
│
└── shared/                      # Shared components
    └── widgets/
        ├── custom_button.dart
        ├── custom_text_field.dart
        └── social_auth_buttons.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8+ 
- Dart 3.8+
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/fluttnboil.git
   cd fluttnboil
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Credentials

Use these credentials to test the login functionality:
- **Email:** `demo@fluttnboil.com`
- **Password:** `demo1234`

## ⚙️ Configuration

### App Configuration (`lib/core/config/app_config.dart`)

```dart
class AppConfig {
  // App Information
  static const String appName = 'FluttnBoil';
  static const String appVersion = '1.0.0';
  
  // Environment
  static const Environment environment = Environment.development;
  
  // Authentication settings
  static const AuthConfig auth = AuthConfig();
  
  // Stripe settings
  static const StripeConfig stripe = StripeConfig();
  
  // Tier settings
  static const TierConfig tiers = TierConfig();
}
```

### Authentication Options

```dart
class AuthConfig {
  // Enable/disable auth methods
  final bool enableEmailAuth = true;
  final bool enableSocialAuth = true;
  
  // Social providers
  final List<SocialAuthProvider> socialProviders = const [
    SocialAuthProvider.google,
    SocialAuthProvider.apple,
    SocialAuthProvider.github,
  ];
  
  // Screen mode: combined or separate
  final AuthScreenMode screenMode = AuthScreenMode.separate;
  
  // Other options
  final bool enableRememberMe = true;
  final bool requireEmailVerification = true;
  final int minPasswordLength = 8;
}
```

### Tier Configuration

```dart
// Available tiers: Free, Pro, Enterprise
// Each tier has:
// - Name & description
// - Monthly/Yearly pricing
// - Feature list
// - Limits (projects, team members, storage, etc.)
// - Permissions (API access, priority support, etc.)
```

## 🔐 Authentication Flow

1. **Login/Signup** → User enters credentials
2. **Validation** → Client-side and server-side validation
3. **Token Storage** → Secure storage of auth tokens
4. **Route Guard** → Automatic redirects based on auth state
5. **Session Management** → Token refresh and expiry handling

## 💳 Subscription Flow

1. **Select Tier** → User chooses subscription tier
2. **Billing Cycle** → Monthly or Yearly selection
3. **Payment** → Stripe payment intent creation
4. **Confirmation** → Payment confirmation and tier upgrade
5. **Access Control** → Features unlocked based on tier

## 🛡️ Route Guards

Routes are automatically protected based on authentication state:

```dart
// Public routes (accessible without auth)
- /           (Landing page)
- /login      (Login)
- /signup     (Signup)
- /forgot-password

// Protected routes (require authentication)
- /dashboard  (Main dashboard)
- /profile    (User profile)
- /settings   (App settings)
- /subscription
- /payment
```

## 🎨 Theming

The app includes both light and dark themes with customizable colors:

```dart
// Brand colors
static const Color primaryColor = Color(0xFF6366F1);
static const Color secondaryColor = Color(0xFF8B5CF6);

// Tier colors
static const Color freeTierColor = Color(0xFF64748B);
static const Color proTierColor = Color(0xFF6366F1);
static const Color enterpriseTierColor = Color(0xFFF59E0B);
```

## 📦 Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^2.5.1 | State management |
| go_router | ^17.0.0 | Navigation |
| dio | ^5.9.0 | HTTP client |
| flutter_secure_storage | ^9.2.4 | Secure storage |
| freezed_annotation | ^3.1.0 | Immutable models |

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📝 Adding a New Feature

1. Create feature folder in `lib/features/`
2. Add domain layer (entities, repositories)
3. Add data layer (datasources, repository implementations)
4. Add presentation layer (providers, screens, widgets)
5. Register routes in `app_router.dart`
6. Add providers if using Riverpod

## 🔌 Backend Integration

Replace the dummy data sources with real API calls:

1. **Auth:** Replace `DummyAuthDataSource` with your backend API
2. **Stripe:** Replace `DummyStripeService` with actual Stripe SDK
3. **Storage:** The `ApiClient` is ready for your backend

### API Client Usage

```dart
final apiClient = ApiClient();

// Set auth token
apiClient.setAuthToken(token);

// Make requests
final response = await apiClient.get('/users');
final result = await apiClient.post('/auth/login', data: {...});
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📧 Support

For support, email support@fluttnboil.com or open an issue in this repository.

---

Built with ❤️ using Flutter
