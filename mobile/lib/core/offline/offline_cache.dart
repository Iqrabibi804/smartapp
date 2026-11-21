import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Freshness of data shown to the user. Expired cache is never presented
/// as live data: the UI must label it.
enum CacheFreshness { live, cached, expired, bundled, unavailable }

/// Hive-backed cache with per-entry TTL and freshness reporting.
///
/// Keys used by feature services: `categories`, `places_search`, `place:<id>`.
class OfflineCache extends ChangeNotifier {
  OfflineCache._();

  static final OfflineCache instance = OfflineCache._();
  static const _boxName = 'offline_cache_v1';
  static const _defaultTtl = Duration(hours: 24);

  Box<dynamic>? _box;
  bool _online = true;
  final Map<String, CacheFreshness> _freshness = {};
  final Map<String, DateTime> _savedAt = {};

  bool get isOnline => _online;
  CacheFreshness freshnessOf(String key) => _freshness[key] ?? CacheFreshness.unavailable;
  DateTime? savedAtOf(String key) => _savedAt[key];

  Future<void> init({String? path}) async {
    try {
      if (path != null) {
        Hive.init(path);
      } else {
        await Hive.initFlutter();
      }
      _box = await Hive.openBox<dynamic>(_boxName);
    } catch (_) {
      // Cache is an enhancement: the app still works from bundled data.
      _box = null;
    }
  }

  void reportOnline() {
    if (!_online) {
      _online = true;
      notifyListeners();
    }
  }

  void reportOffline() {
    if (_online) {
      _online = false;
      notifyListeners();
    }
  }

  Future<void> put(String key, Object payload, {Duration ttl = _defaultTtl}) async {
    final now = DateTime.now();
    try {
      await _box?.put(key, {
        'savedAt': now.toIso8601String(),
        'ttlSeconds': ttl.inSeconds,
        'payload': jsonEncode(payload),
      });
    } catch (_) {}
    _set(key, CacheFreshness.cached, now);
  }

  /// Returns the cached payload and records its freshness, or null.
  Object? read(String key) {
    final raw = _box?.get(key);
    if (raw is! Map) {
      _set(key, CacheFreshness.unavailable, null);
      return null;
    }
    final savedAt = DateTime.tryParse('${raw['savedAt']}');
    final ttlSeconds = (raw['ttlSeconds'] as num?)?.toInt() ?? _defaultTtl.inSeconds;
    final expired = savedAt == null || DateTime.now().difference(savedAt).inSeconds > ttlSeconds;
    _set(key, expired ? CacheFreshness.expired : CacheFreshness.cached, savedAt);
    try {
      return jsonDecode('${raw['payload']}');
    } catch (_) {
      return null;
    }
  }

  void _set(String key, CacheFreshness freshness, DateTime? savedAt) {
    final changed = _freshness[key] != freshness || _savedAt[key] != savedAt;
    _freshness[key] = freshness;
    if (savedAt != null) _savedAt[key] = savedAt;
    if (changed) notifyListeners();
  }
}
