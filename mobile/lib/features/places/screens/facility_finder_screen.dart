import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/design_tokens.dart';
import '../models/place_model.dart';
import '../services/places_providers.dart';
import '../services/osm_facilities_service.dart';
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
  FacilityType(label: 'Parks', icon: Icons.park_rounded, query: 'park'),
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
  Widget build(BuildContext context) =>
      _CityFirstEssentialsFlow(initialType: widget.initialType);

}

class _CityFirstEssentialsFlow extends ConsumerStatefulWidget {
  const _CityFirstEssentialsFlow({this.initialType});
  final FacilityType? initialType;

  @override
  ConsumerState<_CityFirstEssentialsFlow> createState() => _CityFirstEssentialsFlowState();
}

class _CityFirstEssentialsFlowState extends ConsumerState<_CityFirstEssentialsFlow> {
  late FacilityType selected = widget.initialType ?? kFacilityTypes.first;
  String? city;
  final citySearch = TextEditingController();
  final osmService = OsmFacilitiesService();
  List<PlaceModel> livePlaces = const [];
  bool loadingCity = false;
  bool locationAvailable = false;
  double? userLat;
  double? userLng;
  String locationMessage = 'Location not requested yet';

  static const cities = <(String, IconData, Color)>[
    ('Attock', Icons.account_balance_rounded, Color(0xFF1B6A4A)),
    ('Lahore', Icons.location_city_rounded, Color(0xFFB66B28)),
    ('Rawalpindi', Icons.apartment_rounded, Color(0xFF4269A8)),
    ('Islamabad', Icons.forest_rounded, Color(0xFF287F78)),
    ('Multan', Icons.mosque_rounded, Color(0xFF9363A9)),
    ('Sahiwal', Icons.agriculture_rounded, Color(0xFF688B42)),
    ('Murree', Icons.landscape_rounded, Color(0xFF4C7E9A)),
    ('Faisalabad', Icons.factory_rounded, Color(0xFF9A6A3A)),
    ('Gujranwala', Icons.storefront_rounded, Color(0xFF7C657E)),
  ];

