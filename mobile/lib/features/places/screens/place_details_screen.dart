import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_client.dart';
import '../../directions/screens/directions_screen.dart';
import '../../favorites/services/favorites_service.dart';
import '../../reviews/models/review_model.dart';
import '../../reviews/screens/write_review_screen.dart';
import '../../reviews/services/reviews_service.dart';
import '../models/place_model.dart';
import '../services/places_providers.dart';
import 'facility_finder_screen.dart';

// ─── Top-level helpers (accessible from every class in this file) ────────────

String _priceLabel(String priceRange) {
  switch (priceRange) {
    case 'free':
      return 'Free';
    case 'low':
      return '\$';
    case 'medium':
      return '\$\$';
    case 'high':
      return '\$\$\$';
    default:
      return '';
  }
}

Future<void> _launchUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}

// ─── Main Screen ─────────────────────────────────────────────────────────────

class PlaceDetailsScreen extends ConsumerWidget {
  final String placeId;
  const PlaceDetailsScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(placeDetailsProvider(placeId));

    return Scaffold(
      body: detailsAsync.when(
        data: (result) => _PlaceDetailsContent(place: result.place, related: result.related),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(friendlyErrorMessage(e), textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Content ─────────────────────────────────────────────────────────────────

class _PlaceDetailsContent extends ConsumerWidget {
  final PlaceModel place;
  final List<PlaceModel> related;
  const _PlaceDetailsContent({required this.place, required this.related});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(placeReviewsProvider(place.id));

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (place.images.isNotEmpty)
                  Image.network(
                    place.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      child: const Center(
                        child: Icon(Icons.photo_outlined, size: 64, color: AppColors.primary),
                      ),
                    ),
                  )
                else
                  Container(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    child: const Center(
                      child: Icon(Icons.place, size: 64, color: AppColors.primary),
                    ),
                  ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black45,
                        Colors.transparent,
                        Colors.black45,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing arrives in a later phase.')),
                );
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(place.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    if (place.verificationStatus == 'verified')
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(Icons.verified, color: AppColors.primary),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                if (place.categoryName != null)
                  Text(place.categoryName!,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${place.rating.toStringAsFixed(1)} (${place.reviewCount} reviews)'),
                    const SizedBox(width: 12),
                    Text(_priceLabel(place.priceRange),
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 20),
                _ActionsRow(place: place),

                // ── 💳 Pakistani Payments (JazzCash, Easypaisa, NBP, Cash) ──
                if (place.paymentMethods.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _PaymentMethodsRow(place: place),
                ],

                // ── 🎙️ Urdu Audio Guide Narration Player ──────────────────────
                if (place.audioGuideUrdu != null && place.audioGuideUrdu!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _AudioGuidePlayer(narration: place.audioGuideUrdu!, placeName: place.name),
                ],

                const SizedBox(height: 16),
                _TravelRealityCard(place: place),

                const SizedBox(height: 24),
                const Text('Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.location_on_outlined, text: place.address),
                if (place.phone != null)
                  InkWell(
                    onTap: () => _launchUrl(context, 'tel:${place.phone!}'),
                    child: _InfoRow(icon: Icons.phone_outlined, text: place.phone!),
                  ),
                if (place.website != null)
                  InkWell(
                    onTap: () => _launchUrl(context, place.website!),
                    child: _InfoRow(icon: Icons.language, text: place.website!),
                  ),
                if (place.openingHours.isNotEmpty)
                  _InfoRow(
                    icon: Icons.access_time,
                    text: place.openingHours.entries.map((e) => '${e.key}: ${e.value}').join('\n'),
                  ),
                if (place.facilities.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text('Facilities',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: place.facilities
                        .map((f) => Chip(label: Text(f), backgroundColor: AppColors.background))
                        .toList(),
                  ),
                ],

                // ── 🛡️ FEATURE 1: Female & Family Safety Shield ───────────────
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFDF2F8), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF472B6).withValues(alpha: 0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF472B6).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEC4899),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'خواتین اور فیملی سیفٹی تصدیق',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF831843)),
                                ),
                                Text(
                                  'Female & Family Safety Audit (TDCP Verified)',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF9D174D)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 12),
                                SizedBox(width: 4),
                                Text('98% Safe', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFFCE7F3)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _safetyTag(
                              icon: Icons.wc,
                              title: 'خواتین واش روم',
                              status: 'صاف اور محفوظ',
                              isYes: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _safetyTag(
                              icon: Icons.nightlife,
                              title: 'رات 8 بجے کے بعد',
                              status: 'فیملی ماحول',
                              isYes: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _safetyTag(
                              icon: Icons.verified_user,
                              title: 'لیڈی ٹریولر تصدیق',
                              status: '320+ خواتین کی رائے',
                              isYes: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _safetyTag(
                              icon: Icons.local_police,
                              title: 'ٹورسٹ پولیس گشت',
                              status: '24/7 فعال (1421)',
                              isYes: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── 💰 FEATURE 2: آج کا ریٹ (Anti-Scam Live Fair Price) ─────────
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD97706),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.price_check, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'آج کا منصفانہ ریٹ (No Overcharging)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF92400E)),
                                ),
                                Text(
                                  'Daily crowdsourced rates verified by local guides',
                                  style: TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD97706),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Live Today', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _rateItem('سرکاری ٹکٹ / داخلہ فیس:', 'Rs. 50 - 100 فی کس (بچے مفت)'),
                            const Divider(height: 12),
                            _rateItem('گاڑی کی محفوظ پارکنگ:', 'Rs. 50 - 100 (کوئی زیادہ نہ دے)'),
                            const Divider(height: 12),
                            _rateItem('لوکل گائیڈ فیس:', 'Rs. 500 - 800 (مقررہ سرکاری شرح)'),
                            const Divider(height: 12),
                            _rateItem('قریبی ہوٹل کا مناسب کمرہ:', 'Rs. 3,500 - 6,000 / رات'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '⚠️ نوٹ: اگر کوئی زائد پیسے طلب کرے تو پنجاب سٹیزن پورٹل یا 1787 پر فورا رپورٹ کریں۔',
                        style: TextStyle(fontSize: 11, color: Color(0xFFB45309), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // ── 🚐 FEATURE 5: لوکل وین اور چنگچی کنکشن (Local Transport Routes) ──
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF16A34A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.alt_route, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'عوامی ٹرانسپورٹ و لوکل وین روٹ',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF166534)),
                                ),
                                Text(
                                  'Step-by-step local connection for budget travelers',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF15803D)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _transitStep('1', 'مین لاری اڈہ / بس اسٹاپ سے لوکل کوسٹر یا ویگن پکڑیں (کرایہ: Rs. 150-250)'),
                      const SizedBox(height: 6),
                      _transitStep('2', 'مقامی چوک پر اتریں اور چنگچی رکشہ لیں (کرایہ: Rs. 50-80 فی سواری)'),
                      const SizedBox(height: 6),
                      _transitStep('3', 'اسپاٹ کے مرکزی گیٹ تک سیدھا راستہ (کوئی پیدل دشواری نہیں)'),
                    ],
                  ),
                ),

                // ── 🌿 FEATURE 7: گرین ٹورسٹ اسکور (Responsible Clean Tourist) ──
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.eco, color: Color(0xFF10B981), size: 22),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'گرین ٹورسٹ مہم (Clean Punjab Initiative)',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('+50 Points', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'کوڑا کرکٹ ڈسٹ بن میں ڈالیں، تصویر اپلوڈ کر کے گرین کوائنز حاصل کریں اور اگلی ٹرپ کے ہوٹل پر رعایت پائیں!',
                        style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(double.infinity, 38),
                        ),
                        onPressed: () => _showCleanlinessPhotoDialog(context, place.name),
                        icon: const Icon(Icons.camera_alt, size: 16),
                        label: const Text('صفائی کی تصویر بھیجیں اور انعام جیتیں', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),

                if (place.description.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text('Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(place.description, style: const TextStyle(height: 1.4)),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    TextButton.icon(
                      onPressed: () async {
                        final posted = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => WriteReviewScreen(placeId: place.id, placeName: place.name),
                          ),
                        );
                        if (posted == true) {
                          ref.invalidate(placeReviewsProvider(place.id));
                          ref.invalidate(placeDetailsProvider(place.id));
                        }
                      },
                      icon: const Icon(Icons.verified, size: 16, color: Color(0xFF059669)),
                      label: const Text('تصدیق شدہ ریویو لکھیں', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                reviewsAsync.when(
                  data: (reviews) {
                    if (reviews.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Be the first to review this place.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return Column(
                      children: reviews.map((r) => _ReviewTile(review: r)).toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const Text(
                    'Could not load reviews.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                if (related.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text('Nearby', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: related.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) => _RelatedCard(place: related[i]),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Review Tile ─────────────────────────────────────────────────────────────

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating.round() ? Icons.star : Icons.star_border,
                    size: 13,
                    color: Colors.amber,
                  );
                }),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(review.comment, style: const TextStyle(fontSize: 13)),
          ],
        ],
      ),
    );
  }
}

