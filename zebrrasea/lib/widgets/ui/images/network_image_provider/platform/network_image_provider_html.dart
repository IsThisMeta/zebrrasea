import 'package:flutter/material.dart';

// ignore: always_use_package_imports
import '../network_image_provider.dart';

ZebrraNetworkImageProvider getNetworkImageProvider({
  required String url,
  Map<String, String>? headers,
}) {
  return Web(
    url: url,
    headers: headers,
  );
}

class Web implements ZebrraNetworkImageProvider {
  String url;
  Map<String, String>? headers;

  Web({
    required this.url,
    this.headers,
  });

  @override
  ImageProvider<Object> get imageProvider {
    return NetworkImage(
      url,
      headers: headers,
    );
  }
}
