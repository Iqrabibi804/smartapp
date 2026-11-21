import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/design_tokens.dart';
import 'offline_cache.dart';
import 'offline_cache_provider.dart';

/// Persistent status strip: offline mode and stale cached data are always
/// visible, never silently presented as live.
class OfflineStatusBanner extends ConsumerWidget {
  const OfflineStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cache = ref.watch(offlineCacheProvider);
    final offline = !cache.isOnline;
    final anyExpired = ['categories', 'places_search'].any(
      (key) => cache.freshnessOf(key) == CacheFreshness.expired,
    );

    if (!offline && !anyExpired) return const SizedBox.shrink();

    final savedAt = cache.savedAtOf('places_search');
    final savedLabel = savedAt == null
        ? ''
        : ' · saved ${savedAt.day}/${savedAt.month}, ${_two(savedAt.hour)}:${_two(savedAt.minute)}';

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppTokens.heritageGold.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTokens.heritageGold.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, size: 16, color: Color(0xFF8A6E3B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              offline
                  ? 'Offline mode — showing saved guide data$savedLabel'
                  : 'Saved data is out of date — refresh when you are online$savedLabel',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B5528)),
            ),
          ),
        ],
      ),
    );
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
