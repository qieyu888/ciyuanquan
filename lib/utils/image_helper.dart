import 'package:flutter/material.dart';

/// 获取图片提供者（支持本地和网络图片）
ImageProvider getImageProvider(String imagePath) {
  if (imagePath.startsWith('http')) {
    return NetworkImage(imagePath);
  } else {
    return AssetImage(imagePath);
  }
}

/// 获取图片小部件（支持本地和网络图片）
Widget buildImage(
  String imagePath, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
}) {
  if (imagePath.startsWith('http')) {
    return Image.network(
      imagePath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
    );
  } else {
    return Image.asset(
      imagePath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
    );
  }
}