  @override
  void dispose() {
    citySearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncPlaces = ref.watch(facilityResultsProvider(selected));
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppTokens.surfaceDark : Colors.white;
    final border = dark ? AppTokens.borderDark : AppTokens.border;
    return Scaffold(
      appBar: AppBar(
        leading: city == null ? null : IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => setState(() => city = null),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(city ?? 'Essentials', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          Text(city == null ? 'Choose a city to explore' : selected.label + ' in ' + city!,
              style: const TextStyle(fontSize: 11.5, color: AppTokens.textSecondary)),
        ]),
      ),
      body: Column(children: [
        SizedBox(height: 52, child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          scrollDirection: Axis.horizontal,
          itemCount: kFacilityTypes.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final type = kFacilityTypes[index];
            final active = type.cacheKey == selected.cacheKey;
            return ChoiceChip(
              selected: active,
              onSelected: (_) => setState(() { selected = type; city = null; livePlaces = const []; loadingCity = false; }),
              avatar: Icon(type.icon, size: 16, color: active ? Colors.white : AppTokens.emerald),
              label: Text(type.label),
              labelStyle: TextStyle(fontSize: 12, color: active ? Colors.white : null),
              selectedColor: AppTokens.emerald,
              backgroundColor: surface,
              side: BorderSide(color: active ? AppTokens.emerald : border),
            );
          },
        )),
        Expanded(
          child: city == null
              // City selection must never depend on the legacy directory request.
              // That request may be slow or fail while free OSM data is still usable.
              ? cityPicker(asyncPlaces.valueOrNull ?? const <PlaceModel>[], surface, border)
              : loadingCity
                  ? const Center(child: CircularProgressIndicator())
                  : cityResults(livePlaces, surface, border),
        ),
      ]),
    );
  }

  Future<void> selectCity(String selectedCity) async {
    setState(() {
      city = selectedCity;
      loadingCity = true;
      livePlaces = const [];
      locationAvailable = false;
      userLat = null;
      userLng = null;
      locationMessage = 'Finding nearby facilities…';
    });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 15)),
          );
          final center = cityCenter(selectedCity);
          final distanceToCity = OsmFacilitiesService.distanceKm(
            position.latitude, position.longitude, center.$1, center.$2);
          if (distanceToCity <= 45) {
            userLat = position.latitude;
            userLng = position.longitude;
            locationAvailable = true;
            locationMessage = 'Sorted nearest-first from your current location';
          } else {
            locationMessage = 'Your GPS is outside $selectedCity · showing selected-city results without nearby distance';
          }
        } else {
          locationMessage = 'Location permission unavailable · showing city map data';
        }
      } else {
        locationMessage = 'Location services are off · showing city map data';
      }
    } catch (_) {
      locationMessage = 'Could not get GPS location · showing city map data';
    }

    final fetched = await osmService.fetchCity(selectedCity, selected.label);
    if (!mounted) return;
    if (locationAvailable && userLat != null && userLng != null) {
      fetched.sort((a, b) => OsmFacilitiesService.distanceKm(userLat!, userLng!, a.latitude, a.longitude)
          .compareTo(OsmFacilitiesService.distanceKm(userLat!, userLng!, b.latitude, b.longitude)));
    }
    setState(() {
      livePlaces = fetched;
      loadingCity = false;
    });
  }

  (double, double) cityCenter(String city) => switch (city) {
    'Attock' => (33.7667, 72.3592),
    'Lahore' => (31.5204, 74.3587),
    'Rawalpindi' => (33.5651, 73.0169),
    'Islamabad' => (33.6844, 73.0479),
    'Multan' => (30.1575, 71.5249),
    'Sahiwal' => (30.6682, 73.1114),
    'Murree' => (33.9070, 73.3943),
    'Faisalabad' => (31.4504, 73.1350),
    'Gujranwala' => (32.1877, 74.1945),
    _ => (0, 0),
  };

  Widget cityPicker(List<PlaceModel> all, Color surface, Color border) {
    final shown = cities.where((c) => c.$1.toLowerCase().contains(citySearch.text.trim().toLowerCase())).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 120), children: [
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF0B5D3B), Color(0xFF16815A)]),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(children: [
          Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .15), borderRadius: BorderRadius.circular(15)),
              child: Icon(selected.icon, color: Colors.white, size: 26)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Select a City', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Browse ' + selected.label.toLowerCase() + ' by city', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
          ])),
        ]),
      ),
      const SizedBox(height: 15),
      TextField(controller: citySearch, onChanged: (_) => setState(() {}),
        decoration: InputDecoration(hintText: 'Search city', prefixIcon: const Icon(Icons.search_rounded),
          filled: true, fillColor: surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
      const SizedBox(height: 14),
      GridView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        itemCount: shown.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.sizeOf(context).width >= 650 ? 3 : 2,
          crossAxisSpacing: 12, mainAxisSpacing: 12, mainAxisExtent: 136),
        itemBuilder: (context, i) {
          final c = shown[i];
          final count = all.where((p) => matchesCity(p, c.$1)).length;
          return Material(color: surface, borderRadius: BorderRadius.circular(18),
            child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () => selectCity(c.$1),
              child: Container(padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 42, height: 42, decoration: BoxDecoration(color: c.$3.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
                    child: Icon(c.$2, color: c.$3, size: 23)),
                  const Spacer(),
                  Text(c.$1, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(all.isEmpty ? 'Live map data' : count.toString() + ' ' + countLabel(),
                    style: const TextStyle(fontSize: 11.5, color: AppTokens.textSecondary)),
                ]))));
        },
      ),
      const SizedBox(height: 12),
      const Text('Counts reflect entries currently available in the directory.', style: TextStyle(fontSize: 11, color: AppTokens.textSecondary)),
    ]);
  }

  Widget cityResults(List<PlaceModel> places, Color surface, Color border) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 120), children: [
      Text(places.length.toString() + ' ' + countLabel() + ' in ' + city!,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const SizedBox(height: 5),
      Text(locationMessage, style: const TextStyle(fontSize: 11.5, color: AppTokens.textSecondary)),
      const SizedBox(height: 10),
      const Text('OpenStreetMap data · not live operating status', style: TextStyle(fontSize: 10.5, color: AppTokens.textSecondary)),
      const SizedBox(height: 10),
      if (places.isEmpty)
        _EmptyState(title: 'No ' + selected.label.toLowerCase() + ' listed in ' + city!,
          message: 'No matching records were found in the available city dataset. This does not mean the city has none.')
      else
        ...places.map((p) => facilityCard(p, surface, border)),
      if (places.isNotEmpty) const Padding(padding: EdgeInsets.only(top: 4), child: Text('Map data © OpenStreetMap contributors', style: TextStyle(fontSize: 10, color: AppTokens.textSecondary))),
      const SizedBox(height: 20),
      faqPanel(),
    ]);
  }

  Widget facilityCard(PlaceModel p, Color surface, Color border) {
    final verified = p.verificationStatus == 'verified' || p.verified;
    final hours = p.openingHours.isEmpty ? 'Hours not listed' : p.openingHours.values.join(' · ');
    final price = p.priceRange.toLowerCase().contains('free') ? 'Free'
        : (p.priceRange.toLowerCase() == 'unknown' || p.priceRange.toLowerCase() == 'medium')
            ? 'Price not listed' : 'Paid · ' + p.priceRange;
    final mapUrl = 'https://www.openstreetmap.org/?mlat=' + p.latitude.toString() +
        '&mlon=' + p.longitude.toString() + '#map=17/' + p.latitude.toString() + '/' + p.longitude.toString();
    return Container(margin: const EdgeInsets.only(bottom: 11), padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 43, height: 43, decoration: BoxDecoration(color: AppTokens.emerald.withValues(alpha: .10), borderRadius: BorderRadius.circular(13)),
            child: Icon(selected.icon, color: AppTokens.emerald)),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            if (verified) const Padding(padding: EdgeInsets.only(top: 5), child: _VerifiedBadge()),
          ])),
          if (!p.id.startsWith('osm:'))
            IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceDetailsScreen(placeId: p.id))),
              icon: const Icon(Icons.chevron_right_rounded)),
        ]),
        const SizedBox(height: 11),
        _FacilityInfo(icon: Icons.place_outlined, text: p.address.isEmpty ? 'Address not listed' : p.address),
        if (locationAvailable && userLat != null && userLng != null) ...[
          const SizedBox(height: 6),
          _FacilityInfo(icon: Icons.near_me_outlined, text: distanceText(OsmFacilitiesService.distanceKm(userLat!, userLng!, p.latitude, p.longitude))),
        ],
        const SizedBox(height: 6),
        _FacilityInfo(icon: Icons.schedule_rounded, text: hours),
        const SizedBox(height: 6),
        _FacilityInfo(icon: Icons.payments_outlined, text: price),
        if (p.phone?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 6), _FacilityInfo(icon: Icons.phone_outlined, text: p.phone!),
        ],
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: p.latitude == 0 && p.longitude == 0 ? null : () => launchUrl(Uri.parse(mapUrl), mode: LaunchMode.externalApplication),
          icon: const Icon(Icons.directions_rounded, size: 18), label: const Text('Directions / Map'),
          style: FilledButton.styleFrom(backgroundColor: AppTokens.emerald, padding: const EdgeInsets.symmetric(vertical: 12)),
        )),
      ]));
  }

  Widget faqPanel() {
    final items = faqItems(city!, selected.label);
    return Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTokens.emerald.withValues(alpha: .045), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTokens.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('FAQs about ' + selected.label + ' in ' + city!,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Helpful city-specific guidance', style: TextStyle(fontSize: 11.5, color: AppTokens.textSecondary)),
        const SizedBox(height: 8),
        ...items.map((f) => ExpansionTile(tilePadding: EdgeInsets.zero, childrenPadding: const EdgeInsets.only(bottom: 10),
          title: Text(f.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          children: [Align(alignment: Alignment.centerLeft, child: Text(f.$2, style: const TextStyle(fontSize: 12.5, height: 1.4, color: AppTokens.textSecondary)))])),
      ]));
  }

  String countLabel() => switch (selected.label) {
    'Parks' => 'Parks', 'Parking' => 'Parking Areas', 'ATMs' => 'ATMs',
    'Hospitals' => 'Hospitals', 'Restaurants' => 'Restaurants',
    'Pharmacies' => 'Pharmacies', 'Petrol pumps' => 'Petrol Pumps',
    'Police' => 'Police Facilities', 'Washrooms' => 'Washrooms', _ => 'Places',
  };
}

