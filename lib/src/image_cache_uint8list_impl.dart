import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Main utility class for image caching and retrieval.
///
/// This class uses [flutter_cache_manager] internally and manages
/// multiple cache instances based on different TTL (time-to-live) values.
///
/// Each unique TTL will have its own [CacheManager] instance.
class ImageCacheUint8List {
  /// Base key used for generating cache identifiers.
  static const _baseKey = 'image_cache_uint8list';

  /// CacheManager instances mapped by TTL.
  ///
  /// This allows different expiration times to coexist without conflict.
  static final Map<Duration, CacheManager> _managers = {};

  /// Returns a [CacheManager] instance for the given [ttl].
  ///
  /// If a manager for the TTL already exists, it will be reused.
  /// Otherwise, a new one will be created and stored.
  ///
  /// The optional [fileService] parameter allows injecting a custom
  /// [FileService], which is especially useful for unit testing.
  static CacheManager _getManager(
    Duration ttl, {
    FileService? fileService,
  }) {
    return _managers.putIfAbsent(
      ttl,
      () => CacheManager(
        Config(
          '$_baseKey-${ttl.inSeconds}',
          stalePeriod: ttl,
          maxNrOfCacheObjects: 200,
          fileService: fileService ?? HttpFileService(),
        ),
      ),
    );
  }

  /// Downloads an image from the given [url], caches it, and returns it
  /// as a [Uint8List].
  ///
  /// Workflow:
  /// 1. Check local cache first
  /// 2. If cache exists → return cached bytes
  /// 3. Otherwise → download, cache, and return bytes
  ///
  /// Parameters:
  /// - [url]: The image URL
  /// - [ttl]: Cache time-to-live (default: 1 day)
  /// - [headers]: Optional HTTP headers (e.g. Authorization)
  /// - [fileService]: Optional custom file service (for testing)
  ///
  /// Example:
  /// ```dart
  /// final bytes = await ImageCacheUint8List.getImageBytes(
  ///   'https://secure.api.com/image.jpg',
  ///   ttl: const Duration(minutes: 30),
  ///   headers: {
  ///     'Authorization': 'Bearer token',
  ///   },
  /// );
  /// ```
  static Future<Uint8List> getImageBytes(
    String url, {
    Duration ttl = const Duration(days: 1),
    Map<String, String>? headers,
    FileService? fileService,
  }) async {
    final cacheManager = _getManager(
      ttl,
      fileService: fileService,
    );

    // 🔎 Check cache first
    final fileInfo = await cacheManager.getFileFromCache(url);
    if (fileInfo != null && await fileInfo.file.exists()) {
      return await fileInfo.file.readAsBytes();
    }

    // 🌐 Download and cache
    final downloaded = await cacheManager.downloadFile(
      url,
      authHeaders: headers,
    );

    return await downloaded.file.readAsBytes();
  }

  /// Clears all cached images across all TTL configurations.
  ///
  /// This will remove all cache entries and dispose all internal
  /// [CacheManager] instances.
  static Future<void> clearAllCaches() async {
    for (final manager in _managers.values) {
      await manager.emptyCache();
    }
    _managers.clear();
  }
}
