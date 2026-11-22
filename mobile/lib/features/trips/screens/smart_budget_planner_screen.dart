import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/theme/design_tokens.dart';

/// Budget planner embedded inside the app shell.
///
/// All figures are transparent planning assumptions, never presented as
/// official prices. The assumption card shows exactly what each rate covers.
class SmartBudgetPlannerScreen extends ConsumerStatefulWidget {
  const SmartBudgetPlannerScreen({super.key});

  @override
  ConsumerState<SmartBudgetPlannerScreen> createState() =>
      _SmartBudgetPlannerScreenState();
}

class _SmartBudgetPlannerScreenState
    extends ConsumerState<SmartBudgetPlannerScreen> {
  static const _destinations = [
    'Murree',
    'Lahore',
    'Nathia Gali',
    'Bahawalpur',
    'Swat / Kalam',
  ];

  static const _styles = ['Budget / Student', 'Family Friendly', 'Luxury'];

  String _destination = 'Murree';
  double _budget = 40000;
  int _days = 3;
  int _travelers = 3;
  String _style = 'Budget / Student';

  static const _assumptions = {
    'Budget / Student': (
      stay: 6000,
      food: 1200,
      transport: 800,
      activities: 600,
    ),
    'Family Friendly': (
      stay: 14000,
      food: 2200,
      transport: 1600,
      activities: 1200,
    ),
    'Luxury': (
      stay: 32000,
      food: 4500,
      transport: 3500,
      activities: 2500,
    ),
  };

  static const _dayPlans = {
    'Murree': [
      'Arrival, Mall Road walk and Kashmir Point sunset',
      'Patriata chairlift and Bhurban viewpoints',
      'Nathia Gali day trip and Pipeline Track',
    ],
    'Lahore': [
      'Walled City: Badshahi Mosque, Lahore Fort and Food Street',
      'Shalimar Gardens, museum and Anarkali bazaar',
      'Wagah border ceremony (check timings) and Liberty Market',
    ],
    'Nathia Gali': [
      'Arrival, Nathiagali bazaar and church walk',
      'Mukshpuri hike (weather permitting) and Pipeline Track',
      'Day trip to Donga Gali and Ayubia',
    ],
    'Bahawalpur': [
      'Noor Mahal and central library',
      'Derawar Fort day trip through Cholistan',
      'Local bazaars and Bahawalpur museum',
    ],
    'Swat / Kalam': [
      'Arrival in Mingora and Swat bazaar',
      'Kalam valley and riverside walks',
      'Mahodand Lake (seasonal road) or Malam Jabba',
    ],
  };

  static const _tips = {
    'Murree': [
      'Hotels a short walk off Mall Road are often cheaper than road-front rooms.',
      'Buy Patriata chairlift tickets at the operator counter rather than through agents.',
    ],
    'Lahore': [
      'Many Walled City sights are walkable; plan a single loop to cut rickshaw fares.',
      'Weekday museum entry is usually quieter than weekends.',
    ],
    'Nathia Gali': [
      'Guesthouses fill quickly in snow season; book ahead and confirm heating.',
      'Shared jeeps can be cheaper than private cars for short valley hops.',
    ],
    'Bahawalpur': [
      'Derawar Fort needs a full day; arrange transport in advance.',
      'Carry cash; card acceptance is limited outside the city centre.',
    ],
    'Swat / Kalam': [
      'Check the Lowari/valley road status locally before leaving Mingora.',
      'Off-season rates are lower, but some hotels close in winter.',
    ],
  };

  ({int stay, int food, int transport, int activities}) get _rates =>
      _assumptions[_style]!;

  int get _rooms => (_travelers / 3).ceil();
  int get _nights => (_days - 1).clamp(1, 30);

  int get _stayTotal => _rates.stay * _nights * _rooms;
  int get _foodTotal => _rates.food * _travelers * _days;
  int get _transportTotal => _rates.transport * _travelers * _days;
  int get _activitiesTotal => _rates.activities * _travelers * _days;
  int get _total =>
      _stayTotal + _foodTotal + _transportTotal + _activitiesTotal;
  int get _buffer => _budget.round() - _total;
  int get _perPerson => (_total / _travelers).round();

  String _money(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '${value < 0 ? '-' : ''}Rs. $buffer';
  }

  Future<void> _share() async {
    final lines = <String>[
      'SmartMap Punjab — planning estimate',
      '$_destination · $_days day(s) · $_travelers traveler(s) · $_style',
      'Total estimate: ${_money(_total)} (${_money(_perPerson)} / person)',
      'Budget entered: ${_money(_budget.round())}',
      if (_buffer >= 0)
        'Remaining buffer: ${_money(_buffer)}'
      else
        'Over budget by: ${_money(-_buffer)}',
      '',
      'Figures are assumptions, not official prices.',
    ];
    final uri = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent(lines.join('\n'))}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      // No messenger installed; the plan stays on screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final isUrdu = lang == AppLanguage.urdu;
    String t(String en, String ur) => isUrdu ? ur : en;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
          children: [
            Text(
              t('Plan a trip budget', 'سفر کا بجٹ بنائیں'),
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
                'Adjust assumptions to see a planning estimate in PKR. Nothing here is an official price.',
                'اندازے تبدیل کریں اور PKR میں تخمینہ دیکھیں۔ یہ سرکاری قیمتیں نہیں ہیں۔',
              ),
              style: const TextStyle(
                  fontSize: 11.5, color: AppTokens.textSecondary),
            ),
            const SizedBox(height: 14),
            _buildControls(t),
            const SizedBox(height: 14),
            _buildBreakdown(t),
            const SizedBox(height: 14),
            _buildItinerary(t),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTokens.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.science_outlined,
                      size: 15, color: AppTokens.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Planning assumptions only. Hotel, food, fuel and ticket prices vary by season and operator — confirm before booking.',
                      style: TextStyle(
                          fontSize: 9.5,
                          height: 1.4,
                          color: AppTokens.textMuted),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _share,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTokens.emerald,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.chat_rounded, size: 17),
                label: Text(
                  t('Share budget plan on WhatsApp',
                      'واٹس ایپ پر بجٹ پلان شیئر کریں'),
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(String Function(String, String) t) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTokens.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('Destination', 'منزل'),
                      style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.textSecondary),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: _destination,
                      isExpanded: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 11),
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
                          borderSide:
                              const BorderSide(color: AppTokens.emerald),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTokens.textPrimary),
                      items: [
                        for (final destination in _destinations)
                          DropdownMenuItem(
                              value: destination, child: Text(destination)),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _destination = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t('Total budget', 'کل بجٹ'),
                    style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.textSecondary),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTokens.emeraldTint,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTokens.emeraldBorder),
                    ),
                    child: Text(
                      _money(_budget.round()),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppTokens.emeraldDeep),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTokens.emerald,
              inactiveTrackColor: AppTokens.emeraldTint,
              thumbColor: AppTokens.emerald,
              overlayColor: AppTokens.emerald.withValues(alpha: 0.12),
              trackHeight: 4,
            ),
            child: Slider(
              value: _budget,
              min: 5000,
              max: 200000,
              divisions: 39,
              onChanged: (value) => setState(() => _budget = value),
            ),
          ),
          Row(
            children: [
              const Text('Rs. 5,000',
                  style: TextStyle(fontSize: 9, color: AppTokens.textMuted)),
              const Spacer(),
              const Text('Rs. 200,000',
                  style: TextStyle(fontSize: 9, color: AppTokens.textMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStepper(
                  label: t('Days', 'دن'),
                  value: _days,
                  min: 1,
                  max: 14,
                  onChanged: (v) => setState(() => _days = v),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStepper(
                  label: t('Travelers', 'مسافر'),
                  value: _travelers,
                  min: 1,
                  max: 12,
                  onChanged: (v) => setState(() => _travelers = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t('Travel style', 'سفر کا انداز'),
            style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppTokens.textSecondary),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppTokens.dashboardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTokens.border),
            ),
            child: Row(
              children: [
                for (final style in _styles)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _style = style),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: _style == style
                              ? AppTokens.emerald
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          style,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: _style == style
                                ? Colors.white
                                : AppTokens.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdown(String Function(String, String) t) {
    final within = _buffer >= 0;

    return Container(
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
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t('Estimated breakdown', 'تخمینی تفصیل'),
                            style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppTokens.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: within
                                      ? AppTokens.emeraldTint
                                      : AppTokens.pastelRose,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                      color: within
                                          ? AppTokens.emeraldBorder
                                          : const Color(0xFFFECACA)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      within
                                          ? Icons.check_circle_outline
                                          : Icons.error_outline,
                                      size: 10,
                                      color: within
                                          ? AppTokens.emerald
                                          : AppTokens.alertRed,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      within ? 'Within budget' : 'Over budget',
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: within
                                              ? AppTokens.emerald
                                              : AppTokens.alertRed),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$_days day(s) · $_travelers people',
                                style: const TextStyle(
                                    fontSize: 9.5, color: AppTokens.textMuted),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _money(_perPerson),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppTokens.textPrimary),
                        ),
                        const Text(
                          'per person (est.)',
                          style: TextStyle(
                              fontSize: 9, color: AppTokens.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _CostRow(
                  icon: Icons.hotel_rounded,
                  label:
                      'Hotel stay ($_nights night${_nights == 1 ? '' : 's'}, $_rooms room${_rooms == 1 ? '' : 's'})',
                  value: _money(_stayTotal),
                ),
                _CostRow(
                  icon: Icons.restaurant_rounded,
                  label: 'Food & dining ($_days days, $_travelers people)',
                  value: _money(_foodTotal),
                ),
                _CostRow(
                  icon: Icons.directions_car_rounded,
                  label: 'Local transport & fuel share',
                  value: _money(_transportTotal),
                ),
                _CostRow(
                  icon: Icons.confirmation_number_rounded,
                  label: 'Sightseeing & entry tickets',
                  value: _money(_activitiesTotal),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: within ? AppTokens.emeraldTint : AppTokens.pastelRose,
              border: Border(
                top: BorderSide(
                    color: within
                        ? AppTokens.emeraldBorder
                        : const Color(0xFFFECACA)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  within ? 'Remaining buffer' : 'Shortfall',
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color:
                          within ? AppTokens.emeraldDeep : AppTokens.alertRed),
                ),
                const Spacer(),
                Text(
                  _money(within ? _buffer : -_buffer),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color:
                          within ? AppTokens.emeraldDeep : AppTokens.alertRed),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Text(
              'Assumptions for $_style: stay ${_money(_rates.stay)}/room/night · food ${_money(_rates.food)}/person/day · local transport ${_money(_rates.transport)}/person/day · tickets ${_money(_rates.activities)}/person/day.',
              style: const TextStyle(
                  fontSize: 9.5, height: 1.45, color: AppTokens.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItinerary(String Function(String, String) t) {
    final base = _dayPlans[_destination] ?? const <String>[];
    final tips = _tips[_destination] ?? const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('Day-by-day itinerary', 'روز بروز ایٹینریری'),
          style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppTokens.textPrimary),
        ),
        const SizedBox(height: 2),
        const Text(
          'Generic highlights — opening hours and roads change; verify locally.',
          style: TextStyle(fontSize: 10, color: AppTokens.textMuted),
        ),
        const SizedBox(height: 8),
        for (var day = 1; day <= _days; day++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTokens.border),
                boxShadow: AppShadows.card,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTokens.emerald,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Day $day',
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      day <= base.length
                          ? base[day - 1]
                          : 'Flexible day — repeat a favourite spot or rest. Plan within your buffer.',
                      style: const TextStyle(
                          fontSize: 11.5,
                          height: 1.4,
                          color: AppTokens.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (tips.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTokens.goldTint,
              borderRadius: BorderRadius.circular(12),
              border: const Border(
                left: BorderSide(color: AppTokens.gold, width: 4),
                top: BorderSide(color: AppTokens.goldBorder),
                right: BorderSide(color: AppTokens.goldBorder),
                bottom: BorderSide(color: AppTokens.goldBorder),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded,
                        size: 16, color: AppTokens.gold),
                    const SizedBox(width: 6),
                    Text(
                      t('Money-saving tips', 'رقم بچانے کے مشورے'),
                      style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.goldHover),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                for (final tip in tips)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(
                                fontSize: 11, color: AppTokens.goldHover)),
                        Expanded(
                          child: Text(
                            tip,
                            style: const TextStyle(
                                fontSize: 10.5,
                                height: 1.4,
                                color: AppTokens.goldHover),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MiniStepper extends StatelessWidget {
  const _MiniStepper({
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
        Text(
          label,
          style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppTokens.textSecondary),
        ),
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

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTokens.dashboardBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: AppTokens.textSecondary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 10.5, height: 1.3, color: AppTokens.textSecondary),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTokens.textPrimary),
          ),
        ],
      ),
    );
  }
}
