import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';

const List<String> kPermitDestinations = [
  'Gilgit-Baltistan restricted areas (Khunjerab, Fairy Meadows, Deosai)',
  'Khyber Pakhtunkhwa border and Malakand areas',
  'Chitral and Lowari routes',
  'Astore and Nanga Parbat access',
  'Punjab tourist sites (no general NOC requirement)',
];

const List<String> kPermitSteps = [
  'Choose your destination and check whether it is inside a restricted area.',
  'Confirm the current requirement with the Deputy Commissioner office or the '
      'Gilgit-Baltistan Home Department. Rules change and this app has no live '
      'permit feed.',
  'Collect the documents the office asks for (normally passport or CNIC, '
      'photographs, travel plan and hotel details).',
  'Apply through the official channel the office specifies. This app does not '
      'submit applications.',
  'Carry the printed approval and your original identity document, and keep a '
      'photo of the approval offline.',
];

class PermitsScreen extends StatefulWidget {
  const PermitsScreen({super.key});

  @override
  State<PermitsScreen> createState() => _PermitsScreenState();
}

class _PermitsScreenState extends State<PermitsScreen> {
  String _destination = kPermitDestinations.first;
  bool _foreignNational = true;

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
              'Permits & NOC guidance',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'Preparation guidance — no online submission',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTokens.warning.withValues(alpha: isDark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppTokens.warning.withValues(alpha: 0.35)),
            ),
            child: const Text(
              'This app is not connected to any permit office. It cannot submit, '
              'approve or track an NOC, and it does not display official permits. '
              'Requirements and processing times are reported as unavailable '
              'until confirmed by the authority.',
              style: TextStyle(fontSize: 12.5, height: 1.45),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _destination,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Destination',
              border: OutlineInputBorder(),
            ),
            items: kPermitDestinations
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => _destination = v ?? _destination),
          ),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Foreign national')),
              ButtonSegment(value: false, label: Text('Pakistani citizen')),
            ],
            selected: {_foreignNational},
            onSelectionChanged: (v) =>
                setState(() => _foreignNational = v.first),
          ),
          const SizedBox(height: 16),
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
                const Text(
                  'What applies to you',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  _foreignNational
                      ? 'As a foreign national, restricted-area travel may need '
                          'an NOC. Confirm the current rule for "$_destination" '
                          'with the Deputy Commissioner office before booking.'
                      : 'As a Pakistani citizen, identity checks may still apply '
                          'and some border zones are restricted. Confirm the current '
                          'rule for "$_destination" with the local administration.',
                  style: const TextStyle(fontSize: 12.5, height: 1.45),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Fee and processing time: information unavailable.',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.warning,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Preparation steps',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < kPermitSteps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 11,
                    backgroundColor:
                        AppTokens.pakistanGreen.withValues(alpha: 0.12),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTokens.pakistanGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      kPermitSteps[i],
                      style: const TextStyle(fontSize: 12.5, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: borderColor),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Application status',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Text(
                  'Status tracking (Draft, Submitted, Under review, Approved, '
                  'Rejected, Expired) is not available because no authorised '
                  'integration exists. Keep your own copy of every receipt.',
                  style: TextStyle(fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
