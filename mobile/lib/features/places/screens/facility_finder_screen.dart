import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../models/place_model.dart';
import '../services/places_providers.dart';
import 'place_details_screen.dart';
import 'police_directory_screen.dart';

class FacilityType {
  const FacilityType({
    required this.label,
    required this.icon,
    this.query,
    this.categoryName,
  });

  final String label;
  final IconData icon;
  final String? query;
  final String? categoryName;

  String get cacheKey => '$label|${query ?? ''}|${categoryName ?? ''}';
}

const List<FacilityType> kFacilityTypes = [
  FacilityType(
    label: 'Hospitals',
    icon: Icons.local_hospital_rounded,
    categoryName: 'Hospitals & Medical',
  ),
  FacilityType(label: 'Pharmacies', icon: Icons.medication_rounded, query: 'pharmacy'),
  FacilityType(label: 'Petrol pumps', icon: Icons.local_gas_station_rounded, query: 'petrol'),
  FacilityType(label: 'ATMs', icon: Icons.atm_rounded, query: 'ATM'),
  FacilityType(label: 'Police', icon: Icons.local_police_rounded, query: 'police'),
  FacilityType(label: 'Parking', icon: Icons.local_parking_rounded, query: 'parking'),
  FacilityType(
    label: 'Restaurants',
    icon: Icons.restaurant_rounded,
    categoryName: 'Restaurants',
  ),
  FacilityType(label: 'Washrooms', icon: Icons.wc_rounded, query: 'washroom'),
  FacilityType(label: 'Drinking water', icon: Icons.water_drop_rounded, query: 'drinking water'),
];

final facilityResultsProvider =
    FutureProvider.family<List<PlaceModel>, FacilityType>((ref, type) {
  return ref.watch(placesServiceProvider).search(
        query: type.query,
        categoryName: type.categoryName,
      );
});

String facilityVerificationLabel(PlaceModel place) {
  switch (place.verificationStatus) {
    case 'verified':
      return 'Verified';
    case 'community_reported':
      return 'Community reported';
    case 'needs_verification':
      return 'Needs verification';
    default:
      return 'Not verified';
  }
}

class FacilityFinderScreen extends ConsumerStatefulWidget {
  const FacilityFinderScreen({super.key, this.initialType});

  final FacilityType? initialType;

  @override
  ConsumerState<FacilityFinderScreen> createState() => _FacilityFinderScreenState();
}

class _FacilityFinderScreenState extends ConsumerState<FacilityFinderScreen> {
  late FacilityType _selected = widget.initialType ?? kFacilityTypes.first;

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(facilityResultsProvider(_selected));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTokens.surfaceDark : Colors.white;
    final borderColor = isDark ? AppTokens.borderDark : AppTokens.border;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Essential facilities',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'Directory data — no live availability',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              scrollDirection: Axis.horizontal,
              itemCount: kFacilityTypes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final type = kFacilityTypes[index];
                final active = type.cacheKey == _selected.cacheKey;
                return ChoiceChip(
                  selected: active,
                  onSelected: (_) => setState(() => _selected = type),
                  avatar: Icon(
                    type.icon,
                    size: 16,
                    color: active ? Colors.white : AppTokens.emerald,
                  ),
                  label: Text(type.label),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: active ? Colors.white : null,
                  ),
                  selectedColor: AppTokens.emerald,
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTokens.warning.withValues(alpha: isDark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppTokens.warning.withValues(alpha: 0.3)),
            ),
            child: const Text(
              'Results come from the saved directory. A listing does not confirm '
              'that a facility is open, stocked or currently operating — call '
              'ahead where a phone number is shown.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
          if (_selected.label == 'Police')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PoliceDirectoryScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.account_tree_outlined),
                  label: const Text('Open Islamabad & Lahore police directory'),
                ),
              ),
            ),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const _EmptyState(
                title: 'Facility information unavailable',
                message: 'The directory could not be loaded. Check your '
                    'connection or try again later.',
              ),
              data: (places) {
                if (places.isEmpty) {
                  return _EmptyState(
                    title: 'No ${_selected.label.toLowerCase()} found',
                    message: 'The saved directory has no matching entries. This '
                        'is not a confirmation that none exist nearby. '
                        'Information unavailable.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: borderColor),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        leading: CircleAvatar(
                          backgroundColor:
                              AppTokens.emerald.withValues(alpha: 0.1),
                          child: Icon(_selected.icon,
                              color: AppTokens.emerald, size: 20),
                        ),
                        title: Text(
                          place.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                place.address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Verification: ${facilityVerificationLabel(place)}'
                                '${place.lastVerifiedAt != null ? ' · last verified ${_dateOnly(place.lastVerifiedAt!)}' : ' · verification date not recorded'}'
                                '${place.phone != null ? ' · ${place.phone}' : ''}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTokens.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  PlaceDetailsScreen(placeId: place.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

String _dateOnly(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  final d = parsed.day.toString().padLeft(2, '0');
  final m = parsed.month.toString().padLeft(2, '0');
  return '$d/$m/${parsed.year}';
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 36, color: AppTokens.textSecondary),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: AppTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
