import 'package:flutter/material.dart';

class FlagImage extends StatelessWidget {
  const FlagImage(
      {super.key, required this.url, this.width = 56, this.height = 40});
  final String? url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Icon(Icons.flag_rounded, color: Colors.grey.shade500),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url == null
          ? placeholder
          : Image.network(
              url!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : placeholder,
            ),
    );
  }
}
