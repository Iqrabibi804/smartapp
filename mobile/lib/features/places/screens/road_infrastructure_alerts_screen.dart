import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/data/road_advisories.dart';
import '../../../core/theme/design_tokens.dart';

class RoadInfrastructureAlertsScreen extends StatefulWidget {
  const RoadInfrastructureAlertsScreen({super.key});

  @override
  State<RoadInfrastructureAlertsScreen> createState() =>
      _RoadInfrastructureAlertsScreenState();
}

class _LocalRoadReport {
  _LocalRoadReport({
    required this.corridor,
    required this.details,
    required this.savedAt,
  });

  final String corridor;
  final String details;
  final DateTime savedAt;
}

class _RoadInfrastructureAlertsScreenState
    extends State<RoadInfrastructureAlertsScreen> {
  final List<_LocalRoadReport> _localReports = [];

  Future<void> _openSource(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  Future<void> _showReportDialog() async {
    final corridorController = TextEditingController();
    final detailsController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Report a road condition'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Reports are saved on this device only. SmartMap Punjab has no '
                'connection to NHA, NHMP or rescue services and will not send '
                'this report anywhere.',
                style: TextStyle(fontSize: 12, color: AppTokens.textSecondary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: corridorController,
                decoration: const InputDecoration(
                  labelText: 'Road or location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: detailsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'What did you see?',
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
              if (corridorController.text.trim().isEmpty) return;
              setState(() {
                _localReports.insert(
                  0,
                  _LocalRoadReport(
                    corridor: corridorController.text.trim(),
                    details: detailsController.text.trim(),
                    savedAt: DateTime.now(),
                  ),
                );
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Saved on this device. It was not sent to any agency or '
                    'other users.',
                  ),
                ),
              );
            },
            child: const Text('Save on device'),
          ),
        ],
      ),
    );

    corridorController.dispose();
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
              'Road & route advisories',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'Reference guidance — not a live feed',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReportDialog,
        backgroundColor: AppTokens.pakistanGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text('Report condition'),
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
                    Icon(Icons.info_outline_rounded, color: AppTokens.warning),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Live road status is not connected',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'No NHA, NHMP, PDMA or NDMA status feed is integrated, so every '
                  'corridor below reports "Information unavailable" rather than a '
                  'guessed status. Confirm current conditions with the road '
                  'authorities before travelling.',
                  style: TextStyle(fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Major tourist corridors',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Seasonal patterns and official sources for pre-trip checks.',
            style: TextStyle(fontSize: 12, color: AppTokens.textSecondary),
          ),
          const SizedBox(height: 12),
          for (final advisory in kRoadAdvisories) ...[
            _AdvisoryCard(
              advisory: advisory,
              cardColor: cardColor,
              borderColor: borderColor,
              onOpenSource: () => _openSource(context, advisory.sourceUrl),
            ),
            const SizedBox(height: 12),
          ],
          if (_localReports.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Your saved reports (this device only)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            for (final report in _localReports)
              Card(
                color: cardColor,
                child: ListTile(
                  leading: const Icon(Icons.note_alt_outlined),
                  title: Text(report.corridor),
                  subtitle: Text(
                    '${report.details.isEmpty ? 'No details added.' : report.details}\n'
                    'Saved ${_formatDateTime(report.savedAt)}',
                  ),
                  isThreeLine: true,
                ),
              ),
          ],
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime value) {
    final d = value.day.toString().padLeft(2, '0');
    final m = value.month.toString().padLeft(2, '0');
    final hh = value.hour.toString().padLeft(2, '0');
    final mm = value.minute.toString().padLeft(2, '0');
    return '$d/$m/${value.year} $hh:$mm';
  }
}

class _AdvisoryCard extends StatelessWidget {
  const _AdvisoryCard({
    required this.advisory,
    required this.cardColor,
    required this.borderColor,
    required this.onOpenSource,
  });

  final RoadAdvisory advisory;
  final Color cardColor;
  final Color borderColor;
  final VoidCallback onOpenSource;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  advisory.corridor,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTokens.textSecondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  advisory.status.label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppTokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            advisory.segment,
            style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary),
          ),
          const SizedBox(height: 10),
          Text(
            advisory.seasonalGuidance,
            style: const TextStyle(fontSize: 13, height: 1.45),
          ),
          const SizedBox(height: 10),
          _labelled('Alternative', advisory.alternativeRoute),
          const SizedBox(height: 8),
          _labelled(
            'Source',
            '${advisory.sourceAgency} · reference compiled ${advisory.referenceDate}',
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onOpenSource,
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: Text(advisory.sourceUrl),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelled(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}
