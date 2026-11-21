import 'package:flutter/material.dart';

import '../../../core/offline/offline_cache.dart';
import '../../../core/theme/design_tokens.dart';

class ReadinessItem {
  const ReadinessItem(this.id, this.label);
  final String id;
  final String label;
}

class ReadinessSection {
  const ReadinessSection(this.title, this.icon, this.items);
  final String title;
  final IconData icon;
  final List<ReadinessItem> items;
}

const List<ReadinessSection> kReadinessSections = [
  ReadinessSection('Documents', Icons.badge_outlined, [
    ReadinessItem('doc_cnic', 'CNIC or passport with you'),
    ReadinessItem('doc_licence', 'Driving licence and vehicle papers if driving'),
    ReadinessItem('doc_booking', 'Hotel or trip booking confirmations'),
  ]),
  ReadinessSection('Vehicle', Icons.directions_car_outlined, [
    ReadinessItem('veh_fuel', 'Enough fuel for the next stretch'),
    ReadinessItem('veh_tyre', 'Spare tyre, jack and tools checked'),
    ReadinessItem('veh_lights', 'Lights, brakes and wipers working'),
  ]),
  ReadinessSection('Health', Icons.health_and_safety_outlined, [
    ReadinessItem('hea_meds', 'Personal medicines packed'),
    ReadinessItem('hea_aid', 'Basic first-aid kit in the vehicle'),
    ReadinessItem('hea_water', 'Drinking water and snacks for delays'),
  ]),
  ReadinessSection('Connectivity', Icons.wifi_off_rounded, [
    ReadinessItem('con_offline', 'Offline maps or city pack saved'),
    ReadinessItem('con_power', 'Power bank charged'),
    ReadinessItem('con_numbers', 'Emergency numbers saved on paper or offline'),
  ]),
  ReadinessSection('Route and weather', Icons.alt_route_rounded, [
    ReadinessItem('rou_status', 'Road status confirmed with NHA / NHMP'),
    ReadinessItem('rou_weather', 'Weather forecast checked with PMD'),
    ReadinessItem('rou_plan', 'Itinerary shared with a trusted contact'),
  ]),
  ReadinessSection('Money', Icons.payments_outlined, [
    ReadinessItem('mon_cash', 'Cash for tolls, fuel and small stops'),
    ReadinessItem('mon_backup', 'Backup payment method (card or wallet)'),
  ]),
];

const String _cacheKey = 'journey_readiness';

class JourneyReadinessScreen extends StatefulWidget {
  const JourneyReadinessScreen({super.key});

  @override
  State<JourneyReadinessScreen> createState() => _JourneyReadinessScreenState();
}

class _JourneyReadinessScreenState extends State<JourneyReadinessScreen> {
  final Set<String> _checked = {};
  bool _loaded = false;

  int get _totalItems =>
      kReadinessSections.fold(0, (sum, section) => sum + section.items.length);

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final saved = OfflineCache.instance.read(_cacheKey);
    if (saved is List) {
      _checked
        ..clear()
        ..addAll(saved.map((e) => e.toString()));
    }
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _toggle(String id, bool value) async {
    setState(() {
      if (value) {
        _checked.add(id);
      } else {
        _checked.remove(id);
      }
    });
    await OfflineCache.instance.put(
      _cacheKey,
      _checked.toList(),
      ttl: const Duration(days: 365),
    );
  }

  Future<void> _reset() async {
    setState(_checked.clear);
    await OfflineCache.instance.put(
      _cacheKey,
      <String>[],
      ttl: const Duration(days: 365),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTokens.surfaceDark : Colors.white;
    final borderColor = isDark ? AppTokens.borderDark : AppTokens.border;
    final total = _totalItems;
    final done = _checked.length.clamp(0, total);
    final ratio = total == 0 ? 0.0 : done / total;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Journey readiness',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'Your own preparation checklist',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reset checklist',
            onPressed: _loaded ? _reset : null,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$done of $total prepared',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${(ratio * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTokens.pakistanGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 8,
                          backgroundColor:
                              AppTokens.pakistanGreen.withValues(alpha: 0.12),
                          color: AppTokens.pakistanGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'This score reflects only the boxes you tick. SmartMap '
                        'does not verify weather, road, vehicle or document '
                        'conditions.',
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: AppTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                for (final section in kReadinessSections) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: Row(
                            children: [
                              Icon(section.icon,
                                  size: 18, color: AppTokens.pakistanGreen),
                              const SizedBox(width: 8),
                              Text(
                                section.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        for (final item in section.items)
                          CheckboxListTile(
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _checked.contains(item.id),
                            onChanged: (v) => _toggle(item.id, v ?? false),
                            title: Text(
                              item.label,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}
