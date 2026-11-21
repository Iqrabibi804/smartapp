import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/location_service.dart';
import '../../categories/models/category_model.dart';
import '../../categories/services/categories_service.dart';
import '../../places/models/place_model.dart';
import '../../places/screens/place_details_screen.dart';
import '../../places/services/places_providers.dart';
import '../../map/screens/map_screen.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String? initialCategoryId;
  final String? initialCategoryName;
  final String? initialCity;
  final String? initialQuery;

  const SearchResultsScreen({
    super.key,
    this.initialCategoryId,
    this.initialCategoryName,
    this.initialCity,
    this.initialQuery,
  });

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final _searchController = TextEditingController();
  final LocationService _locationService = LocationService();
  String _selectedCity = 'All Cities';
  bool _isLocating = false;
  String? _statusBanner;

  static const _cities = [
    'All Cities',
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Murree',
    'Gujranwala',
    'Sialkot',
    'Bahawalpur',
    'Attock',
    'Chakwal',
  ];

  @override
  void initState() {
    super.initState();
    final controller = ref.read(searchControllerProvider.notifier);

    if (widget.initialCity != null && widget.initialCity!.isNotEmpty) {
      _selectedCity = widget.initialCity!;
      _statusBanner = 'Filtered by $_selectedCity';
    }

    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
    }

    controller.updateFilters((f) => f.copyWith(
          categoryId: widget.initialCategoryId,
          categoryName: widget.initialCategoryName,
          city: widget.initialCity != null && widget.initialCity != 'All Cities' ? widget.initialCity : null,
          query: widget.initialQuery ?? '',
        ));

    Future.microtask(() async {
      // Resolve category ID by name if needed
      if (widget.initialCategoryId == null && widget.initialCategoryName != null) {
        final categories = await ref.read(categoriesProvider.future);
        final match = categories.firstWhere(
          (c) =>
              c.name.toLowerCase() == widget.initialCategoryName!.toLowerCase() ||
              c.name.toLowerCase().contains(widget.initialCategoryName!.toLowerCase()) ||
              widget.initialCategoryName!.toLowerCase().contains(c.name.toLowerCase()),
          orElse: () => CategoryModel(id: '', name: '', icon: ''),
        );
        if (match.id.isNotEmpty) {
          controller.updateFilters((f) => f.copyWith(categoryId: match.id));
        }
      }
      controller.run();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runSearch({double? lat, double? lng}) {
    ref.read(searchControllerProvider.notifier).run(lat: lat, lng: lng);
  }

  Future<void> _traceCurrentLocation() async {
    setState(() {
      _isLocating = true;
      _statusBanner = 'Detecting your GPS location to trace nearby places...';
    });

    final result = await _locationService.getCurrentLocation();
    if (!mounted) return;

    if (result.status == LocationStatus.granted && result.position != null) {
      final pos = result.position!;
      setState(() {
        _isLocating = false;
        _statusBanner = 'Showing places nearest to your live location 📍';
      });
      _runSearch(lat: pos.latitude, lng: pos.longitude);
    } else {
      setState(() {
        _isLocating = false;
        _statusBanner = 'Could not access GPS. Please select your city above.';
      });
    }
  }

  void _onCitySelected(String city) {
    setState(() {
      _selectedCity = city;
      _statusBanner = city == 'All Cities' ? null : 'Filtered by $city';
    });
    ref.read(searchControllerProvider.notifier).updateFilters(
          (f) => f.copyWith(
            city: city == 'All Cities' ? null : city,
            clearCity: city == 'All Cities',
          ),
        );
    _runSearch();
  }

  void _openFilters() async {
    final categoriesAsync = ref.read(categoriesProvider);
    final result = await showModalBottomSheet<SearchFilters>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterSheet(
        current: ref.read(searchControllerProvider.notifier).filters,
        categories: categoriesAsync.value ?? [],
      ),
    );

    if (result != null) {
      ref.read(searchControllerProvider.notifier).filters = result;
      _runSearch();
    }
  }

  void _showComplaintAndHelplineModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.support_agent, color: Color(0xFF0F172A), size: 28),
                SizedBox(width: 10),
                Text(
                  'Tourist Complaints & Official Helplines',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'File official tourist complaints or contact emergency authorities:',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            _helplineTile('Pakistan Citizen Portal (Complaints)', 'Online Portal', Icons.account_balance, () {
              launchUrl(Uri.parse('https://citizenportal.gov.pk'), mode: LaunchMode.externalApplication);
            }),
            _helplineTile('Punjab CM Grievance Cell', 'complaint.punjab.gov.pk', Icons.public, () {
              launchUrl(Uri.parse('https://complaint.punjab.gov.pk'), mode: LaunchMode.externalApplication);
            }),
            _helplineTile('Tourist Police Helpline', 'Dial 15 or 1787', Icons.local_police, () {
              launchUrl(Uri.parse('tel:15'));
            }),
            _helplineTile('Rescue 1122 Medical / Ambulance', 'Dial 1122', Icons.emergency, () {
              launchUrl(Uri.parse('tel:1122'));
            }),
          ],
        ),
      ),
    );
  }

  Widget _helplineTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0F172A)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchControllerProvider);
    final filters = ref.watch(searchControllerProvider.notifier).filters;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final chipBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final chipBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          widget.initialCategoryName ?? 'Search & Discover',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Tourist Complaints & Helplines',
            icon: const Icon(Icons.help_outline),
            onPressed: _showComplaintAndHelplineModal,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar & Filter Button ──
          Container(
            color: cardBgColor,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: primaryTextColor),
                    decoration: InputDecoration(
                      hintText: 'Search places, clinics, cakes...',
                      hintStyle: TextStyle(color: secondaryTextColor),
                      prefixIcon: Icon(Icons.search, size: 20, color: secondaryTextColor),
                      filled: true,
                      fillColor: chipBgColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      ref
                          .read(searchControllerProvider.notifier)
                          .updateFilters((f) => f.copyWith(query: value));
                      _runSearch();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: _openFilters,
                  icon: const Icon(Icons.tune),
                  style: IconButton.styleFrom(
                    backgroundColor: filters.hasActiveFilters
                        ? const Color(0xFF10B981).withValues(alpha: 0.15)
                        : chipBgColor,
                    foregroundColor: filters.hasActiveFilters
                        ? const Color(0xFF059669)
                        : primaryTextColor,
                  ),
                ),
              ],
            ),
          ),

          // ── Cities Horizontal Selector & GPS Near Me ──
          Container(
            color: cardBgColor,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Cities / Locations:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: secondaryTextColor),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: _isLocating ? null : _traceCurrentLocation,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            if (_isLocating)
                              const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF059669)),
                              )
                            else
                              const Icon(Icons.my_location, size: 14, color: Color(0xFF059669)),
                            const SizedBox(width: 4),
                            const Text(
                              'Near Me (GPS)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cities.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final city = _cities[i];
                      final isSelected = _selectedCity.toLowerCase() == city.toLowerCase();
                      return GestureDetector(
                        onTap: () => _onCitySelected(city),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF059669) : chipBgColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF059669) : chipBorderColor,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF059669).withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                const Icon(Icons.check, size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                city,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF1E293B)),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Status message if GPS / filtered
          if (_statusBanner != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFECFDF5),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Color(0xFF059669)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _statusBanner!,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF065F46), fontWeight: FontWeight.w600),
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _statusBanner = null),
                    child: const Icon(Icons.close, size: 14, color: Color(0xFF065F46)),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 6),

          // ── Search Results List ──
          Expanded(
            child: resultsAsync.when(
              data: (places) {
                if (places.isEmpty) {
                  return _EmptyState(
                    categoryName: widget.initialCategoryName,
                    cityName: _selectedCity,
                    onReset: () {
                      _onCitySelected('All Cities');
                      _searchController.clear();
                      ref.read(searchControllerProvider.notifier).updateFilters(
                            (f) => const SearchFilters(),
                          );
                      _runSearch();
                    },
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _PlaceCard(
                    place: places[i],
                    categoryHint: widget.initialCategoryName,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        friendlyErrorMessage(e),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => _runSearch(),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String? categoryName;
  final String? cityName;
  final VoidCallback onReset;

  const _EmptyState({this.categoryName, this.cityName, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 56, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              'No ${categoryName ?? "places"} found in ${cityName == "All Cities" ? "Punjab" : cityName}.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Try switching cities above or clearing specific filters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final String? categoryHint;

  const _PlaceCard({required this.place, this.categoryHint});

  Future<void> _makeCall(BuildContext context, String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleaned');
    try {
      await launchUrl(uri);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open dialer for $phone')),
        );
      }
    }
  }

  Future<void> _openDelivery(BuildContext context) async {
    // Open Foodpanda or official bakery website
    final url = place.website ?? 'https://www.foodpanda.pk';
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $url...')),
        );
      }
    }
  }

  void _openOnMap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MapScreen(
          initialCenter: LatLng(place.latitude, place.longitude),
          initialPlace: place,
        ),
      ),
    );
  }

  bool get _isBakery =>
      (categoryHint?.toLowerCase().contains('baker') ?? false) ||
      (categoryHint?.toLowerCase().contains('cake') ?? false) ||
      place.name.toLowerCase().contains('baker') ||
      place.name.toLowerCase().contains('cake') ||
      place.name.toLowerCase().contains('cuisine') ||
      place.name.toLowerCase().contains('layers');

  bool get _isHospital =>
      (categoryHint?.toLowerCase().contains('hospital') ?? false) ||
      (categoryHint?.toLowerCase().contains('medical') ?? false) ||
      place.name.toLowerCase().contains('hospital') ||
      place.name.toLowerCase().contains('medical') ||
      place.name.toLowerCase().contains('clinic') ||
      place.name.toLowerCase().contains('pims');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderColor = isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.06);

    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PlaceDetailsScreen(placeId: place.id)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: place.images.isNotEmpty
                            ? Image.network(
                                place.images.first,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFF0F172A).withValues(alpha: 0.08),
                                  child: Icon(
                                    _isHospital
                                        ? Icons.local_hospital
                                        : _isBakery
                                            ? Icons.cake
                                            : Icons.place,
                                    color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                                    size: 32,
                                  ),
                                ),
                              )
                            : Container(
                                color: isDark ? const Color(0xFF0F172A) : const Color(0xFF0F172A).withValues(alpha: 0.08),
                                child: Icon(
                                  _isHospital
                                      ? Icons.local_hospital
                                      : _isBakery
                                          ? Icons.cake
                                          : Icons.place,
                                  color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                                  size: 32,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  place.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryTextColor),
                                ),
                              ),
                              if (place.verified)
                                const Icon(Icons.verified, size: 16, color: Color(0xFF059669)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            place.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: secondaryTextColor, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              if (place.hasReviews) ...[
                                const Icon(Icons.star, size: 14, color: Colors.amber),
                                const SizedBox(width: 3),
                                Text(
                                  '${place.rating.toStringAsFixed(1)} (${place.reviewCount})',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryTextColor),
                                ),
                              ] else
                                Text(
                                  'No reviews yet',
                                  style: TextStyle(fontSize: 12, color: primaryTextColor.withValues(alpha: 0.7)),
                                ),
                              const SizedBox(width: 10),
                              if (_isHospital)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '24/7 Emergency',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                                  ),
                                )
                              else if (_isBakery)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.pink.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Fresh Cakes',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ── Payment & Safety Badges ──
                if (place.paymentMethods.isNotEmpty || place.isFemaleSafe) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (place.isFemaleSafe)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEC4899).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shield, size: 10, color: Color(0xFFEC4899)),
                              SizedBox(width: 3),
                              Text('خواتین محفوظ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFBE185D))),
                            ],
                          ),
                        ),
                      if (_isHospital)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.health_and_safety, size: 10, color: Color(0xFF059669)),
                              SizedBox(width: 3),
                              Text('صحت کارڈ / فری ایمرجنسی',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF047857))),
                            ],
                          ),
                        )
                      else
                        for (final pm in place.paymentMethods)
                          if (pm.toLowerCase().contains('jazz') || pm.toLowerCase().contains('easy'))
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: pm.toLowerCase().contains('jazz')
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, size: 10,
                                      color: pm.toLowerCase().contains('jazz') ? Colors.red : Colors.green),
                                  const SizedBox(width: 3),
                                  Text(
                                    pm,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: pm.toLowerCase().contains('jazz')
                                          ? Colors.red.shade700
                                          : Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Divider(height: 1, color: isDark ? const Color(0xFF334155) : Colors.black12),
                const SizedBox(height: 8),

                // ── Direct Actions Row (Call, Directions, Order Online) ──
                Row(
                  children: [
                    if (place.phone != null && place.phone!.isNotEmpty) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF059669),
                            side: const BorderSide(color: Color(0xFF059669)),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _makeCall(context, place.phone!),
                          icon: const Icon(Icons.phone, size: 16),
                          label: Text(
                            'Call ${place.phone!.split(' ').take(2).join(' ')}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    if (_isBakery) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBE185D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _openDelivery(context),
                          icon: const Icon(Icons.delivery_dining, size: 16),
                          label: const Text(
                            'Order Online',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    IconButton.filledTonal(
                      tooltip: 'View on Map & Directions',
                      style: IconButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFF0F172A).withValues(alpha: 0.08),
                        foregroundColor: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                      ),
                      onPressed: () => _openOnMap(context),
                      icon: const Icon(Icons.directions, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final SearchFilters current;
  final List<CategoryModel> categories;
  const _FilterSheet({required this.current, required this.categories});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late SearchFilters _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => setState(() => _draft = const SearchFilters()),
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.categories.map((cat) {
              final selected = _draft.categoryId == cat.id;
              return ChoiceChip(
                label: Text(cat.name),
                selected: selected,
                selectedColor: const Color(0xFF059669),
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide(color: selected ? const Color(0xFF059669) : const Color(0xFFCBD5E1)),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12,
                ),
                onSelected: (val) {
                  setState(() {
                    _draft = _draft.copyWith(
                      categoryId: val ? cat.id : null,
                      categoryName: val ? cat.name : null,
                      clearCategory: !val,
                      clearCategoryName: !val,
                    );
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [3.0, 4.0, 4.5].map((r) {
              final selected = _draft.minRating == r;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text('$r+ ★'),
                  selected: selected,
                  selectedColor: const Color(0xFF059669),
                  backgroundColor: const Color(0xFFF1F5F9),
                  side: BorderSide(color: selected ? const Color(0xFF059669) : const Color(0xFFCBD5E1)),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF1E293B),
                    fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    setState(() {
                      _draft = _draft.copyWith(
                        minRating: val ? r : null,
                        clearRating: !val,
                      );
                    });
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Pakistani Filters (پاکستانی فلٹرز)', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Easypaisa 🟢'),
                selected: _draft.acceptsEasypaisa == true,
                selectedColor: const Color(0xFF16A34A),
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide(color: _draft.acceptsEasypaisa == true ? const Color(0xFF16A34A) : const Color(0xFFCBD5E1)),
                labelStyle: TextStyle(
                  color: _draft.acceptsEasypaisa == true ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: _draft.acceptsEasypaisa == true ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12,
                ),
                onSelected: (val) {
                  setState(() {
                    _draft = _draft.copyWith(
                      acceptsEasypaisa: val ? true : null,
                      clearEasypaisa: !val,
                    );
                  });
                },
              ),
              FilterChip(
                label: const Text('JazzCash 🔴'),
                selected: _draft.acceptsJazzCash == true,
                selectedColor: const Color(0xFFDC2626),
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide(color: _draft.acceptsJazzCash == true ? const Color(0xFFDC2626) : const Color(0xFFCBD5E1)),
                labelStyle: TextStyle(
                  color: _draft.acceptsJazzCash == true ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: _draft.acceptsJazzCash == true ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12,
                ),
                onSelected: (val) {
                  setState(() {
                    _draft = _draft.copyWith(
                      acceptsJazzCash: val ? true : null,
                      clearJazzCash: !val,
                    );
                  });
                },
              ),
              FilterChip(
                label: const Text('خواتین محفوظ 🛡️'),
                selected: _draft.femaleSafe == true,
                selectedColor: const Color(0xFFEC4899),
                backgroundColor: const Color(0xFFF1F5F9),
                side: BorderSide(color: _draft.femaleSafe == true ? const Color(0xFFEC4899) : const Color(0xFFCBD5E1)),
                labelStyle: TextStyle(
                  color: _draft.femaleSafe == true ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: _draft.femaleSafe == true ? FontWeight.bold : FontWeight.w600,
                  fontSize: 12,
                ),
                onSelected: (val) {
                  setState(() {
                    _draft = _draft.copyWith(
                      femaleSafe: val ? true : null,
                      clearFemaleSafe: !val,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(_draft),
              child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
