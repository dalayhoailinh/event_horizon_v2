import 'package:flutter/material.dart';

/// Network image with a neutral placeholder while loading and an icon when
/// the URL is empty or broken — never a red error box in the middle of a page.
class AppNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) {
      return const _ImageFallback(icon: Icons.image_outlined);
    }
    return Image.network(
      url,
      fit: fit,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return const _ImageFallback();
      },
      errorBuilder: (context, error, stackTrace) =>
          const _ImageFallback(icon: Icons.broken_image_outlined),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final IconData? icon;
  const _ImageFallback({this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: icon == null
          ? const SizedBox.expand()
          : Center(child: Icon(icon, color: scheme.onSurfaceVariant)),
    );
  }
}
