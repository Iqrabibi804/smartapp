import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/punjab_stays_data.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/theme/design_tokens.dart';

class StaysScreen extends ConsumerStatefulWidget {
  const StaysScreen({super.key});

  @override
  ConsumerState<StaysScreen> createState() => _StaysScreenState();
}

class _StaysScreenState extends ConsumerState<StaysScreen> {
  String _city = 'All';

  String _scoreWord(String en, bool isUrdu) {
    if (!isUrdu) return en;
    switch (en) {
      case 'Wonderful':
        return 'شاندار';
      case 'Exceptional':
        return 'غیر معمولی';
      case 'Excellent':
        return 'بہترین';
      case 'Good':
        return 'اچھا';
      case 'Review score':
        return 'ریویو اسکور';
      default:
        return en;
    }
  }

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

    final stays = _city == 'All'
        ? punjabStays
        : punjabStays.where((s) => s.city == _city).toList();

    return Scaffold(
      backgroundColor: AppTokens.dashboardBg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t('Stays & Hotels', 'سٹے اور ہوٹل')),
            Text(
              t('Booking.com listings · Nov 2026',
                  'Booking.com کی فہرست · نومبر 2026'),
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
                          'Scores, review counts and facilities are as listed on Booking.com in November 2026. Prices and availability open on Booking.com.',
                          'اسکور، ریویو تعداد اور سہولیات نومبر 2026 میں Booking.com پر درج معلومات کے مطابق ہیں۔ قیمتیں اور دستیابی Booking.com پر کھلیں گی۔',
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
                    for (final city in stayCities)
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
              for (final stay in stays) ...[
                _StayCard(
                  stay: stay,
                  isUrdu: isUrdu,
                  scoreWord: _scoreWord(stay.scoreWord, isUrdu),
                  onBook: () => _openLink(
                    context,
                    stay.bookingUri,
                    'Could not open Booking.com. Check your browser.',
                    'Booking.com نہیں کھل سکا۔ براؤزر چیک کریں۔',
                    isUrdu,
                  ),
                  onMap: () => _openLink(
                    context,
                    stay.mapUri,
                    'Could not open the map.',
                    'نقشہ نہیں کھل سکا۔',
                    isUrdu,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 4),
              Material(
                color: AppTokens.emeraldDeep,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: () => _openLink(
                    context,
                    allPunjabStaysUri,
                    'Could not open Booking.com. Check your browser.',
                    'Booking.com نہیں کھل سکا۔ براؤزر چیک کریں۔',
                    isUrdu,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.hotel_rounded,
                              color: Colors.white, size: 21),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t('Browse Punjab stays on Booking.com',
                                    'پنجاب کے سٹے Booking.com پر دیکھیں'),
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                t('Opens a live search — dates and prices there',
                                    'لائیو تلاش کھلے گی — تاریخ اور قیمتیں وہاں'),
                                style: TextStyle(
                                    fontSize: 10.5,
                                    color:
                                        Colors.white.withValues(alpha: 0.72)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.north_east_rounded,
                            color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.verified_outlined,
                      size: 13, color: AppTokens.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t(
                        'Independent guide · not affiliated with Booking.com · no booking commission.',
                        'آزاد گائیڈ · Booking.com سے وابستہ نہیں · بکنگ کمیشن نہیں۔',
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

class _StayCard extends StatelessWidget {
  const _StayCard({
    required this.stay,
    required this.isUrdu,
    required this.scoreWord,
    required this.onBook,
    required this.onMap,
  });

  final PunjabStay stay;
  final bool isUrdu;
  final String scoreWord;
  final VoidCallback onBook;
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) {
    String t(String en, String ur) => isUrdu ? ur : en;
    final score = stay.score;
    final scoreColor = (score ?? 0) >= 8.0 ? AppTokens.emerald : AppTokens.gold;
    final location =
        stay.area == stay.city ? stay.city : '${stay.area} · ${stay.city}';

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
                  color: AppTokens.emeraldTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bed_rounded,
                    color: AppTokens.emerald, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stay.name,
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
                      location,
                      style: const TextStyle(
                          fontSize: 11.5, color: AppTokens.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (stay.hasRating)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: scoreColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            score!.toStringAsFixed(1),
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            scoreWord,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isUrdu
                          ? '${stay.reviewCount} ریویو'
                          : '${stay.reviewCount} reviews',
                      style: const TextStyle(
                          fontSize: 9.5, color: AppTokens.textMuted),
                    ),
                  ],
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTokens.goldTint,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTokens.goldBorder),
                  ),
                  child: Text(
                    isUrdu ? 'نیا لسٹنگ' : 'New listing',
                    style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.gold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final facility in stay.facilities)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTokens.inputFill,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    facility,
                    style: const TextStyle(
                        fontSize: 10, color: AppTokens.textSecondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: FilledButton(
                    onPressed: onBook,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTokens.emerald,
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
                            t('Find on Booking.com',
                                'Booking.com پر تلاش کریں'),
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
                    child: const Icon(Icons.map_outlined, size: 18),
                  ),
                ),
              ),
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
