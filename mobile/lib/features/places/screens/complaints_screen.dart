import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/offline/offline_cache.dart';
import '../../../core/theme/design_tokens.dart';

const String _complaintsKey = 'local_complaints_v1';

const List<String> kComplaintCategories = [
  'Overcharging',
  'Misleading hotel information',
  'Poor facilities',
  'Road problem',
  'Safety concern',
  'Damaged infrastructure',
  'Incorrect destination information',
  'Other',
];

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();
  String _category = kComplaintCategories.first;
  List<Map<String, dynamic>> _saved = [];
  bool _loaded = false;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _restore() async {
    final raw = OfflineCache.instance.read(_complaintsKey);
    if (raw is List) {
      _saved = raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (mounted) setState(() => _loaded = true);
  }

  Future<void> _save() async {
    if (_locationController.text.trim().isEmpty ||
        _detailsController.text.trim().isEmpty) {
      return;
    }
    final id =
        'CMP-${DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase()}';
    final report = <String, dynamic>{
      'id': id,
      'category': _category,
      'location': _locationController.text.trim(),
      'details': _detailsController.text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'Saved on device — not submitted',
    };
    final updated = [report, ..._saved];
    await OfflineCache.instance.put(
      _complaintsKey,
      updated,
      ttl: const Duration(days: 3650),
    );
    if (!mounted) return;
    setState(() {
      _saved = updated;
      _showForm = false;
      _locationController.clear();
      _detailsController.clear();
      _category = kComplaintCategories.first;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Saved on this device with a reference number. It was not submitted '
          'to any authority.',
        ),
      ),
    );
  }

  Future<void> _openPortal() async {
    final uri = Uri.parse('https://citizenportal.gov.pk');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the official portal.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTokens.surfaceDark : Colors.white;
    final borderColor = isDark ? AppTokens.borderDark : AppTokens.border;

    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report an issue',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              'Local record — not an official complaint',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _showForm = !_showForm),
        backgroundColor: AppTokens.pakistanGreen,
        foregroundColor: Colors.white,
        icon: Icon(_showForm ? Icons.close : Icons.add),
        label: Text(_showForm ? 'Close form' : 'New report'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTokens.warning.withValues(alpha: isDark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppTokens.warning.withValues(alpha: 0.35)),
            ),
            child: const Text(
              'This screen keeps your report on this device only. SmartMap Punjab '
              'is not an official complaints channel and cannot forward reports to '
              'any department. For an official complaint use the Pakistan Citizen '
              'Portal or contact the relevant department directly.',
              style: TextStyle(fontSize: 12.5, height: 1.45),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _openPortal,
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Open the Pakistan Citizen Portal'),
            ),
          ),
          if (_showForm) ...[
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
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: kComplaintCategories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v ?? _category),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Place or location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _detailsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'What happened?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Photo attachments are not available until a secure upload '
                    'channel exists.',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTokens.pakistanGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _save,
                      child: const Text('Save report on this device'),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Your saved reports',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (_saved.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: borderColor),
              ),
              child: const Text(
                'No reports saved yet.',
                style: TextStyle(fontSize: 12.5, color: AppTokens.textSecondary),
              ),
            )
          else
            for (final report in _saved)
              Card(
                color: cardColor,
                child: ListTile(
                  leading: const Icon(Icons.assignment_outlined),
                  title: Text(
                    '${report['category']} · ${report['id']}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(
                    '${report['location']}\n'
                    '${report['details']}\n'
                    '${report['status']}',
                    style: const TextStyle(fontSize: 11.5, height: 1.4),
                  ),
                  isThreeLine: true,
                ),
              ),
        ],
      ),
    );
  }
}
