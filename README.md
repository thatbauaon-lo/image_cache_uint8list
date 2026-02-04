# image_cache_uint8list

A Flutter package to download images from a URL, cache them locally, and return the image data as `Uint8List`.

This package is useful when you need full control over image bytes, such as using `Image.memory`, uploading cached images, or performing image processing.

---

## ✨ Features

- Download images from a URL
- Cache images locally using `flutter_cache_manager`
- Return image data as `Uint8List`
- Support custom HTTP headers (e.g. Authorization)
- Customizable cache TTL (time-to-live) per request
- Automatic cache reuse on subsequent requests

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  image_cache_uint8list: ^0.0.1
```

Then run:
```bash
flutter pub get
```

## 📸 Demo

![Demo](assets/image_cache_uint8list.gif)

This example demonstrates:
- Image loading as `Uint8List`
- Cache hit vs network fetch
- Response time measurement (ms)

## 🚀 Usage

### Default usage (TTL = 1 day)
```dart
final bytes = await ImageCacheUint8List.getImageBytes(
  'https://example.com/image.jpg',
);

Image.memory(bytes);
```

If no TTL is provided, the image will be cached for 1 day by default.

___

### Custom TTL (cache expiration)
You can control how long an image stays in cache by specifying a custom ttl:

```dart
final bytes = await ImageCacheUint8List.getImageBytes(
  'https://example.com/image.jpg',
  ttl: const Duration(hours: 2),
);

Image.memory(bytes);
```

Each unique TTL value uses its own internal cache manager to ensure accurate expiration behavior.

___

### Using Authorization headers
This is useful when loading images from protected or private APIs:

```dart
final bytes = await ImageCacheUint8List.getImageBytes(
  'https://secure.api.com/image.png',
  ttl: const Duration(minutes: 30),
  headers: {
    'Authorization': 'Bearer token',
  },
);

Image.memory(bytes);
```

## 🧠 How It Works
1. The package first checks the local cache using the image URL as the cache key.
2. If the cached file exists and has not expired (within the specified TTL), it returns the cached image as **Uint8List**.
3. If the cache is missing or expired, the image is downloaded from the network, stored in cache, and then returned.
4. Different TTL values are managed using separate internal **CacheManager** instances.

## 🧹 Cache Management
Clear all cached images

```dart
await ImageCacheUint8List.clearAllCaches();
```
This removes all cached images across all TTL configurations.

## ⚠️ Notes & Best Practices
* Using many different TTL values may increase disk usage, as each TTL creates a separate cache space.
* For most applications, it is recommended to use a small set of TTL values (e.g. 30 minutes, 1 hour, 1 day).
* This package focuses on returning raw image bytes and does not replace widgets like **Image.network**.

## 🧪 Testing

This package includes unit tests with mocked HTTP responses
to ensure reliable and deterministic cache behavior.

```bash
flutter test
```

## 📚 Dependencies
* [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)