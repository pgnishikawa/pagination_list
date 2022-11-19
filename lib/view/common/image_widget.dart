import 'package:flutter/material.dart';

Widget buildImage(String imageUrl, {Radius? border, BoxFit? fit}) {
  return ClipRRect(
    borderRadius: border == null ? BorderRadius.zero : BorderRadius.all(border),
    child: Image.network(
      imageUrl,
      fit: fit ?? BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Center(
          child: Icon(
            Icons.error,
            color: Colors.black54,
          ),
        );
      },
    ),
  );
}
