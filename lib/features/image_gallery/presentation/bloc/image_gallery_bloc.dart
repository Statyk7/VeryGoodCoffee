import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_event.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_state.dart';
import 'package:very_good_coffee/features/image_gallery/service/image_gallery_service.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/logging/app_logger.dart';

class ImageGalleryBloc extends Bloc<ImageGalleryEvent, ImageGalleryState> {
  ImageGalleryBloc(this._imageGalleryService) : super(ImageGalleryInitial()) {
    on<LoadGalleryImagesRequested>(_onLoadGalleryImagesRequested);
    on<SaveImageRequested>(_onSaveImageRequested);
    on<RemoveImageRequested>(_onRemoveImageRequested);
  }

  final ImageGalleryService _imageGalleryService;

  Future<void> _onLoadGalleryImagesRequested(
    LoadGalleryImagesRequested event,
    Emitter<ImageGalleryState> emit,
  ) async {
    emit(ImageGalleryLoading());
    
    try {
      AppLogger.info('Loading gallery images');
      final images = await _imageGalleryService.getAllImages();
      emit(ImageGalleryLoaded(images));
      AppLogger.info('Successfully loaded ${images.length} gallery images');
    } catch (e) {
      AppLogger.error('Failed to load gallery images', e);
      emit(ImageGalleryError(t.gallery.error.failedToLoad));
    }
  }

  Future<void> _onSaveImageRequested(
    SaveImageRequested event,
    Emitter<ImageGalleryState> emit,
  ) async {
    emit(ImageSaving());
    
    try {
      AppLogger.info('Saving image to gallery');
      await _imageGalleryService.addImage(event.image);
      emit(ImageSaved());
      AppLogger.info('Successfully saved image to gallery');
    } catch (e) {
      AppLogger.error('Failed to save image to gallery', e);
      emit(ImageSaveError(t.gallery.error.failedToSave));
    }
  }

  Future<void> _onRemoveImageRequested(
    RemoveImageRequested event,
    Emitter<ImageGalleryState> emit,
  ) async {
    try {
      AppLogger.info('Removing image from gallery: ${event.imageId}');
      await _imageGalleryService.removeImage(event.imageId);
      
      // Reload the gallery after removing an image
      add(LoadGalleryImagesRequested());
      AppLogger.info('Successfully removed image from gallery');
    } catch (e) {
      AppLogger.error('Failed to remove image from gallery', e);
      emit(ImageGalleryError(t.gallery.error.failedToDelete));
    }
  }
}