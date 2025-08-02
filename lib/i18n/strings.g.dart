/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 1
/// Strings: 42

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final _StringsAppEn app = _StringsAppEn._(_root);
	late final _StringsSplashEn splash = _StringsSplashEn._(_root);
	late final _StringsMainEn main = _StringsMainEn._(_root);
	late final _StringsGalleryEn gallery = _StringsGalleryEn._(_root);
	late final _StringsFullScreenEn fullScreen = _StringsFullScreenEn._(_root);
	late final _StringsCommonEn common = _StringsCommonEn._(_root);
}

// Path: app
class _StringsAppEn {
	_StringsAppEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Very Good Coffee';
	String get subtitle => 'Discover amazing coffee photos';
	String get versionPrefix => 'Version';
}

// Path: splash
class _StringsSplashEn {
	_StringsSplashEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => _root.app.title;
	String get subtitle => _root.app.subtitle;
}

// Path: main
class _StringsMainEn {
	_StringsMainEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => _root.app.title;
	String get welcome => 'Welcome to Very Good Coffee!';
	String get instruction => 'Tap "New Coffee" to discover amazing coffee photos';
	String get newCoffeeButton => 'New Coffee';
	String get saveButton => 'Save';
	String get galleryButton => 'View Gallery';
	String get loading => 'Loading your coffee...';
	late final _StringsMainErrorEn error = _StringsMainErrorEn._(_root);
	late final _StringsMainSuccessEn success = _StringsMainSuccessEn._(_root);
}

// Path: gallery
class _StringsGalleryEn {
	_StringsGalleryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Coffee Gallery';
	String get backToMain => 'Back to Coffee';
	late final _StringsGalleryEmptyEn empty = _StringsGalleryEmptyEn._(_root);
	String get loading => 'Loading your coffee collection...';
	late final _StringsGalleryDeleteEn delete = _StringsGalleryDeleteEn._(_root);
	late final _StringsGalleryErrorEn error = _StringsGalleryErrorEn._(_root);
}

// Path: fullScreen
class _StringsFullScreenEn {
	_StringsFullScreenEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Coffee Image';
	String get imageInfo => 'Image Info';
	String get resetZoom => 'Reset Zoom';
	String get imageLoadError => 'Failed to display this coffee image';
	late final _StringsFullScreenImageInfoDialogEn imageInfoDialog = _StringsFullScreenImageInfoDialogEn._(_root);
}

// Path: common
class _StringsCommonEn {
	_StringsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get loading => 'Loading...';
	String get error => 'Error';
	String get retry => 'Retry';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get save => 'Save';
}

// Path: main.error
class _StringsMainErrorEn {
	_StringsMainErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Oops!';
	String get failedToLoad => 'Failed to load coffee image. Please try again.';
}

// Path: main.success
class _StringsMainSuccessEn {
	_StringsMainSuccessEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get imageSaved => 'Coffee image saved to gallery!';
}

// Path: gallery.empty
class _StringsGalleryEmptyEn {
	_StringsGalleryEmptyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'No coffee images saved yet';
	String get subtitle => 'Go back and save some amazing coffee photos!';
}

// Path: gallery.delete
class _StringsGalleryDeleteEn {
	_StringsGalleryDeleteEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Delete Image';
	String get message => 'Are you sure you want to delete this coffee image?';
	String get confirm => 'Delete';
	String get cancel => 'Cancel';
}

// Path: gallery.error
class _StringsGalleryErrorEn {
	_StringsGalleryErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Something went wrong';
	String get retry => 'Retry';
	String get failedToLoad => 'Failed to load gallery images.';
	String get failedToSave => 'Failed to save image. Please try again.';
	String get failedToDelete => 'Failed to remove image. Please try again.';
}

// Path: fullScreen.imageInfoDialog
class _StringsFullScreenImageInfoDialogEn {
	_StringsFullScreenImageInfoDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Image Information';
	String get savedAt => 'Saved at';
	String get source => 'Source';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'app.title': return 'Very Good Coffee';
			case 'app.subtitle': return 'Discover amazing coffee photos';
			case 'app.versionPrefix': return 'Version';
			case 'splash.title': return _root.app.title;
			case 'splash.subtitle': return _root.app.subtitle;
			case 'main.title': return _root.app.title;
			case 'main.welcome': return 'Welcome to Very Good Coffee!';
			case 'main.instruction': return 'Tap "New Coffee" to discover amazing coffee photos';
			case 'main.newCoffeeButton': return 'New Coffee';
			case 'main.saveButton': return 'Save';
			case 'main.galleryButton': return 'View Gallery';
			case 'main.loading': return 'Loading your coffee...';
			case 'main.error.title': return 'Oops!';
			case 'main.error.failedToLoad': return 'Failed to load coffee image. Please try again.';
			case 'main.success.imageSaved': return 'Coffee image saved to gallery!';
			case 'gallery.title': return 'Coffee Gallery';
			case 'gallery.backToMain': return 'Back to Coffee';
			case 'gallery.empty.title': return 'No coffee images saved yet';
			case 'gallery.empty.subtitle': return 'Go back and save some amazing coffee photos!';
			case 'gallery.loading': return 'Loading your coffee collection...';
			case 'gallery.delete.title': return 'Delete Image';
			case 'gallery.delete.message': return 'Are you sure you want to delete this coffee image?';
			case 'gallery.delete.confirm': return 'Delete';
			case 'gallery.delete.cancel': return 'Cancel';
			case 'gallery.error.title': return 'Something went wrong';
			case 'gallery.error.retry': return 'Retry';
			case 'gallery.error.failedToLoad': return 'Failed to load gallery images.';
			case 'gallery.error.failedToSave': return 'Failed to save image. Please try again.';
			case 'gallery.error.failedToDelete': return 'Failed to remove image. Please try again.';
			case 'fullScreen.title': return 'Coffee Image';
			case 'fullScreen.imageInfo': return 'Image Info';
			case 'fullScreen.resetZoom': return 'Reset Zoom';
			case 'fullScreen.imageLoadError': return 'Failed to display this coffee image';
			case 'fullScreen.imageInfoDialog.title': return 'Image Information';
			case 'fullScreen.imageInfoDialog.savedAt': return 'Saved at';
			case 'fullScreen.imageInfoDialog.source': return 'Source';
			case 'common.loading': return 'Loading...';
			case 'common.error': return 'Error';
			case 'common.retry': return 'Retry';
			case 'common.cancel': return 'Cancel';
			case 'common.delete': return 'Delete';
			case 'common.save': return 'Save';
			default: return null;
		}
	}
}
