import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

class MockHttpOverrides extends HttpOverrides {
  final Uint8List responseBytes;

  MockHttpOverrides(this.responseBytes);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient(responseBytes);
  }
}

class _MockHttpClient implements HttpClient {
  final Uint8List bytes;

  _MockHttpClient(this.bytes);

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest(bytes);
  }

  /// ✅ IMPORTANT: flutter_cache_manager uses this
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    return _MockHttpClientRequest(bytes);
  }

  // ignore: noSuchMethod
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientRequest implements HttpClientRequest {
  final Uint8List bytes;

  _MockHttpClientRequest(this.bytes);

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse(bytes);
  }

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  // ignore: noSuchMethod
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientResponse extends Stream<List<int>>
    implements HttpClientResponse {
  final Uint8List bytes;

  _MockHttpClientResponse(this.bytes);

  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => bytes.length;

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([bytes]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  // ignore: noSuchMethod
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  List<String>? operator [](String name) => null;

  // ignore: noSuchMethod
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
