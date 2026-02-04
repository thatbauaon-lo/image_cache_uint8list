import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheUint8List {
  static const _baseKey = 'image_cache_uint8list';

  static final Map<Duration, CacheManager> _managers = {};

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

  static Future<Uint8List> getImageBytes(
    String url, {
    Duration ttl = const Duration(days: 1),
    Map<String, String>? headers,
    FileService? fileService, // 👈 inject for test
  }) async {
    final cacheManager = _getManager(
      ttl,
      fileService: fileService,
    );

    final fileInfo = await cacheManager.getFileFromCache(url);
    if (fileInfo != null && await fileInfo.file.exists()) {
      return await fileInfo.file.readAsBytes();
    }

    final downloaded = await cacheManager.downloadFile(
      url,
      authHeaders: headers,
    );

    return await downloaded.file.readAsBytes();
  }

  /// Clear all cached images (all TTLs)
  static Future<void> clearAllCaches() async {
    for (final manager in _managers.values) {
      await manager.emptyCache();
    }
    _managers.clear();
  }
}
