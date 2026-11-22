import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/punjab_restaurants_data.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/theme/design_tokens.dart';

class RestaurantsScreen extends ConsumerStatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  ConsumerState<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends ConsumerState<RestaurantsScreen> {
  String _city = 'All';

  Future<void> _openLink(
    BuildContext context,
    Uri uri,
    String failureEn,
    String failureUr,
    bool isUrdu,
  ) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (opened) return;
    } catch (_) {
      // Fall through to the message below.
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isUrdu ? failureUr : failureEn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = ref.watch(languageProvider) == AppLanguage.urdu;
    String t(String en, String ur) => isUrdu ? ur : en;

    final restaurants = _city == 'All'
        ? punjabRestaurants
        : punjabRestaurants.where((r) => r.city == _city).toList();

    return Scaffold(
      backgroundColor: AppTokens.dashboardBg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('Restaurants & Food', 'ریستوران اور کھانا')),
            Text(
              t('Dining guide · public listings, Nov 2026',
                  'ڈائننگ گائیڈ · عوامی فہرست، نومبر 2026'),
              style: const TextStyle(fontSize: 11, color: AppTokens.textMuted),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTokens.goldTint,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppTokens.goldBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Icon(Icons.info_outline,
                          size: 15, color: AppTokens.gold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t(
                          'Ratings are public listing figures from November 2026, not reviews collected by this app. Menus, hours and online ordering change — confirm before visiting.',
                          'ریٹنگز نومبر 2026 کے عوامی اعداد و شمار ہیں، اس ایپ کے ریویو نہیں۔ مینو، اوقات اور آن لائن آرڈر بدل سکتے ہیں — جانے سے پہلے تصدیق کریں۔',
                        ),
                        style: const TextStyle(
                            fontSize: 11,
                            height: 1.45,
                            color: AppTokens.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final city in restaurantCities)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: _CityPill(
                          label: city == 'All'
                              ? t('All cities', 'تمام شہر')
                              : city,
                          selected: _city == city,
                          onTap: () => setState(() => _city = city),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              for (final restaurant in restaurants) ...[
                _RestaurantCard(
                  restaurant: restaurant,
                  isUrdu: isUrdu,
                  onWebsite: () {
                    final uri = restaurant.websiteUri;
                    if (uri != null) {
                      _openLink(
                        context,
                        uri,
                        'Could not open the restaurant page.',
                        'ریستوران کا صفحہ نہیں کھل سکا۔',
                        isUrdu,
                      );
                    }
                  },
                  onMap: () => _openLink(
                    context,
                    restaurant.mapUri,
                    'Could not open the map.',
                    'نقشہ نہیں کھل سکا۔',
                    isUrdu,
                  ),
                  onCall: () {
                    final uri = restaurant.callUri;
                    if (uri != null) {
                      _openLink(
                        context,
                        uri,
                        'Could not start a call.',
                        'کال شروع نہیں ہو سکی۔',
                        isUrdu,
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.verified_outlined,
                      size: 13, color: AppTokens.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t(
                        'Independent guide · links open the restaurant page or Google Maps.',
                        'آزاد گائیڈ · لنکس ریستوران کا صفحہ یا Google Maps کھولتے ہیں۔',
                      ),
                      style: const TextStyle(
                          fontSize: 10.5, color: AppTokens.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({
    required this.restaurant,
    required this.isUrdu,
    required this.onWebsite,
    required this.onMap,
    required this.onCall,
  });

  final PunjabRestaurant restaurant;
  final bool isUrdu;
  final VoidCallback onWebsite;
  final VoidCallback onMap;
  final VoidCallback onCall;

  String _reviewLabel() {
    final n = restaurant.reviewCount;
    if (n >= 1000) {
      final k = (n / 1000).toStringAsFixed(1).replaceAll('.0', '');
      return isUrdu ? '$k ہزار' : '${k}k';
    }
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    String t(String en, String ur) => isUrdu ? ur : en;
    final hasWebsite = restaurant.websiteUri != null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppTokens.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTokens.goldTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.restaurant_rounded,
                    color: AppTokens.gold, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.textPrimary,
                          height: 1.25),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${restaurant.area} · ${restaurant.city}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11.5, color: AppTokens.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTokens.goldTint,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTokens.goldBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: AppTokens.gold),
                        const SizedBox(width: 2),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppTokens.gold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isUrdu
                        ? '${_reviewLabel()} ریویو'
                        : '${_reviewLabel()} reviews',
                    style: const TextStyle(
                        fontSize: 9.5, color: AppTokens.textMuted),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            restaurant.specialty,
            style:
                const TextStyle(fontSize: 11.5, color: AppTokens.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed: hasWebsite ? onWebsite : onMap,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTokens.gold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md)),
                      textStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            hasWebsite
                                ? t('Reserve / Order', 'ریزرو / آرڈر کریں')
                                : t('Find online', 'آن لائن تلاش کریں'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.north_east_rounded,
                            size: 13, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              if (restaurant.callUri != null) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: t('Call', 'کال'),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: onCall,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: const BorderSide(color: AppTokens.border),
                        foregroundColor: AppTokens.emerald,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                      child: const Icon(Icons.call_outlined, size: 17),
                    ),
                  ),
                ),
              ],
              if (hasWebsite) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: t('Map', 'نقشہ'),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: onMap,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: const BorderSide(color: AppTokens.border),
                        foregroundColor: AppTokens.textSecondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                      child: const Icon(Icons.map_outlined, size: 17),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CityPill extends StatelessWidget {
  const _CityPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTokens.emerald : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: selected ? AppTokens.emerald : AppTokens.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTokens.textSecondary,
          ),
        ),
      ),
    );
  }
}
