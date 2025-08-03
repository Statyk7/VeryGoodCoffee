# Very Good Coffee ☕

[![Very Good Analysis][very_good_analysis_badge]][very_good_analysis_link]
[![very_good_coffee](https://github.com/Statyk7/VeryGoodCoffee/actions/workflows/very_good_coffee.yml/badge.svg)](https://github.com/Statyk7/VeryGoodCoffee/actions/workflows/very_good_coffee.yml)

A Flutter application that lets you discover and save amazing coffee photos from around the web.

See [Initial Requirements](INITIAL_REQUIREMENTS.md) and [Test Plan](TEST_PLAN.md) files for additional information.

## Features

✨ **Random Coffee Discovery**: Fetch beautiful coffee images from the Coffee API  
💾 **Local Gallery**: Save your favorite coffee photos to view offline  
🎨 **Modern UI**: Clean, coffee-themed Material Design interface  
📱 **Cross-Platform**: Runs on both iOS and Android  
🔄 **Offline Support**: Access saved images without internet connection  
🌐 **Internationalization**: Full i18n support using Slang (English only for now)  
📊 **Comprehensive Logging**: Network requests, state changes, navigation events, and app events tracking  

## Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart 3.0 or higher
- iOS 12.0+ / Android API level 21+

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd very_good_coffee
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### GitHub Actions

The `very_good_coffee` workflow is configured to be triggered manually (see [here](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/manually-run-a-workflow)).

It uses [Very Good Workflows](https://workflows.vgv.dev/) with the Flutter Workflow configured with **Minimum Coverage set to 90%**.

## Development

### Project Structure

This project follows a **Feature-First Clean Architecture** approach.
Each feature is composed of 3 layers: Domain, Data and Presentation.


Dependency Rules:
- `app/` can depend on `features/` and `shared/`
- `features/` can depend on `shared/` but NOT on `app/` or other `features/`
- `shared/` has NO dependencies on `app/` or `features/`
- Within features: `presentation → domain → data`

More details here: https://medium.com/@remy.baudet/feature-first-clean-architecture-for-flutter-246366e71c18

```
lib/
├── app/                    # Application layer
│   ├── config/            # App constants and configuration
│   ├── di/                # Dependency injection setup
│   ├── presentation/      # App-level views (Splash, Main, Gallery)
│   └── routing/           # Navigation and routing
├── features/              # Feature modules
│   ├── image_fetcher/     # Coffee image fetching
│   └── image_gallery/     # Local image storage
├── i18n/                  # Internationalization
│   ├── strings.i18n.json  # Translation strings
│   └── strings.g.dart     # Generated translation code
└── shared/                # Shared components
    ├── domain/            # Domain models
    ├── logging/           # App logging
    └── theme/             # UI theming
```

### Key Technologies

- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Navigation**: [go_router](https://pub.dev/packages/go_router)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Networking**: [dio](https://pub.dev/packages/dio)
- **Internationalization**: [slang](https://pub.dev/packages/slang)
- **Logging**: [talker_flutter](https://pub.dev/packages/talker_flutter), [talker_dio_logger](https://pub.dev/packages/talker_dio_logger), [talker_bloc_logger](https://pub.dev/packages/talker_bloc_logger)
- **Local Storage**: [path_provider](https://pub.dev/packages/path_provider)
- **Linting**: [very_good_analysis](https://pub.dev/packages/very_good_analysis)

### Available Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Code analysis
flutter analyze

# Clean build files
flutter clean

# Build for production
flutter build apk          # Android
flutter build ios          # iOS

# Internationalization
dart run slang              # Generate translation files
```

### API

This app uses the [Coffee API](https://coffee.alexflipnote.dev/) to fetch random coffee images.

## Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ and ☕ using Flutter

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
