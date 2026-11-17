import 'package:flutter/material.dart';

/// Preserve photo proportions and avoid enlarging small merchant images.
class CatalogPhoto extends StatelessWidget {
  const CatalogPhoto(this.url,
      {super.key, this.height = 160, this.width = double.infinity});
  final String? url;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    const placeholder =
        Center(child: Icon(Icons.storefront_outlined, size: 36));
    final source = Uri.tryParse(url ?? '');
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: const Color(0xFFF2F6F4),
        child: source?.scheme != 'https'
            ? placeholder
            : LayoutBuilder(builder: (context, bounds) {
                final scale = MediaQuery.devicePixelRatioOf(context);
                return Image.network(
                  url!,
                  scale: scale,
                  fit: BoxFit.scaleDown,
                  filterQuality: FilterQuality.medium,
                  excludeFromSemantics: true,
                  frameBuilder: (context, child, frame, sync) =>
                      frame != null || sync ? child : placeholder,
                  errorBuilder: (context, error, stack) => placeholder,
                );
              }),
      ),
    );
  }
}
