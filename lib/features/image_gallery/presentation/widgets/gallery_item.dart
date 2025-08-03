import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_bloc.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/bloc/image_gallery_event.dart';
import 'package:very_good_coffee/i18n/strings.g.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';

class GalleryItem extends StatelessWidget {
  const GalleryItem({
    required this.image,
    this.onTap,
    this.onDelete,
    super.key,
  });

  final CoffeeImage image;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => context.push('/full_screen_image', extra: image),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'coffee_image_${image.id ?? image.hashCode}',
              child: Image.memory(
                image.bytes,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return ColoredBox(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: Icon(Icons.broken_image),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: onDelete ?? () => _showDeleteDialog(context),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  image.savedAt != null
                      ? _formatDate(image.savedAt!)
                      : 'Unknown date',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.gallery.delete.title),
        content: Text(t.gallery.delete.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(t.gallery.delete.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (image.id != null) {
                context.read<ImageGalleryBloc>().add(
                  RemoveImageRequested(image.id!),
                );
              }
            },
            child: Text(
              t.gallery.delete.confirm,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
