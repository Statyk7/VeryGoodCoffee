///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       $meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    $meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  /// Access flat map
  dynamic operator [](String key) => $meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations
  late final TranslationsAppEn app = TranslationsAppEn.internal(_root);
  late final TranslationsSplashEn splash = TranslationsSplashEn.internal(_root);
  late final TranslationsMainEn main = TranslationsMainEn.internal(_root);
  late final TranslationsGalleryEn gallery = TranslationsGalleryEn.internal(
    _root,
  );
  late final TranslationsFullScreenEn fullScreen =
      TranslationsFullScreenEn.internal(_root);
  late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
}

// Path: app
class TranslationsAppEn {
  TranslationsAppEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Very Good Coffee'
  String get title => 'Very Good Coffee';

  /// en: 'Discover amazing coffee photos'
  String get subtitle => 'Discover amazing coffee photos';

  /// en: 'Version'
  String get versionPrefix => 'Version';
}

// Path: splash
class TranslationsSplashEn {
  TranslationsSplashEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Very Good Coffee'
  String get title => _root.app.title;

  /// en: 'Discover amazing coffee photos'
  String get subtitle => _root.app.subtitle;
}

// Path: main
class TranslationsMainEn {
  TranslationsMainEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Very Good Coffee'
  String get title => _root.app.title;

  /// en: 'Welcome to Very Good Coffee!'
  String get welcome => 'Welcome to Very Good Coffee!';

  /// en: 'Tap "New Coffee" to discover amazing coffee photos'
  String get instruction =>
      'Tap "New Coffee" to discover amazing coffee photos';

  /// en: 'New Coffee'
  String get newCoffeeButton => 'New Coffee';

  /// en: 'Save'
  String get saveButton => 'Save';

  /// en: 'View Gallery'
  String get galleryButton => 'View Gallery';

  /// en: 'Loading your coffee...'
  String get loading => 'Loading your coffee...';

  late final TranslationsMainErrorEn error = TranslationsMainErrorEn.internal(
    _root,
  );
  late final TranslationsMainSuccessEn success =
      TranslationsMainSuccessEn.internal(_root);
}

// Path: gallery
class TranslationsGalleryEn {
  TranslationsGalleryEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Coffee Gallery'
  String get title => 'Coffee Gallery';

  /// en: 'Back to Coffee'
  String get backToMain => 'Back to Coffee';

  late final TranslationsGalleryEmptyEn empty =
      TranslationsGalleryEmptyEn.internal(_root);

  /// en: 'Loading your coffee collection...'
  String get loading => 'Loading your coffee collection...';

  late final TranslationsGalleryDeleteEn delete =
      TranslationsGalleryDeleteEn.internal(_root);
  late final TranslationsGalleryErrorEn error =
      TranslationsGalleryErrorEn.internal(_root);
}

// Path: fullScreen
class TranslationsFullScreenEn {
  TranslationsFullScreenEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Coffee Image'
  String get title => 'Coffee Image';

  /// en: 'Image Info'
  String get imageInfo => 'Image Info';

  /// en: 'Reset Zoom'
  String get resetZoom => 'Reset Zoom';

  /// en: 'Failed to display this coffee image'
  String get imageLoadError => 'Failed to display this coffee image';

  late final TranslationsFullScreenImageInfoDialogEn imageInfoDialog =
      TranslationsFullScreenImageInfoDialogEn.internal(_root);
}

// Path: common
class TranslationsCommonEn {
  TranslationsCommonEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Loading...'
  String get loading => 'Loading...';

  /// en: 'Error'
  String get error => 'Error';

  /// en: 'Retry'
  String get retry => 'Retry';

  /// en: 'Cancel'
  String get cancel => 'Cancel';

  /// en: 'Delete'
  String get delete => 'Delete';

  /// en: 'Save'
  String get save => 'Save';
}

// Path: main.error
class TranslationsMainErrorEn {
  TranslationsMainErrorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Oops!'
  String get title => 'Oops!';

  /// en: 'Failed to load coffee image. Please try again.'
  String get failedToLoad => 'Failed to load coffee image. Please try again.';
}

// Path: main.success
class TranslationsMainSuccessEn {
  TranslationsMainSuccessEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Coffee image saved to gallery!'
  String get imageSaved => 'Coffee image saved to gallery!';
}

// Path: gallery.empty
class TranslationsGalleryEmptyEn {
  TranslationsGalleryEmptyEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'No coffee images saved yet'
  String get title => 'No coffee images saved yet';

