import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_firebase/flutter_cache_manager_firebase.dart';

class MyCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const MyCachedNetworkImage(
      {Key key, @required this.imageUrl, this.width, this.height})
      : assert(imageUrl != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: FirebaseCacheManager(),
      width: width,
      height: height,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => CircularProgressIndicator(),
    );
  }
}
