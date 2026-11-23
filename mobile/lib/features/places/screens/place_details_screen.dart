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
                    cacheWidth: 1080,
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
                    if (place.hasReviews) ...[
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${place.rating.toStringAsFixed(1)} (${place.reviewCount} reviews)'),
                    ] else
                      const Text('No reviews yet',
                          style: TextStyle(color: AppColors.textSecondary)),
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

                // Do not publish unsupported safety scores, live prices, transit fares,
                // or reward promises. These need a verified source and working data flow.
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.45)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Travel information notice',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Safety conditions, current entry fees, local transport fares, and on-site facilities are not independently verified here. Confirm these details with the venue or relevant local authority before travelling.',
                        style: TextStyle(height: 1.4, color: AppColors.textSecondary),
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
                      if (place.hasReviews) ...[
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(place.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 11)),
                      ] else
                        const Text('No reviews yet',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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
