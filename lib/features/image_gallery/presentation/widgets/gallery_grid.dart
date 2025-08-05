import 'package:flutter/material.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_empty_state.dart';
import 'package:very_good_coffee/features/image_gallery/presentation/widgets/gallery_item.dart';
import 'package:very_good_coffee/shared/domain/models/coffee_image.dart';
import 'package:very_good_coffee/shared/theme/ui_constants.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({
    required this.images,
    this.onImageTap,
    this.onImageDelete,
    this.crossAxisCount = UIConstants.gridCrossAxisCount,
    this.crossAxisSpacing = UIConstants.gridSpacing,
    this.mainAxisSpacing = UIConstants.gridSpacing,
    this.padding = const EdgeInsets.all(UIConstants.gridSpacing),
    super.key,
  });

  final List<CoffeeImage> images;
  final void Function(CoffeeImage image)? onImageTap;
  final void Function(CoffeeImage image)? onImageDelete;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const GalleryEmptyState();
    }

    return Padding(
      padding: padding,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return GalleryItem(
            image: image,
            onTap: onImageTap != null ? () => onImageTap!(image) : null,
            onDelete: onImageDelete != null
                ? () => onImageDelete!(image)
                : null,
          );
        },
      ),
    );
  }
}
