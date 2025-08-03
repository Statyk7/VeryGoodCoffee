# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Very Good Coffee is a Flutter application that allows users to discover and save beautiful coffee images. The app follows a Feature-First Clean Architecture pattern with clear separation of concerns and includes full internationalization support using Slang.

Key features:
- Auto-loading coffee images when the app starts
- Seamless navigation between main view and gallery
- Type-safe internationalization with Slang
- Coffee-themed Material Design UI
- Offline gallery with local image storage

Refer to the `INITIAL_REQUIREMENTS.md` file as needed.

## Development Commands

### Essential Commands
- `flutter run` - Run the app on connected device/emulator
- `flutter test` - Run all unit and widget tests
- `flutter analyze` - Static analysis using Very Good Analysis rules
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires macOS and Xcode)
- `flutter clean` - Clean build artifacts and dependencies
- `flutter pub get` - Install/update dependencies
- `dart run slang` - Generate translation files from JSON

### Development Workflow
- `flutter hot reload` - Hot reload during development (press 'r' in terminal)
- `flutter hot restart` - Hot restart (press 'R' in terminal)
- `flutter doctor` - Check Flutter environment setup
- `flutter devices` - List available devices/emulators

## Architecture

### Feature-First Clean Architecture
The project follows feature-first organization where each feature contains its own:
- **Service Layer**: Business logic and use cases
- **Data Source Layer**: External API calls and local storage
- **Presentation Layer**: BLoC state management and UI widgets

### Project Structure
```
lib/
├── app/                    # Application layer
│   ├── config/            # Constants (API URLs, app settings)
│   ├── di/                # Dependency injection with GetIt
│   ├── presentation/      # App-level views (Splash, Main, Gallery)
│   └── routing/           # GoRouter navigation setup
├── features/              # Feature modules
│   ├── image_fetcher/     # Coffee image API integration
│   └── image_gallery/     # Local image storage and management
├── i18n/                  # Internationalization
│   ├── strings.i18n.json  # Translation strings (JSON format)
│   └── strings.g.dart     # Generated Slang translation code
└── shared/                # Shared components
    ├── domain/models/     # Data models (CoffeeImage)
    ├── logging/           # Talker logging setup
    └── theme/             # Material Design theme
```

### Key Dependencies
- **flutter_bloc**: State management with BLoC pattern
- **go_router**: Declarative routing and navigation
- **get_it**: Service locator dependency injection
- **dio**: HTTP client for API calls
- **slang**: Type-safe internationalization and localization
- **talker_flutter**: Logging and debugging
- **path_provider**: Local file storage paths
- **very_good_analysis**: Strict linting rules

### State Management Pattern
Each feature uses BLoC pattern:
- **Events**: User actions and system events
- **States**: UI state representations (Loading, Success, Error)
- **BLoC**: Business logic controllers connecting events to states

### API Integration
- Coffee images fetched from `https://coffee.alexflipnote.dev/random`
- Images downloaded as bytes for local storage
- Network error handling with user-friendly messages
- Auto-loading: Images fetch automatically when MainView initializes

### Local Storage
- Images stored in application documents directory
- Metadata stored as JSON for image tracking
- Unique IDs generated for each saved image

### Internationalization
- **Slang setup**: Translation files in `lib/i18n/strings.i18n.json`
- **Code generation**: Run `dart run slang` to generate type-safe translations
- **Usage**: Access translations via `t.key.subkey` syntax throughout the app
- **Current support**: English only, but structured for easy expansion
- **Integration**: All user-facing text uses translations (no hardcoded strings)

## Testing Strategy

### Test Structure
- **Unit Tests**: Service layer and business logic
- **Widget Tests**: UI components and user interactions
- **BLoC Tests**: State management logic with bloc_test
- **Mock Dependencies**: Using mocktail for external dependencies

### Running Tests
- All tests: `flutter test`
- With coverage: `flutter test --coverage`
- Specific test: `flutter test test/path/to/test_file.dart`

## Development Guidelines

### Code Style
- Follow very_good_analysis linting rules
- Use meaningful variable and function names
- Keep widgets small and composable
- Prefer const constructors where possible
- Use proper error handling with try-catch blocks

### BLoC Best Practices
- One BLoC per feature/screen
- Emit loading states before async operations
- Handle errors gracefully with user-friendly messages
- Use BlocListener for side effects (snackbars, navigation)
- Use BlocBuilder for UI state updates
- Auto-trigger events in BLoC creation for initial loading

### Internationalization Best Practices
- Never use hardcoded strings in UI components
- Always use `t.section.key` for all user-facing text
- Update `strings.i18n.json` when adding new text
- Run `dart run slang` after updating translation files
- Organize translations by feature/screen sections
- Use parameter interpolation for dynamic content: `t.key(param: value)`

### File Organization
- Each widget in its own file
- Group related files in feature directories
- Use barrel exports (index.dart) for clean imports
- Keep business logic separate from UI code
- Translation files in dedicated `i18n/` directory

## Development Best Practices

### Code Quality
- Make sure that the app compiles with on errors and no warnings after any change in the code

## Formatting and File Guidelines

### Formatting Guidelines
- Make sure to run `dart format` on the created or modified Dart files in `lib` and `test` directories