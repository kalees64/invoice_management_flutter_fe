import 'package:flutter/material.dart';

class AssetImageContainer extends StatelessWidget {
  const AssetImageContainer({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.shape,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final String? shape;

  @override
  Widget build(BuildContext context) {
    if (shape == 'circle') {
      return ClipOval(
        child: _buildAssetImageContainer(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(5),
        child: _buildAssetImageContainer(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }
  }
}

Widget _buildAssetImageContainer({
  required String imageUrl,
  double? width,
  double? height,
  BoxFit? fit,
}) {
  return Image.asset(
    imageUrl,
    height: height ?? 200,
    width: width ?? 200,
    fit: fit ?? BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      debugPrint('Failed to load asset: $imageUrl -> $error');
      return Container(
        height: height ?? 200,
        width: width ?? 200,
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
      );
    },
  );
}