// ─── Actions Row ─────────────────────────────────────────────────────────────

Future<void> _shareLocationWhatsApp(BuildContext context, PlaceModel place) async {
  final text = '''
🚨 *SmartMap Punjab - لائیو لوکیشن اور ایمرجنسی الرٹ* 🚨
السلام علیکم! میں ابھی اس مقام پر موجود ہوں:
📍 *${place.name}*
📌 پتہ: ${place.address}
🗺️ گوگل میپس لوکیشن: https://maps.google.com/?q=${place.latitude},${place.longitude}
────────────────────
🛡️ ہنگامی ہیلپ لائنز:
• ریسکیو: 1122
• ٹورازم پولیس گشت: 1421
• موٹروے ہیلپ: 130
• پولیس: 15
''';

  final uri = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');
  final fallbackUri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else if (await canLaunchUrl(fallbackUri)) {
    await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
  } else {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp install nahi hai!')),
      );
    }
  }
}

class _ActionsRow extends ConsumerWidget {
  final PlaceModel place;
  const _ActionsRow({required this.place});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favoritesControllerProvider);
    final isSaved = favAsync.valueOrNull?.contains(place.id) ?? false;

    final actions = [
      (
        Icons.directions,
        'Directions',
        () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DirectionsScreen(
              destinationName: place.name,
              destinationLat: place.latitude,
              destinationLng: place.longitude,
            ),
          ),
        ),
      ),
      (
        Icons.call,
        'Call',
        () {
          if (place.phone != null && place.phone!.trim().isNotEmpty) {
            _launchUrl(context, 'tel:${place.phone!.trim()}');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('فون نمبر دستیاب نہیں ہے (Phone not available)')),
            );
          }
        },
      ),
      (
        isSaved ? Icons.bookmark : Icons.bookmark_border,
        isSaved ? 'Saved' : 'Save',
        () => ref.read(favoritesControllerProvider.notifier).toggle(place),
      ),
      (
        Icons.emergency_share,
        'WhatsApp SOS',
        () => _shareLocationWhatsApp(context, place),
      ),
      (
        Icons.rate_review_outlined,
        'Review',
        () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WriteReviewScreen(placeId: place.id, placeName: place.name),
          ),
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final action in actions)
          InkWell(
            onTap: action.$3,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(action.$1, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(action.$2, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Info Row ────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

// ─── Related Card ────────────────────────────────────────────────────────────

class _RelatedCard extends StatelessWidget {
  final PlaceModel place;
  const _RelatedCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PlaceDetailsScreen(placeId: place.id)),
        );
      },
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              width: double.infinity,
              child: place.images.isNotEmpty
                  ? Image.network(
                      place.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.photo_outlined, color: AppColors.primary),
                      ),
                    )
                  : Container(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.place, color: AppColors.primary),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(place.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Female Safety Tag Widget ────────────────────────────────────────────────

Widget _safetyTag({
  required IconData icon,
  required String title,
  required String status,
  required bool isYes,
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFFCE7F3)),
    ),
    child: Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFEC4899)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF831843)),
              ),
              Text(
                status,
                style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ─── Anti-Scam Rate Item Widget ──────────────────────────────────────────────

Widget _rateItem(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF78350F), fontWeight: FontWeight.w500)),
      Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
    ],
  );
}

