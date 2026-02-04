import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MockFileService implements FileService {
  final Uint8List bytes;

  @override
  int concurrentFetches = 10;

  MockFileService(this.bytes);

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _MockFileServiceResponse(bytes);
  }
}

class _MockFileServiceResponse implements FileServiceResponse {
  final Uint8List bytes;

  _MockFileServiceResponse(this.bytes);

  @override
  int get statusCode => 200;

  @override
  Stream<List<int>> get content => Stream.value(bytes);

  @override
  int get contentLength => bytes.length;

  @override
  DateTime get validTill => DateTime.now().add(const Duration(days: 1));

  @override
  String get eTag => 'mock-etag';

  /// ✅ MUST be non-nullable
  @override
  String get fileExtension => 'png';
}
