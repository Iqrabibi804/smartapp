import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../places/models/place_model.dart';
import '../../places/screens/place_details_screen.dart';
import '../services/favorites_service.dart';

class SavedPlacesScreen extends ConsumerWidget {
  const SavedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesControllerProvider);
    final controller = ref.read(favoritesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Places')),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: favoritesAsync.when(
          data: (_) {
            final places = controller.places;
            if (places.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  _EmptyState(),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _SavedPlaceCard(place: places[i]),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: [
              const SizedBox(height: 120),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Could not load saved places.\nPull down to try again.',
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border, size: 56, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            const Text(
              "You haven't saved any places yet.",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap the bookmark icon on any place to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedPlaceCard extends ConsumerWidget {
  final PlaceModel place;
  const _SavedPlaceCard({required this.place});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PlaceDetailsScreen(placeId: place.id)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.place, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (place.hasReviews) ...[
                        const Icon(Icons.star, size: 13, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(place.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12)),
                      ] else
                        const Text('No reviews yet',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.bookmark, color: AppColors.primary),
              onPressed: () => ref.read(favoritesControllerProvider.notifier).toggle(place),
            ),
          ],
        ),
      ),
    );
  }
}
