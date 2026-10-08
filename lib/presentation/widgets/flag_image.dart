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
      color: const Color(0xFFE9ECF5),
      child: const Icon(Icons.flag_rounded, color: Color(0xFF9AA0B5)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
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
