/// A lightweight utility library for downloading images from a URL,
/// caching them locally, and returning the result as a [Uint8List].
///
/// This library is designed for Flutter applications that need:
/// - Raw image bytes instead of Widgets
/// - Custom cache expiration (TTL)
/// - Support for authenticated image requests
/// - Easy testing via dependency injection
///
/// Example:
/// ```dart
/// final bytes = await ImageCacheUint8List.getImageBytes(
///   'https://example.com/image.png',
///   ttl: const Duration(hours: 2),
/// );
///
/// Image.memory(bytes);
/// ```
library image_cache_uint8list;

export 'src/image_cache_uint8list_impl.dart';
