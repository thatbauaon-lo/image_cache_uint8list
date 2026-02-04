# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/).
---
## [0.0.3] - 2026-02-04
- Fix demo GIF display on pub.dev change link

---
## [0.0.2] - 2026-02-04
- Fix demo GIF display on pub.dev

---

## [0.0.1] - 2026-02-04

### 🎉 Initial Release

### ✨ Added
- Download image from a URL and return it as `Uint8List`
- Built-in caching using `flutter_cache_manager`
- Configurable cache TTL (time-to-live)
- Support for custom `FileService` (useful for testing & mocking)
- Works on Flutter 3.0+

### 🧪 Testing
- Unit tests with mocked network responses
- Mocked `path_provider` and cache storage for test environment
- Verified cached response is reused on subsequent calls

### 📦 Dependencies
- `flutter_cache_manager ^3.4.1`

---
