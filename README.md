<img width="442" height="792" alt="weather2" src="https://github.com/user-attachments/assets/a3759213-a34f-4612-9dad-dda37f3e3c9e" />
<img width="462" height="827" alt="weather1" src="https://github.com/user-attachments/assets/93c049b2-18f1-4936-87a6-3440efe325f1" />
# 🌤️ WeatherWise - Flutter Weather Application

A production-grade, full-featured Weather Application built with **Flutter**, **GetX** for reactive state management, **GoRouter** for declarative navigation with route guards, **Clean Architecture[...] 

---
## 📸 Images

Below are screenshots of the app — Image 1 and Image 2. Add the corresponding image files to `assets/images/` (or update the paths below) so they render on GitHub.

| <img width="1440" height="3040" alt="Screenshot_20251017_161857" src="https://github.com/user-attachments/assets/98705ecf-5ac8-4b74-badb-c2199f8bfca7" />
:---: | :---: | :---: |
<img width="1440" height="3040" alt="Screenshot_20251017_161915" src="https://github.com/user-attachments/assets/ef0eb202-e81b-4775-b8a4-f74e76b9ff20" />
<img width="1440" height="3040" alt="Screenshot_20251017_161933" src="https://github.com/user-attachments/assets/0e3433ee-c08e-4170-840c-bc22df06485c" />

## 📸 Key Features

- 🔐 **Authentication System**:
  - Email/Password login and registration with validation
  - Local persistence via `SharedPreferences`
  - "Remember Me" session support
  - Logout confirmation modal
  - Pre-configured demo account (`demo@weather.com` / `password123`)

- 🌤️ **Live Weather & Forecasts**:
  - Current real-time temperature, feels like, min/max temperatures
  - Weather condition description and dynamic weather icons
  - 24-hour horizontal hourly forecast cards
  - 5-day daily forecast breakdown
  - Comprehensive weather metrics (Humidity, Wind Speed, Atmospheric Pressure, Visibility, Cloudiness, Sunrise & Sunset)

- 📍 **Location & Search**:
  - GPS device location detection via `geolocator`
  - City search with real-time feedback
  - Popular global city quick-select chips
  - Persistent search history with individual remove and clear all

- 🎨 **Modern UI/UX**:
  - Material Design 3 custom Light and Dark theme toggle
  - Dynamic gradient backgrounds based on weather condition & time of day
  - Shimmer loading state animations
  - Pull-to-refresh on weather home screen
  - Offline connectivity monitoring and cached weather fallback

- 🛡️ **Clean Architecture**:
  - Separated Core, Data, Modules, Routes, Theme, and Widgets layers
  - Repository pattern with Remote and Local DataSources

---

## 📁 Architecture & Folder Structure

```
lib/
├── main.dart                      # App entrypoint, services init, router setup
├── app/
│   ├── bindings/
│   │   └── initial_binding.dart   # GetX global dependency injection
│   ├── routes/
│   │   ├── app_routes.dart        # Route path constants
│   │   └── app_router.dart        # GoRouter config with auth redirect guards
│   └── theme/
│       ├── app_colors.dart        # Light & dark palettes, weather gradients
│       ├── app_theme.dart         # Material 3 ThemeData
│       └── app_typography.dart   # Clean typographic scale
├── core/
│   ├── constants/
│   │   ├── api_constants.dart     # API URLs, endpoints, timeouts
│   │   ├── app_constants.dart     # Storage keys, app configuration
│   │   └── asset_constants.dart   # Icon URLs and popular cities
│   ├── services/
│   │   ├── api_service.dart       # HTTP client with exception handling
│   │   ├── connectivity_service.dart # Real-time network monitor
│   │   ├── location_service.dart  # GPS location acquisition
│   │   └── storage_service.dart   # SharedPreferences manager
│   └── utils/
│       ├── app_logger.dart        # Console logger
│       ├── date_formatter.dart    # Date and time formatting
│       ├── extensions.dart        # String, double, context helpers
│       └── validators.dart        # Form input validators
├── data/
│   ├── datasources/
│   │   ├── auth_local_datasource.dart
│   │   ├── weather_local_datasource.dart
│   │   └── weather_remote_datasource.dart
│   └── repositories/
│       ├── auth_repository.dart
│       └── weather_repository.dart
├── modules/
│   ├── auth/
│   │   ├── controllers/
│   │   │   └── auth_controller.dart
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── views/
│   │   │   ├── login_view.dart
│   │   │   └── register_view.dart
│   │   └── widgets/
│   │       ├── auth_button.dart
│   │       └── auth_text_field.dart
│   └── weather/
│       ├── controllers/
│       │   └── weather_controller.dart
│       ├── models/
│       │   ├── forecast_model.dart
│       │   └── weather_model.dart
│       ├── views/
│       │   ├── weather_home_view.dart
│       │   │   └── weather_search_view.dart
│       └── widgets/
│           ├── current_weather_card.dart
│           ├── forecast_list.dart
│           ├── hourly_forecast_list.dart
│           ├── search_history_list.dart
│           ├── weather_details_grid.dart
│           └── weather_shimmer.dart
└── widgets/
    ├── common/
    │   ├── custom_app_bar.dart
    │   ├── error_state_widget.dart
    │   └── offline_banner.dart
    └── dialogs/
        ├── api_key_dialog.dart
        └── logout_confirm_dialog.dart
```

---

## 🚀 Getting Started

### 1. Prerequisites
- Flutter SDK `^3.11.3` or `^3.41.5`
- Dart SDK `^3.11.3`
- Android Studio / VS Code / Xcode

### 2. Configuration
Copy `.env.example` to `.env` or edit `.env` directly:
```env
WEATHER_API_KEY=your_openweathermap_api_key_here
WEATHER_API_URL=https://api.openweathermap.org/data/2.5
WEATHER_ICON_URL=https://openweathermap.org/img/wn
```
*(Note: An interactive API key configuration dialog is also available directly inside the app menu)*

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the Application
```bash
flutter run
```

### 5. Run Tests
```bash
flutter test
```

---

## 🧪 Testing Credentials
- **Email**: `demo@weather.com`
- **Password**: `password123`
*(Or click the "Use Demo Account" shortcut button on the Login screen, or register any new account)*
