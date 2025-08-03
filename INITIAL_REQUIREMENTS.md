# Very Good Coffee App

## Overview

Very Good Coffee is a Flutter application which gives the user the ability to save their favorite
coffee pictures. 

## User Requirements

As a user, I should be able to:

- Open the app and load a new coffee image from the network
- Load a new coffee image if the current one is not my favorite
- Save the current coffee image locally if I really like it, so I can access my favorite coffee images at any time, even if I don’t have internet access
- Make sure any loading/error states are handled correctly

## Technical Requirements

### High-Level

- The application should pull the coffee images from the free API [https://coffee.alexflipnote.dev](https://coffee.alexflipnote.dev/)
- There should be clear instructions for how to run the application in the README.md
- The application should run on iOS and Android (no need to include Web/Desktop)

### Flutter App Project

- App Name: Very Good Coffee
- Flutter App Name: very_good_coffee
- Bundle Identifier: net.remstation.verygoodcoffee
- Platform: iOS and Android only (no web or desktop)
- Support for Mobile and Tablet - Responsive UI
- Support for all orientations
- Support multiple languages - English only for initial version

### Architecture Guidelines

- Coding
    - Robust (no warnings)
    - Easy to understand
    - Unit tests and Widget tests: 100% coverage
    - Has a clear and consistent architecture
- UI/UX
    - Based on Material
    - Modern and minimalist
    - Define a Flutter theme to be used by the MaterialApp
    - Inspired from [https://coffee.alexflipnote.dev/](https://coffee.alexflipnote.dev/)
    - All colors and UI elements respect the theme
    - Avoid using Alpha channel (opacity) with colors
    - Each widget has its own file
    - Prefer small composable widgets over large ones
    - Prefer using flex values over hardcoded sizes when creating widgets inside rows/columns, ensuring the UI adapts to various screen sizes
- Architecture
    - Use the Feature-First Clean Architecture approach documented here: [https://medium.com/@remy.baudet/feature-first-clean-architecture-for-flutter-246366e71c18](https://medium.com/@remy.baudet/feature-first-clean-architecture-for-flutter-246366e71c18)
    - Follow the folder and project structure detailed below (”App Structure”)
    - Linter: https://pub.dev/packages/very_good_analysis
      - Add badge in README.md
    - State Management: https://pub.dev/packages/flutter_bloc
    - Navigation: https://pub.dev/packages/go_router
    - Dependency Injection (DI): https://pub.dev/packages/get_it
    - Internationalization (i8n): https://pub.dev/packages/slang
    - Networking: https://pub.dev/packages/dio
    - Logging: https://pub.dev/packages/talker_flutter
      - Use Dio and Bloc logger extensions
- Testing
    - Mocks: https://pub.dev/packages/mocktail
    - BLoC: https://pub.dev/packages/bloc_test

### App Structure

- App
    - Config
        - Constants like Coffee Image API URL
    - DI Setup (Service Locator)
        - Image Fetcher Service with Coffee Image Remote Provider
        - Image Gallery Service with Local Storage
    - Presentation
        - Splash View
        - Main View (Single Coffee Image)
            - New Random Image CTA
            - Save Image CTA
            - Go to Gallery CTA
            - Discreet label with version at the bottom
        - Gallery View
            - Option to delete a saved image
    - Routing and Navigation
        - App start with Splash View for 2 sec
        - Splash View → Main View
        - Main View → Gallery View
- Shared
    - Basic Theming
    - Logging
    - Domain Models
        - Image: Bytes and Source (URL) for attribution
- Features
    - Image Fetcher - Get a Random Image from an Image Provider
        - Service
            - Init with Data Source
            - Get New Random Image
        - Data Source and
            - Remote Source using DIO
            - Local Source for testing (Mock - Optional)
            - DTO and Mapper as needed
        - Presentation
            - Image Fetcher Widget (Image and Button)
    - Image Gallery - Manage locally saved images
        - Service
            - Init with Data Source
            - Get All Images
            - Add Image
            - Remove Image
        - Data Source
            - Local Persistant Storage
            - DTO and Mapper as needed
        - Presentation
            - Image Gallery widgets
