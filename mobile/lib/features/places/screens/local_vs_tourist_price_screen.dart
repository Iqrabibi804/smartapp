import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';

class _LocalReport {
  _LocalReport({
    required this.district,
    required this.vendor,
    required this.category,
    required this.charged,
    required this.details,
    required this.savedAt,
  });

  final String district;
  final String vendor;
  final String category;
  final String charged;
  final String details;
  final DateTime savedAt;
}

class _FairCheck {
  const _FairCheck(this.title, this.icon, this.points);
  final String title;
  final IconData icon;
  final List<String> points;
}

const List<_FairCheck> _checks = [
  _FairCheck('Transport & jeeps', Icons.local_taxi_rounded, [
    'Use the local jeep or taxi union stand and ask for a printed or written ticket.',
    'Agree the full return fare, waiting time and whether fuel is included before boarding.',
    'Avoid vehicles offered by hotel or shop touts; their commission is added to your fare.',
  ]),
  _FairCheck('Food & drinks', Icons.restaurant_rounded, [
    'Ask to see the menu or rate list before ordering; confirm whether tax is included.',
    'For packaged drinks and water, check the printed retail price on the pack.',
    'For fish or meat sold by weight, watch the weighing yourself.',
  ]),
  _FairCheck('Hotels & guest houses', Icons.hotel_rounded, [
    'Ask for the written tariff and compare two or three places before paying.',
    'Confirm what the price includes: tax, breakfast, heating in winter, parking.',
    'Get the room number and total on the receipt before handing over cash.',
  ]),
  _FairCheck('Tickets & activities', Icons.confirmation_number_rounded, [
    'Buy entry tickets at the official counter, not from individuals outside.',
    'Keep every ticket until you leave the site.',
    'Ask whether a guide is optional and what the published guide charge is.',
  ]),
  _FairCheck('Shopping', Icons.storefront_rounded, [
    'Ask the price of several similar items before bargaining.',
    'Confirm the final price per piece, not per set, before it is packed.',
    'A written bill helps if you later need to report a problem.',
  ]),
];

class LocalVsTouristPriceScreen extends StatefulWidget {
  const LocalVsTouristPriceScreen({super.key});

  @override
  State<LocalVsTouristPriceScreen> createState() =>
      _LocalVsTouristPriceScreenState();
}

class _LocalVsTouristPriceScreenState extends State<LocalVsTouristPriceScreen> {
  static const List<String> _districts = [
    'Lahore',
    'Rawalpindi',
    'Murree',
    'Faisalabad',
    'Multan',
    'Gujranwala',
    'Sialkot',
    'Bahawalpur',
    'Rahim Yar Khan',
    'Mansehra / Naran',
  ];

  String _district = _districts.first;
  final List<_LocalReport> _localReports = [];

  Future<void> _showReportDialog() async {
    final vendorController = TextEditingController();
    final chargedController = TextEditingController();
    final detailsController = TextEditingController();
    String category = 'Transport';
    String reportDistrict = _district;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Report overcharging'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Reports are saved on this device only. SmartMap Punjab is not '
                'connected to any district administration and does not submit '
                'reports on your behalf.',
                style: TextStyle(fontSize: 12, color: AppTokens.textSecondary),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: reportDistrict,
                decoration: const InputDecoration(
                  labelText: 'District',
                  border: OutlineInputBorder(),
                ),
                items: _districts
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => reportDistrict = v ?? reportDistrict,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  'Transport',
                  'Food',
                  'Hotel',
                  'Ticket / activity',
                  'Shopping',
                  'Other',
                ]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => category = v ?? category,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: vendorController,
                decoration: const InputDecoration(
                  labelText: 'Vendor or place',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: chargedController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount charged (PKR, optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'What happened?',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTokens.pakistanGreen,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (vendorController.text.trim().isEmpty) return;
              setState(() {
                _localReports.insert(
                  0,
                  _LocalReport(
                    district: reportDistrict,
                    vendor: vendorController.text.trim(),
                    category: category,
                    charged: chargedController.text.trim(),
                    details: detailsController.text.trim(),
                    savedAt: DateTime.now(),
                  ),
                );
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Saved on this device. It was not submitted '
                      'to any authority.'),
                ),
              );
            },
            child: const Text('Save on device'),
          ),
        ],
      ),
    );

    vendorController.dispose();
    chargedController.dispose();
    detailsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTokens.surfaceDark : Colors.white;
    final borderColor = isDark ? AppTokens.borderDark : AppTokens.border;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price fairness guide',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'Official rate lists not connected',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReportDialog,
        backgroundColor: AppTokens.pakistanGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.report_rounded),
        label: const Text('Report overcharging'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTokens.warning.withValues(alpha: isDark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppTokens.warning.withValues(alpha: 0.35)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.gavel_rounded, color: AppTokens.warning),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Official rate information currently unavailable',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'SmartMap Punjab has not connected to district government '
                  'rate notifications, so no official jeep, hotel, ticket or '
                  'transport rates are shown here. Ask the district tourism '
                  'office or the local union stand for the published rate.',
                  style: TextStyle(fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.location_city_rounded, size: 18),
              const SizedBox(width: 6),
              const Text(
                'District',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _district,
                underline: const SizedBox.shrink(),
                items: _districts
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _district = v ?? _district),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                Text(
                  '$_district district',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Official rate information currently unavailable.',
                  style: TextStyle(fontSize: 13, color: AppTokens.textSecondary),
                ),
                const SizedBox(height: 10),
                const Text(
                  'DC-notified rate lists (jeep rentals, entry tickets, '
                  'chairlifts and similar services) will appear here only '
                  'when an authorised district source is connected.',
                  style: TextStyle(fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'How to check a fair price',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'General guidance for common tourist purchases. It is not an '
            'official price list.',
            style: TextStyle(fontSize: 12, color: AppTokens.textSecondary),
          ),
          const SizedBox(height: 12),
          for (final check in _checks) ...[
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
                      Icon(check.icon, size: 18, color: AppTokens.pakistanGreen),
                      const SizedBox(width: 8),
                      Text(
                        check.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (final point in check.points)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(fontSize: 12.5, height: 1.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (_localReports.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Your saved reports (this device only)',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            for (final report in _localReports)
              Card(
                color: cardColor,
                child: ListTile(
                  leading: const Icon(Icons.note_alt_outlined),
                  title: Text('${report.vendor} · ${report.category}'),
                  subtitle: Text(
                    '${report.district}'
                    '${report.charged.isEmpty ? '' : ' · charged PKR ${report.charged}'}'
                    '\n${report.details.isEmpty ? 'No details added.' : report.details}'
                    '\nSaved ${_formatDate(report.savedAt)}',
                  ),
                  isThreeLine: true,
                ),
              ),
          ],
        ],
      ),
    );
  }

  static String _formatDate(DateTime value) {
    final d = value.day.toString().padLeft(2, '0');
    final m = value.month.toString().padLeft(2, '0');
    return '$d/$m/${value.year}';
  }
}
