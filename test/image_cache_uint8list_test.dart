import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_cache_uint8list/image_cache_uint8list.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'mocks/fake_path_provider.dart';
import 'mocks/mock_file_service.dart';
import 'mocks/mock_http.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// ✅ IMPORTANT: init SQLite for test
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  const testUrl = 'https://picsum.photos/400';

  final fakeImageBytes = Uint8List.fromList(
    List<int>.generate(128, (i) => i),
  );

  late Directory tempDir;

  setUpAll(() async {
    // 📂 temp directory
    tempDir = await Directory.systemTemp.createTemp('image_cache_test');

    // 🧭 mock path_provider
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir);

    // 🌐 mock http
    HttpOverrides.global = MockHttpOverrides(fakeImageBytes);
  });

  tearDownAll(() async {
    HttpOverrides.global = null;
    await tempDir.delete(recursive: true);
  });

  group('ImageCacheUint8List', () {
    test('downloads image and returns Uint8List', () async {
      final mockService = MockFileService(fakeImageBytes);

      final bytes = await ImageCacheUint8List.getImageBytes(
        testUrl,
        ttl: const Duration(minutes: 5),
        fileService: mockService,
      );

      expect(bytes, isNotEmpty);
    });

    test('returns cached image on second call', () async {
      final mockService = MockFileService(fakeImageBytes);

      final first = await ImageCacheUint8List.getImageBytes(
        testUrl,
        fileService: mockService,
      );

      final second = await ImageCacheUint8List.getImageBytes(
        testUrl,
        fileService: mockService,
      );

      expect(second, equals(first));
    });
  });
}