  /// en: 'Go back and save some amazing coffee photos!'
  String get subtitle => 'Go back and save some amazing coffee photos!';
}

// Path: gallery.delete
class TranslationsGalleryDeleteEn {
  TranslationsGalleryDeleteEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Delete Image'
  String get title => 'Delete Image';

  /// en: 'Are you sure you want to delete this coffee image?'
  String get message => 'Are you sure you want to delete this coffee image?';

  /// en: 'Delete'
  String get confirm => 'Delete';

  /// en: 'Cancel'
  String get cancel => 'Cancel';
}

// Path: gallery.error
class TranslationsGalleryErrorEn {
  TranslationsGalleryErrorEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Something went wrong'
  String get title => 'Something went wrong';

  /// en: 'Retry'
  String get retry => 'Retry';

  /// en: 'Failed to load gallery images.'
  String get failedToLoad => 'Failed to load gallery images.';

  /// en: 'Failed to save image. Please try again.'
  String get failedToSave => 'Failed to save image. Please try again.';

  /// en: 'Failed to remove image. Please try again.'
  String get failedToDelete => 'Failed to remove image. Please try again.';
}

// Path: fullScreen.imageInfoDialog
class TranslationsFullScreenImageInfoDialogEn {
  TranslationsFullScreenImageInfoDialogEn.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Image Information'
  String get title => 'Image Information';

  /// en: 'Saved at'
  String get savedAt => 'Saved at';

  /// en: 'Source'
  String get source => 'Source';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.
extension on Translations {
  dynamic _flatMapFunction(String path) {
    switch (path) {
      case 'app.title':
        return 'Very Good Coffee';
      case 'app.subtitle':
        return 'Discover amazing coffee photos';
      case 'app.versionPrefix':
        return 'Version';
      case 'splash.title':
        return _root.app.title;
      case 'splash.subtitle':
        return _root.app.subtitle;
      case 'main.title':
        return _root.app.title;
      case 'main.welcome':
        return 'Welcome to Very Good Coffee!';
      case 'main.instruction':
        return 'Tap "New Coffee" to discover amazing coffee photos';
      case 'main.newCoffeeButton':
        return 'New Coffee';
      case 'main.saveButton':
        return 'Save';
      case 'main.galleryButton':
        return 'View Gallery';
      case 'main.loading':
        return 'Loading your coffee...';
      case 'main.error.title':
        return 'Oops!';
      case 'main.error.failedToLoad':
        return 'Failed to load coffee image. Please try again.';
      case 'main.success.imageSaved':
        return 'Coffee image saved to gallery!';
      case 'gallery.title':
        return 'Coffee Gallery';
      case 'gallery.backToMain':
        return 'Back to Coffee';
      case 'gallery.empty.title':
        return 'No coffee images saved yet';
      case 'gallery.empty.subtitle':
        return 'Go back and save some amazing coffee photos!';
      case 'gallery.loading':
        return 'Loading your coffee collection...';
      case 'gallery.delete.title':
        return 'Delete Image';
      case 'gallery.delete.message':
        return 'Are you sure you want to delete this coffee image?';
      case 'gallery.delete.confirm':
        return 'Delete';
      case 'gallery.delete.cancel':
        return 'Cancel';
      case 'gallery.error.title':
        return 'Something went wrong';
      case 'gallery.error.retry':
        return 'Retry';
      case 'gallery.error.failedToLoad':
        return 'Failed to load gallery images.';
      case 'gallery.error.failedToSave':
        return 'Failed to save image. Please try again.';
      case 'gallery.error.failedToDelete':
        return 'Failed to remove image. Please try again.';
      case 'fullScreen.title':
        return 'Coffee Image';
      case 'fullScreen.imageInfo':
        return 'Image Info';
      case 'fullScreen.resetZoom':
        return 'Reset Zoom';
      case 'fullScreen.imageLoadError':
        return 'Failed to display this coffee image';
      case 'fullScreen.imageInfoDialog.title':
        return 'Image Information';
      case 'fullScreen.imageInfoDialog.savedAt':
        return 'Saved at';
      case 'fullScreen.imageInfoDialog.source':
        return 'Source';
      case 'common.loading':
        return 'Loading...';
      case 'common.error':
        return 'Error';
      case 'common.retry':
        return 'Retry';
      case 'common.cancel':
        return 'Cancel';
      case 'common.delete':
        return 'Delete';
      case 'common.save':
        return 'Save';
      default:
        return null;
    }
  }
}
