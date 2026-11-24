import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/data/punjab_police_data.dart';
import '../../../core/theme/design_tokens.dart';

class PoliceDirectoryScreen extends StatefulWidget {
  const PoliceDirectoryScreen({super.key});
  @override
  State<PoliceDirectoryScreen> createState() => _PoliceDirectoryScreenState();
}

class _PoliceDirectoryScreenState extends State<PoliceDirectoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  final _search = TextEditingController();
  String _city = 'Islamabad';
  String _group = 'All';

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  List<String> get _groups {
    final values = policeDirectoryEntries
        .where((e) => e.city == _city)
        .map((e) => _city == 'Islamabad' ? e.zone : e.division)
        .whereType<String>().toSet().toList()..sort();
    return ['All', ...values];
  }

  List<PoliceDirectoryEntry> get _stations {
    final q = _search.text.trim().toLowerCase();
    return policeDirectoryEntries.where((e) {
      if (e.city != _city) return false;
      final group = _city == 'Islamabad' ? e.zone : e.division;
      if (_group != 'All' && group != _group) return false;
      if (q.isEmpty) return true;
      return [e.name, e.zone, e.division, e.circle, e.phone, e.location, e.areas]
          .whereType<String>().any((v) => v.toLowerCase().contains(q));
    }).toList(growable: false);
  }

  List<PoliceAreaCoverage> get _areas {
    final q = _search.text.trim().toLowerCase();
    if (_city != 'Islamabad') return const [];
    return islamabadAreaCoverage.where((e) {
      if (_group != 'All' && e.zone != _group) return false;
      return q.isEmpty ||
          (e.area + ' ' + e.station + ' ' + e.zone + ' ' + (e.phone ?? ''))
              .toLowerCase().contains(q);
    }).toList(growable: false);
  }

  Future<void> _open(Uri uri) async {
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } catch (_) {}
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the requested app.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIslamabad = _city == 'Islamabad';
    final stations = _stations;
    final areas = _areas;
    return Scaffold(
      backgroundColor: AppTokens.dashboardBg,
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Police directory'),
            Text('Stations, hierarchy and area coverage',
              style: TextStyle(fontSize: 11, color: AppTokens.textMuted)),
          ]),
        bottom: TabBar(controller: _tabs, labelColor: AppTokens.emerald,
          tabs: [
            Tab(text: 'Stations (' + stations.length.toString() + ')'),
            Tab(text: 'Area lookup (' + areas.length.toString() + ')'),
          ]),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Column(children: [
            Row(children: [
              Expanded(child: _Dropdown(value: _city, label: 'City',
                values: const ['Islamabad', 'Lahore'],
                onChanged: (v) => setState(() { _city = v; _group = 'All'; }))),
              const SizedBox(width: 10),
              Expanded(child: _Dropdown(value: _group,
                label: isIslamabad ? 'Police zone' : 'Police division',
                values: _groups,
                onChanged: (v) => setState(() => _group = v))),
            ]),
            const SizedBox(height: 10),
            TextField(controller: _search, onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search station, sector, circle or phone',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty ? null : IconButton(
                  onPressed: () { _search.clear(); setState(() {}); },
                  icon: const Icon(Icons.close)),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
              )),
          ]),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 2, 16, 10),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(color: AppTokens.goldTint,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTokens.goldBorder)),
          child: const Text(
            'Independent directory snapshot, not an official or live police feed. '
            'Phone numbers and jurisdictions can change. Confirm details with '
            'the relevant police office. For urgent police assistance, call 15.',
            style: TextStyle(fontSize: 11, height: 1.4,
              color: AppTokens.textSecondary)),
        ),
        Expanded(child: TabBarView(controller: _tabs, children: [
          stations.isEmpty ? const _Empty() : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: stations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 9),
            itemBuilder: (_, i) => _StationCard(entry: stations[i], onOpen: _open)),
          !isIslamabad ? const _Empty(message:
            'Area-to-station coverage is currently available for Islamabad only.')
            : areas.isEmpty ? const _Empty() : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: areas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final a = areas[i];
                return Card(color: Colors.white, elevation: 0,
                  child: ListTile(
                    title: Text(a.area, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(a.station + ' · ' + a.zone +
                      (a.phone == null ? '' : ' · ' + a.phone!)),
                    trailing: a.phone == null ? null : IconButton(
                      icon: const Icon(Icons.call_outlined, color: AppTokens.emerald),
                      onPressed: () => _open(Uri(scheme: 'tel', path: a.phone))),
                  ));
              }),
        ])),
      ]),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.value, required this.label,
    required this.values, required this.onChanged});
  final String value, label;
  final List<String> values;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: value, isExpanded: true,
    decoration: InputDecoration(labelText: label, filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
    items: values.map((v) => DropdownMenuItem(value: v,
      child: Text(v, overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12)))).toList(),
    onChanged: (v) { if (v != null) onChanged(v); },
  );
}

class _StationCard extends StatelessWidget {
  const _StationCard({required this.entry, required this.onOpen});
  final PoliceDirectoryEntry entry;
  final Future<void> Function(Uri) onOpen;
  @override
  Widget build(BuildContext context) {
    final e = entry;
    final hierarchy = e.city == 'Islamabad' ? e.zone :
      (e.division ?? '') + (e.circle == null ? '' : ' · ' + e.circle!);
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTokens.border), boxShadow: AppShadows.card),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const CircleAvatar(backgroundColor: AppTokens.pastelMint,
            child: Icon(Icons.local_police_rounded, color: AppTokens.emerald)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(e.city + ' · ' + e.type,
                style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary)),
            ])),
        ]),
        if (hierarchy != null && hierarchy.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(hierarchy, style: const TextStyle(fontSize: 11,
            color: AppTokens.emerald, fontWeight: FontWeight.w600)),
        ],
        if (e.location != null) Padding(padding: const EdgeInsets.only(top: 5),
          child: Text('Location: ' + e.location!,
            style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary))),
        if (e.areas != null) Padding(padding: const EdgeInsets.only(top: 5),
          child: Text('Areas: ' + e.areas!,
            style: const TextStyle(fontSize: 11, height: 1.35,
              color: AppTokens.textSecondary))),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: Text(e.phone ?? 'Phone not listed',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
          if (e.phone != null) IconButton(tooltip: 'Call station',
            visualDensity: VisualDensity.compact,
            onPressed: () => onOpen(Uri(scheme: 'tel', path: e.phone)),
            icon: const Icon(Icons.call_outlined, color: AppTokens.emerald)),
          IconButton(tooltip: 'Find on map', visualDensity: VisualDensity.compact,
            onPressed: () => onOpen(Uri.https('www.google.com', '/maps/search/',
              {'api': '1', 'query': e.name + ' Police Station, ' + e.city})),
            icon: const Icon(Icons.map_outlined, color: AppTokens.emerald)),
        ]),
        Text('Source: ' + e.source,
          style: const TextStyle(fontSize: 9.5, color: AppTokens.textMuted)),
      ]),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({this.message = 'No matching directory entries.'});
  final String message;
  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(28),
    child: Text(message, textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary))));
}