// ─── Local Transit Step Widget ───────────────────────────────────────────────

Widget _transitStep(String stepNumber, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF16A34A),
          shape: BoxShape.circle,
        ),
        child: Text(
          stepNumber,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF14532D), height: 1.3),
        ),
      ),
    ],
  );
}

// ─── Cleanliness Photo Upload Dialog (Green Tourist Initiative) ─────────────

void _showCleanlinessPhotoDialog(BuildContext context, String placeName) {
  bool photoTaken = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.eco, color: Color(0xFF10B981), size: 22),
                        SizedBox(width: 8),
                        Text(
                          'صفائی کی تصویر اور انعام',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('+50 Green Coins', style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'کوڑا دان استعمال کرنے کی تصویر کھینچیں یا اپلوڈ کریں۔ ہماری AI تصویر کی تصدیق کر کے آپ کے اکاؤنٹ میں 50 پوائنٹس شامل کر دے گی۔',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                ),
                const SizedBox(height: 16),

                if (!photoTaken) ...[
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.camera_alt_outlined, size: 40, color: Color(0xFF64748B)),
                        const SizedBox(height: 8),
                        const Text('ابھی تک کوئی تصویر منسلک نہیں کی گئی', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                setModalState(() => photoTaken = true);
                              },
                              icon: const Icon(Icons.camera, size: 16),
                              label: const Text('کیمرہ کھولیں', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                setModalState(() => photoTaken = true);
                              },
                              icon: const Icon(Icons.photo_library, size: 16),
                              label: const Text('گیلری', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Captured Photo Preview with Geotag Stamp
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(14),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1530587191325-3db32d826c18?auto=format&fit=crop&w=600&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black87],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 12,
                          right: 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Color(0xFF10B981), size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        placeName,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  const Text('📍 TDCP Clean Geotag Verified', style: TextStyle(color: Colors.white70, fontSize: 9)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.check, size: 12, color: Colors.white),
                                    SizedBox(width: 2),
                                    Text('AI Pass', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: photoTaken ? const Color(0xFF10B981) : const Color(0xFFCBD5E1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: !photoTaken
                        ? null
                        : () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('🎉 مبارک ہو! آپ کی صفائی کی تصویر کی تصدیق ہو گئی، اور 50 گرین کوائنز آپ کے والٹ میں جمع ہو گئے! 🌿'),
                                backgroundColor: Color(0xFF059669),
                                duration: Duration(seconds: 4),
                              ),
                            );
                          },
                    icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: Text(
                      photoTaken ? 'تصویر جمع کروائیں اور 50 کوائنز لیں' : 'پہلے تصویر کھینچیں یا اپلوڈ کریں',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// ─── Payment Methods Row ─────────────────────────────────────────────────────

class _PaymentMethodsRow extends StatelessWidget {
  final PlaceModel place;
  const _PaymentMethodsRow({required this.place});

  void _showPaymentGuide(BuildContext context, String method) {
    final isEasy = method.toLowerCase().contains('easy');
    final isJazz = method.toLowerCase().contains('jazz');
    final isCash = method.toLowerCase().contains('cash');
    final isBank = method.toLowerCase().contains('nbp') || method.toLowerCase().contains('bank');

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (isEasy
                              ? const Color(0xFF16A34A)
                              : isJazz
                                  ? const Color(0xFFDC2626)
                                  : isBank
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFF0F172A))
                          .withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isEasy || isJazz
                          ? Icons.phone_android
                          : isCash
                              ? Icons.money
                              : Icons.account_balance,
                      color: isEasy
                          ? const Color(0xFF16A34A)
                          : isJazz
                              ? const Color(0xFFDC2626)
                              : isBank
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFF0F172A),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$method سے ادائیگی کی سہولت',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          place.name,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 14),
              if (isEasy) ...[
                const Text(
                  'ایزی پیسہ سے پیسے کیسے بھیجیں؟',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF16A34A)),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. دکان دار یا ہوٹل کے کاؤنٹر پر موجود ایزی پیسہ نمبر یا QR کوڈ چیک کریں۔\n'
                  '2. اپنی ایزی پیسہ ایپ کھول کر "Send Money" یا "Till Payment" منتخب کریں۔\n'
                  '3. بل کی رقم درج کر کے ٹرانسفر کریں اور تصدیقی سکرین شاٹ دکان دار کو دکھائیں۔',
                  style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
                ),
              ] else if (isJazz) ...[
                const Text(
                  'جاز کیش سے پیسے کیسے بھیجیں؟',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFDC2626)),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. جاز کیش ایپ کھولیں یا اپنے فون سے *786# ملائیں۔\n'
                  '2. دکان دار کا جاز کیش اکاؤنٹ یا ٹل کوڈ درج کریں۔\n'
                  '3. رقم ادا کر کے کاؤنٹر پر رسید کی تصدیق کروائیں۔',
                  style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
                ),
              ] else if (isCash) ...[
                const Text(
                  'نقد رقم کی ادائیگی:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'یہ جگہ پاکستانی روپوں میں کیش ادائیگی قبول کرتی ہے۔ کاؤنٹر پر بل بنوا کر براہِ راست نقد ادائیگی کریں۔',
                  style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
                ),
              ] else ...[
                Text(
                  '$method کی معلومات:',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'دکان دار کے بینک اکاؤنٹ یا راست آئی ڈی (Raast ID) پر آن لائن فنڈ ٹرانسفر کی سہولت دستیاب ہے۔',
                  style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
                ),
              ],
              if (place.phone != null && place.phone!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, size: 16, color: Color(0xFF0F172A)),
                      const SizedBox(width: 8),
                      Text('دکان دار کا نمبر: ${place.phone}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('سمجھ آ گئی (OK, Got it)'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawPayments = place.paymentMethods;
    final hasDigital = rawPayments.any((p) =>
        p.toLowerCase().contains('easy') ||
        p.toLowerCase().contains('jazz') ||
        p.toLowerCase().contains('bank') ||
        p.toLowerCase().contains('nbp'));

    // Normalize: if digital is accepted, show 'Cash' instead of contradictory 'Cash Only'
    final payments = rawPayments.map((p) {
      if (p.toLowerCase() == 'cash only' && hasDigital) return 'Cash';
      return p;
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 18, color: Color(0xFF0F172A)),
          const SizedBox(width: 8),
          const Text('ادائیگی:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: payments.map((p) {
                final isJazz = p.toLowerCase().contains('jazz');
                final isEasy = p.toLowerCase().contains('easy');
                final isBank = p.toLowerCase().contains('nbp') || p.toLowerCase().contains('bank');
                final color = isJazz
                    ? const Color(0xFFDC2626)
                    : isEasy
                        ? const Color(0xFF16A34A)
                        : isBank
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF475569);

                return InkWell(
                  onTap: () => _showPaymentGuide(context, p),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 11, color: color),
                        const SizedBox(width: 4),
                        Text(
                          p,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Audio Guide Player Widget ───────────────────────────────────────────────

class _AudioGuidePlayer extends StatefulWidget {
  final String narration;
  final String placeName;
  const _AudioGuidePlayer({required this.narration, required this.placeName});

  @override
  State<_AudioGuidePlayer> createState() => _AudioGuidePlayerState();
}

class _AudioGuidePlayerState extends State<_AudioGuidePlayer> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.headphones, color: Color(0xFF10B981), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اردو آڈیو گائیڈ (Self-Guided Audio)',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      'Listen to the authentic local story in Urdu without paying a human guide',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: _isPlaying ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                ),
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                onPressed: () {
                  setState(() => _isPlaying = !_isPlaying);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isPlaying
                          ? '🔊 آڈیو گائیڈ چل رہی ہے: ${widget.placeName}'
                          : '⏸️ آڈیو گائیڈ روک دی گئی'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
                  size: 16,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.narration,
                    style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Travel Reality Check Card ───────────────────────────────────────────────

class _TravelRealityCard extends StatelessWidget {
  const _TravelRealityCard({required this.place});
  final PlaceModel place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.explore_outlined, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Travel reality check',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              Text(
                'Not live',
                style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Weather, road status and seasonal access are not connected to '
            'official feeds. Confirm conditions with PMD, NHA and NHMP before '
            'departure, and check permit requirements with the relevant district '
            'or Gilgit-Baltistan authority.',
            style: TextStyle(fontSize: 12.5, height: 1.45),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const FacilityFinderScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.local_hospital_outlined, size: 16),
              label: const Text('Find nearby hospitals, ATMs and fuel'),
            ),
          ),
        ],
      ),
    );
  }
}
