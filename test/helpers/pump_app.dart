import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/theme/app_theme.dart';

/// Helper function to pump a widget with the necessary app infrastructure
/// for testing widgets that depend on MaterialApp, themes, and localization.
extension WidgetTesterX on WidgetTester {
  /// Pumps a widget wrapped with MaterialApp and necessary providers
  Future<void> pumpApp(
    Widget widget, {
    ThemeData? theme,
    Locale? locale,
  }) async {
    await pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.lightTheme,
        locale: locale ?? const Locale('en'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocale.values.map(
          (locale) => locale.flutterLocale,
        ),
        home: Scaffold(body: widget),
      ),
    );
  }

  /// Pumps a widget with only the necessary Material wrapper
  /// for simpler widget tests that don't need full app infrastructure
  Future<void> pumpMaterialApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: widget,
      ),
    );
  }

  /// Pumps a widget with minimal wrapper for testing pure widgets
  Future<void> pumpMinimal(Widget widget) async {
    await pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    );
  }
}

/// Helper to create a mock BuildContext for testing
class MockBuildContext extends Mock implements BuildContext {}

/// Common test widgets and utilities
class TestWidgets {
  /// Creates a basic MaterialApp wrapper for testing
  static Widget wrapWithMaterialApp(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  /// Creates a test scaffold with proper theme and localization
  static Widget createTestScaffold({
    required Widget body,
    String? title,
  }) {
    return MaterialApp(
      title: title ?? 'Test App',
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocale.values.map((locale) => locale.flutterLocale),
      home: Scaffold(body: body),
    );
  }
}
