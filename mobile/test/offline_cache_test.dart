import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:smartmap_ai/core/offline/offline_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('smartmap_cache_test');
    await OfflineCache.instance.init(path: tempDir.path);
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('fresh entry is readable and reported as cached', () async {
    await OfflineCache.instance.put('fresh', {'name': 'Lahore'});
    final value = OfflineCache.instance.read('fresh');
    expect(value, isA<Map>());
    expect((value as Map)['name'], 'Lahore');
    expect(OfflineCache.instance.freshnessOf('fresh'), CacheFreshness.cached);
  });

  test('expired entry is reported as expired, not live', () async {
    await OfflineCache.instance.put(
      'stale',
      {'name': 'Multan'},
      ttl: const Duration(seconds: -5),
    );
    OfflineCache.instance.read('stale');
    expect(OfflineCache.instance.freshnessOf('stale'), CacheFreshness.expired);
  });

  test('missing entry is unavailable', () {
    expect(OfflineCache.instance.read('never-written'), isNull);
    expect(OfflineCache.instance.freshnessOf('never-written'), CacheFreshness.unavailable);
  });

  test('offline/online reporting updates isOnline', () {
    OfflineCache.instance.reportOffline();
    expect(OfflineCache.instance.isOnline, isFalse);
    OfflineCache.instance.reportOnline();
    expect(OfflineCache.instance.isOnline, isTrue);
  });
}
