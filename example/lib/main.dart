import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cache_uint8list/image_cache_uint8list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Cache Uint8List Example',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const imageUrl = 'https://picsum.photos/400';

  late Future<Uint8List> _imageFuture;
  int? _responseTimeMs;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage({bool clearCache = false}) {
    _imageFuture = _loadWithTiming(clearCache: clearCache);
    setState(() {});
  }

  Future<Uint8List> _loadWithTiming({bool clearCache = false}) async {
    if (clearCache) {
      await ImageCacheUint8List.clearAllCaches();
    }

    final stopwatch = Stopwatch()..start();

    final bytes = await ImageCacheUint8List.getImageBytes(
      imageUrl,
      ttl: const Duration(minutes: 10),
    );

    stopwatch.stop();
    _responseTimeMs = stopwatch.elapsedMilliseconds;

    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ImageCacheUint8List Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Load image as Uint8List with cache',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Uint8List>(
              future: _imageFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text('Failed to load image');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        snapshot.data!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_responseTimeMs != null)
                      Text(
                        'Response time: $_responseTimeMs ms',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload'),
                  onPressed: () {
                    _loadImage(clearCache: false);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reloaded (using cache)')),
                    );
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Reload (No Cache)'),
                  onPressed: () {
                    _loadImage(clearCache: true);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reloaded (cache cleared)'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
