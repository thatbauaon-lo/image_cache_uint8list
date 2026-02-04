import 'dart:io';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  final Directory baseDir;

  FakePathProviderPlatform(this.baseDir);

  @override
  Future<String?> getTemporaryPath() async {
    return _create('temp');
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return _create('support');
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return _create('documents');
  }

  Future<String> _create(String name) async {
    final dir = Directory('${baseDir.path}/$name');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir.path;
  }
}