bool matchesCity(PlaceModel p, String city) {
  final aliases = <String, List<String>>{
    'Islamabad': ['islamabad', 'ict'], 'Rawalpindi': ['rawalpindi', 'pindi'],
    'Lahore': ['lahore'], 'Attock': ['attock'], 'Multan': ['multan'],
    'Sahiwal': ['sahiwal'], 'Murree': ['murree'],
    'Faisalabad': ['faisalabad', 'lyallpur'], 'Gujranwala': ['gujranwala'],
  };
  final terms = aliases[city] ?? [city.toLowerCase()];
  final cityField = (p.city ?? '').toLowerCase();
  final address = p.address.toLowerCase();
  return terms.any((term) => cityField == term || cityField.contains(term) || address.contains(term));
}

List<(String, String)> faqItems(String city, String category) {
  final route = 'For ' + city + ', use the listed address and open map directions before travelling. If the pin looks wrong, choose another result.';
  switch (category) {
    case 'Hospitals': return [
      ('How do I find emergency care in ' + city + '?', 'Use the list to locate hospitals and call ahead where possible. This directory does not confirm emergency capacity or bed availability.'),
      ('Are services and hours guaranteed?', 'No. Contact the hospital to confirm its current emergency department, services and operating status.'),
      ('How do I get there?', route),
    ];
    case 'Parks': return [
      ('Which parks can I visit in ' + city + '?', 'The entries above are the parks currently listed for ' + city + '. Check local signage and management notices before entering.'),
      ('Are parks free?', 'Entry fees may vary by park, attraction or event. Confirm the current fee at the entrance.'),
      ('What are the park timings?', 'Timings appear only when available in the directory. Confirm locally, especially on holidays.'),
    ];
    case 'Parking': return [
      ('Where can I park in ' + city + '?', 'Use the listed parking areas and map directions. Follow traffic signs and keep emergency access clear.'),
      ('Is parking free or paid?', 'The label uses available directory information. Confirm the current fee at the entrance.'),
      ('Can I reserve a space?', 'This directory does not provide live parking-space availability or reservations.'),
    ];
    case 'ATMs': return [
      ('Are these ATMs working now?', 'The directory does not provide live cash or machine status. Check the ATM before relying on it.'),
      ('Is an ATM open 24/7?', 'Access hours are not guaranteed by this listing. Confirm with the bank or ATM operator.'),
      ('How do I reach one?', route),
    ];
    case 'Restaurants': return [
      ('How can I find restaurants in ' + city + '?', 'Browse the city-filtered entries and open map directions to check the exact location.'),
      ('Are menu prices current?', 'Menu and prices can change. Confirm directly with the restaurant.'),
      ('How can I check opening status?', 'Call the restaurant or check its current notice; a directory listing alone does not confirm it is open.'),
    ];
    default: return [
      ('How do I use ' + category + ' in ' + city + '?', route),
      ('Is this live availability?', 'These are city-filtered directory results. They do not guarantee current operation or availability.'),
      ('How can I confirm details?', 'Call the facility where a number is shown or check with its official operator.'),
    ];
  }
}

class _FacilityInfo extends StatelessWidget {
  const _FacilityInfo({required this.icon, required this.text});
  final IconData icon; final String text;
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Icon(icon, size: 15, color: AppTokens.textSecondary), const SizedBox(width: 7),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.35, color: AppTokens.textSecondary))),
  ]);
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: AppTokens.emerald.withValues(alpha: .10), borderRadius: BorderRadius.circular(20)),
    child: const Text('Verified', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTokens.emerald)),
  );
}

String distanceText(double km) => km < 1 ? '${(km * 1000).round()} m away' : '${km.toStringAsFixed(1)} km away';

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
