import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'offline_cache.dart';

final offlineCacheProvider = ChangeNotifierProvider<OfflineCache>((ref) {
  return OfflineCache.instance;
});
