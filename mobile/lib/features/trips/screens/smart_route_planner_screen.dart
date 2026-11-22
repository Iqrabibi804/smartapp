import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/theme/design_tokens.dart';
import '../../places/screens/road_infrastructure_alerts_screen.dart';

/// Route planner embedded inside the app shell (no Scaffold/AppBar of its own).
///
/// Honesty rules:
/// - Distances and drive times come from published highway figures for the
///   listed corridor presets and are labelled as approximate.
/// - Fuel, toll and public-transport fares are not published here because
///   they change; the UI says so instead of inventing ranges.
/// - Live road status is reported as unavailable; officials are linked instead.
class SmartRoutePlannerScreen extends ConsumerStatefulWidget {
  const SmartRoutePlannerScreen({super.key});

  @override
  ConsumerState<SmartRoutePlannerScreen> createState() =>
      _SmartRoutePlannerScreenState();
}

class _SmartRoutePlannerScreenState
    extends ConsumerState<SmartRoutePlannerScreen> {
  static const _cities = [
    'Lahore',
    'Islamabad',
    'Rawalpindi',
    'Faisalabad',
    'Multan',
    'Sahiwal',
    'Bahawalpur',
    'Murree',
    'Jhelum',
    'Sargodha',
  ];

  static const _presets = [
    (
      label: 'Lahore → Islamabad / Murree',
      origin: 'Lahore',
      destination: 'Islamabad',
      distance: '≈ 375 km',
      time: '≈ 4 h 15 m',
      highway: 'M-2 Motorway',
    ),
    (
      label: 'Lahore → Multan / Bahawalpur',
      origin: 'Lahore',
      destination: 'Multan',
      distance: '≈ 340 km',
      time: '≈ 3 h 50 m',
      highway: 'M-3 Motorway',
    ),
    (
      label: 'Rawalpindi → Rohtas Fort',
      origin: 'Rawalpindi',
      destination: 'Jhelum',
      distance: '≈ 110 km',
      time: '≈ 1 h 45 m',
      highway: 'GT Road (N-5)',
    ),
  ];

  static const _interests = [
    'Famous Food',
    'Historical Forts',
    'Parks & Lakes',
    'Traditional Bazaars',
    'Spiritual & Mosques',
  ];

  String _origin = 'Lahore';
  String _destination = 'Islamabad';
  String _mode = 'Car / Cab';
  int _days = 2;
  int _travelers = 2;
  final Set<String> _selectedInterests = {'Famous Food', 'Historical Forts'};

  ({String distance, String time, String highway})? get _matchedRoute {
    for (final preset in _presets) {
      if (preset.origin == _origin && preset.destination == _destination) {
        return (
          distance: preset.distance,
          time: preset.time,
          highway: preset.highway,
        );
      }
    }
    return null;
  }

  void _applyPreset(
      ({
        String label,
        String origin,
        String destination,
        String distance,
        String time,
        String highway
      }) preset) {
    setState(() {
      _origin = preset.origin;
      _destination = preset.destination;
    });
  }

  void _showEstimateNotice() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'This is a planning aid. Confirm road status, tolls and fares before you leave.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final isUrdu = lang == AppLanguage.urdu;
    String t(String en, String ur) => isUrdu ? ur : en;
    final route = _matchedRoute;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final config = _buildConfiguration(isUrdu, t);
            final output = _buildOutput(route, t);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
              children: [
                Text(
                  t('Plan your journey', 'اپنا سفر ترتیب دیں'),
                  style: const TextStyle(
                    fontFamily: AppTokens.fontHeading,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  t(
                    'Motorway corridor estimates for Punjab. Distances and drive times are approximate.',
                    'پنجاب کے موٹروے راستوں کا اندازہ۔ فاصلے اور وقت تخمینی ہیں۔',
                  ),
                  style: const TextStyle(
                      fontSize: 11.5, color: AppTokens.textSecondary),
                ),
                const SizedBox(height: 14),
                Text(
                  t('Popular route presets', 'مقبول روٹ پریسیٹس'),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.textSecondary),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final preset in _presets)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: _PresetCard(
                            preset: preset,
                            selected: preset.origin == _origin &&
                                preset.destination == _destination,
                            onTap: () => _applyPreset(preset),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: config),
                      const SizedBox(width: 14),
                      Expanded(flex: 6, child: output),
                    ],
                  )
                else ...[
                  config,
                  const SizedBox(height: 14),
                  output,
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildConfiguration(bool isUrdu, String Function(String, String) t) {
    return Column(
      children: [
        _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _CityField(
                      label: t('Starting city', 'شروع کا شہر'),
                      value: _origin,
                      cities: _cities,
                      onChanged: (value) => setState(() => _origin = value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: IconButton(
                      onPressed: () => setState(() {
                        final temp = _origin;
                        _origin = _destination;
                        _destination = temp;
                      }),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTokens.emeraldTint,
                        foregroundColor: AppTokens.emerald,
                        shape: const CircleBorder(),
                      ),
                      icon: const Icon(Icons.swap_horiz_rounded, size: 19),
                      tooltip: 'Swap cities',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _CityField(
                      label: t('Destination', 'منزل'),
                      value: _destination,
                      cities: _cities,
                      onChanged: (value) =>
                          setState(() => _destination = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Label(t('Mode of transport', 'سفر کا ذریعہ')),
              const SizedBox(height: 8),
              Row(
                children: [
                  _ModeCard(
                    label: t('Car / Cab', 'کار / کیب'),
                    icon: Icons.directions_car_rounded,
                    selected: _mode == 'Car / Cab',
                    onTap: () => setState(() => _mode = 'Car / Cab'),
                  ),
                  const SizedBox(width: 8),
                  _ModeCard(
                    label: t('Luxury Bus', 'لگژری بس'),
                    icon: Icons.directions_bus_rounded,
                    selected: _mode == 'Luxury Bus',
                    onTap: () => setState(() => _mode = 'Luxury Bus'),
                  ),
                  const SizedBox(width: 8),
                  _ModeCard(
                    label: t('Express Train', 'ایکسپریس ٹرین'),
                    icon: Icons.train_rounded,
                    selected: _mode == 'Express Train',
                    onTap: () => setState(() => _mode = 'Express Train'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StepperField(
                      label: t('Days', 'دن'),
                      value: _days,
                      min: 1,
                      max: 14,
                      onChanged: (v) => setState(() => _days = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StepperField(
                      label: t('Travelers', 'مسافر'),
                      value: _travelers,
                      min: 1,
                      max: 12,
                      onChanged: (v) => setState(() => _travelers = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _Label(t('Interests', 'دلچسپیاں')),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  for (final interest in _interests)
                    FilterChip(
                      label: Text(interest,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: _selectedInterests.contains(interest)
                                ? AppTokens.emerald
                                : AppTokens.textSecondary,
                          )),
                      selected: _selectedInterests.contains(interest),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      }),
                      backgroundColor: Colors.white,
                      selectedColor: AppTokens.emeraldTint,
                      side: BorderSide(
                          color: _selectedInterests.contains(interest)
                              ? AppTokens.emeraldBorder
                              : AppTokens.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999)),
                      showCheckmark: false,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: FilledButton(
                  onPressed: _showEstimateNotice,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTokens.emerald,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    t('Generate Smart Route & Itinerary',
                        'سمارٹ روٹ اور ایٹینریری بنائیں'),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOutput(
    ({String distance, String time, String highway})? route,
    String Function(String, String) t,
  ) {
    final returnTrip = _mode != 'Car / Cab'
        ? 'Intercity terminal / station transfers are not included.'
        : 'Fuel and tolls depend on your vehicle and current rates.';

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTokens.border),
            boxShadow: AppShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                color: AppTokens.emerald,
                child: Row(
                  children: [
                    const Icon(Icons.route_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_origin → $_destination',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          Text(
                            route?.highway ??
                                'No verified corridor for this pair',
                            style: TextStyle(
                                fontSize: 10.5,
                                color: Colors.white.withValues(alpha: 0.85)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _mode,
                        style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _StatPill(
                            icon: Icons.straighten_rounded,
                            label: route?.distance ?? 'Unavailable'),
                        const SizedBox(width: 8),
                        _StatPill(
                            icon: Icons.schedule_rounded,
                            label: route?.time ?? 'Unavailable'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTokens.emeraldTint,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTokens.emeraldBorder),
                      ),
                      child: Text(
                        route == null
                            ? 'Distance and drive time are not published for this pair in the app. Use a maps service with live traffic.'
                            : 'Fuel & toll: information unavailable — official rates change. $returnTrip',
                        style: const TextStyle(
                            fontSize: 10.5,
                            height: 1.4,
                            color: AppTokens.emeraldDeep),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (route != null)
          _Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timeline_rounded,
                        size: 17, color: AppTokens.emerald),
                    const SizedBox(width: 6),
                    Text(
                      t('Suggested rest stops', 'تجویز کردہ آرام کے مقامات'),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Facilities can change. Verify on arrival.',
                  style: TextStyle(fontSize: 10, color: AppTokens.textMuted),
                ),
                const SizedBox(height: 10),
                ...route.highway.contains('M-2')
                    ? _m2Stops()
                    : [
                        const Text(
                          'No verified rest-stop list for this corridor yet.',
                          style: TextStyle(
                              fontSize: 11, color: AppTokens.textSecondary),
                        )
                      ],
              ],
            ),
          )
        else
          _Panel(
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: AppTokens.textMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Choose a preset above, or use a live maps app for this pair. This planner only lists corridors with published figures.',
                    style: const TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: AppTokens.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTokens.textMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t('Live road & landslide status',
                          'لائیو سڑک اور لینڈ سلائیڈ کی حالت'),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.textPrimary),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTokens.inputFill,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'No live feed',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'This app does not receive live road or landslide alerts. Check NHA (nha.gov.pk) and NHMP (nhmp.gov.pk) before travelling, especially Murree and the Salt Range in winter.',
                style: TextStyle(
                    fontSize: 11, height: 1.45, color: AppTokens.textSecondary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Reference date: 2026-11-22 · Static advisories only',
                style: TextStyle(fontSize: 9.5, color: AppTokens.textMuted),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 34,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const RoadInfrastructureAlertsScreen()),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(34),
                    side: const BorderSide(color: AppTokens.border),
                    foregroundColor: AppTokens.textPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  icon: const Icon(Icons.report_outlined, size: 14),
                  label: const Text('View static advisories'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_bus_rounded,
                      size: 17, color: AppTokens.gold),
                  const SizedBox(width: 6),
                  Text(
                    t('Local public transport', 'مقامی پبلک ٹرانسپورٹ'),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _FareRow(
                route: '$_origin → $_destination',
                mode: 'Bus / coaster / train',
                note: 'Fares vary by operator and season',
              ),
              const SizedBox(height: 6),
              _FareRow(
                route: 'Local transfer at destination',
                mode: 'Rickshaw / Qingqi',
                note: 'Agree the fare before boarding',
              ),
              const SizedBox(height: 8),
              const Text(
                'Fares are not listed because operators change them without notice. Confirm at the adda or station counter.',
                style: TextStyle(
                    fontSize: 10, height: 1.4, color: AppTokens.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Panel(
          child: Row(
            children: [
              const Icon(Icons.tune_rounded,
                  size: 17, color: AppTokens.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$_days day(s) · $_travelers traveler(s) · ${_selectedInterests.isEmpty ? 'no interests selected' : _selectedInterests.join(', ')}',
                  style: const TextStyle(
                      fontSize: 10.5,
                      height: 1.4,
                      color: AppTokens.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _m2Stops() {
    const stops = [
      (
        km: 'KM 85',
        title: 'Sukheke service area',
        body: 'Petrol, fast food and washrooms. Facilities vary by operator.',
        amenities: ['Fuel', 'Food', 'Washrooms', 'Mosque'],
      ),
      (
        km: 'KM 220',
        title: 'Bhera service area',
        body: 'Sweets and family dining are commonly available here.',
        amenities: ['Food', 'Washrooms', 'Mosque'],
      ),
      (
        km: 'KM 290',
        title: 'Kallar Kahar viewpoint',
        body:
            'Salt Range valley and lake viewpoint. Check winter weather before stopping.',
        amenities: ['Viewpoint', 'Food'],
      ),
    ];

    return [
      for (var i = 0; i < stops.length; i++)
        Padding(
          padding: EdgeInsets.only(bottom: i == stops.length - 1 ? 0 : 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: AppTokens.emerald,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (i != stops.length - 1)
                    Container(
                      width: 1.4,
                      height: 54,
                      color: AppTokens.emeraldBorder,
                    ),
                ],
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          stops[i].km,
                          style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: AppTokens.emerald),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            stops[i].title,
                            style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppTokens.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      stops[i].body,
                      style: const TextStyle(
                          fontSize: 10,
                          height: 1.35,
                          color: AppTokens.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (final amenity in stops[i].amenities)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTokens.dashboardBg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTokens.border),
                            ),
                            child: Text(
                              amenity,
                              style: const TextStyle(
                                  fontSize: 8.5,
                                  color: AppTokens.textSecondary),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    ];
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTokens.border),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final ({
    String label,
    String origin,
    String destination,
    String distance,
    String time,
    String highway
  }) preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 190,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: selected ? AppTokens.emerald : AppTokens.border,
                width: selected ? 1.4 : 1),
            color: selected ? AppTokens.emeraldTint : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                preset.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary),
              ),
              const SizedBox(height: 3),
              Text(
                '${preset.distance} · ${preset.time} · ${preset.highway}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 9.5, height: 1.3, color: AppTokens.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityField extends StatelessWidget {
  const _CityField({
    required this.label,
    required this.value,
    required this.cities,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> cities;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTokens.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTokens.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTokens.emerald),
            ),
          ),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTokens.textPrimary),
          items: [
            for (final city in cities)
              DropdownMenuItem(value: city, child: Text(city)),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppTokens.textSecondary),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppTokens.emeraldTint : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selected ? AppTokens.emerald : AppTokens.border,
                width: selected ? 1.3 : 1),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 18,
                  color:
                      selected ? AppTokens.emerald : AppTokens.textSecondary),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5,
                  height: 1.2,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppTokens.emerald : AppTokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperField extends StatelessWidget {
  const _StepperField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        const SizedBox(height: 5),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTokens.border),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: value > min ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove_rounded, size: 16),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                color: AppTokens.emerald,
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTokens.textPrimary),
                ),
              ),
              IconButton(
                onPressed: value < max ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add_rounded, size: 16),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                color: AppTokens.emerald,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppTokens.dashboardBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTokens.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTokens.emerald),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppTokens.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({
    required this.route,
    required this.mode,
    required this.note,
  });

  final String route;
  final String mode;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppTokens.dashboardBg,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppTokens.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.textPrimary),
                ),
                Text(
                  '$mode · $note',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 9, color: AppTokens.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppTokens.goldBorder),
            ),
            child: const Text(
              'Check locally',
              style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: AppTokens.goldHover),
            ),
          ),
        ],
      ),
    );
  }
}
