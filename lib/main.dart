import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:very_good_coffee/app/di/service_locator.dart';
import 'package:very_good_coffee/app/routing/app_router.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';
import 'package:very_good_coffee/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocaleSettings.useDeviceLocale();

  AppLogger.init();

  // Configure BLoC logging
  Bloc.observer = TalkerBlocObserver(
    talker: AppLogger.instance,
    settings: const TalkerBlocLoggerSettings(
      printStateFullData: false,
      printEventFullData: false,
    ),
  );

  await setupServiceLocator();

  AppLogger.info('Very Good Coffee app starting...');

  runApp(TranslationProvider(child: const VeryGoodCoffeeApp()));
}

/// The Very Good Coffee App
class VeryGoodCoffeeApp extends StatelessWidget {
  /// Default Constructor
  const VeryGoodCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: t.app.title,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
