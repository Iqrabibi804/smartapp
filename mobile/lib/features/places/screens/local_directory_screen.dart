import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/design_tokens.dart';

class LocalDirectoryScreen extends StatefulWidget {
  const LocalDirectoryScreen({super.key});
  @override
  State<LocalDirectoryScreen> createState() => _LocalDirectoryScreenState();
}

class _LocalDirectoryScreenState extends State<LocalDirectoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabs;
  final search = TextEditingController();
  Map<String, dynamic> data = {};
  bool loading = true;
  String city = 'All cities';
  String? error;
  static const categories = [
    ('Bus stations', 'busStations'),
    ('Hotels', 'hotels'),
    ('Restaurants', 'restaurants'),
    ('Police reference', 'police'),
  ];

  @override
  void initState() {
    super.initState();
    tabs = TabController(length: categories.length, vsync: this)
      ..addListener(() => setState(() {}));
    search.addListener(() => setState(() {}));
    load();
  }

  @override
  void dispose() {
    tabs.dispose();
    search.dispose();
    super.dispose();
  }

  Future<void> load() async {
    try {
      final compressed = await rootBundle.load('assets/data/punjab_directory.json.gz');
      final bytes = compressed.buffer.asUint8List(
        compressed.offsetInBytes,
        compressed.lengthInBytes,
      );
      final jsonBytes = GZipDecoder().decodeBytes(bytes);
      final decoded = jsonDecode(utf8.decode(jsonBytes));
      if (decoded is! Map<String, dynamic>) throw const FormatException();
      if (!mounted) return;
      setState(() { data = decoded; loading = false; error = null; });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        loading = false;
        error = 'Directory data is not installed. Run scripts/import_directory_workbook.py and rebuild.';
      });
    }
  }

  List<Map<String, dynamic>> get records {
    final key = categories[tabs.index].$2;
    if (key == 'police') {
      final stations = [
        ...(data['islamabadPolice'] as List? ?? const []),
        ...(data['lahorePolice'] as List? ?? const []),
      ].whereType<Map>().map((e) => Map<String, dynamic>.from(e));
      final areaMappings = (data['islamabadAreaToStation'] as List? ?? const [])
          .whereType<Map>()
          .map((e) {
            final row = Map<String, dynamic>.from(e);
            return <String, dynamic>{
              'City': row['City'],
              'Police Station': row['Covered by Police Station'],
              'Police Zone': row['Police Zone'],
              'Area / Sector': row['Area / Sector'],
              'Phone': row['Phone'],
              '_referenceType': 'Area mapping',
            };
          });
      return [...stations, ...areaMappings];
    }
    return (data[key] as List? ?? const [])
        .whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  String cityOf(Map<String, dynamic> r) => (r['City'] ?? '').toString();

  Future<void> openLink(String value) async {
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return;
    try { await launchUrl(uri, mode: LaunchMode.externalApplication); } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final key = categories[tabs.index].$2;
    final all = records;
    final cities = all.map(cityOf).where((e) => e.isNotEmpty).toSet().toList()..sort();
    final q = search.text.trim().toLowerCase();
    final selectedCity = cities.contains(city) ? city : 'All cities';
    final shown = all.where((r) {
      if (selectedCity != 'All cities' && cityOf(r) != selectedCity) return false;
      return q.isEmpty || r.values.any((v) => v.toString().toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: AppTokens.dashboardBg,
      appBar: AppBar(
        title: const Text('Punjab Local Directory'),
        backgroundColor: Colors.white,
        foregroundColor: AppTokens.textPrimary,
        bottom: TabBar(
          controller: tabs, isScrollable: true,
          labelColor: AppTokens.emerald, unselectedLabelColor: AppTokens.textSecondary,
          indicatorColor: AppTokens.emerald,
          tabs: [for (final c in categories) Tab(text: c.$1)],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: load, child: const Text('Retry')),
                  ]),
                ))
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                    child: Column(children: [
                      TextField(
                        controller: search,
                        decoration: InputDecoration(
                          hintText: 'Search name, area or city',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: search.text.isEmpty ? null : IconButton(
                            onPressed: search.clear, icon: const Icon(Icons.close)),
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCity,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Filter by city'),
                        items: [
                          const DropdownMenuItem(value: 'All cities', child: Text('All cities')),
                          ...cities.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                        ],
                        onChanged: (v) => setState(() => city = v ?? 'All cities'),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Row(children: [
                      Text('${shown.length} entries', style: const TextStyle(fontSize: 12, color: AppTokens.textSecondary)),
                      const Spacer(),
                      Text(key == 'police' ? 'Secondary-source reference' : 'Unverified listings',
                        style: const TextStyle(fontSize: 10, color: AppTokens.gold)),
                    ]),
                  ),
                  Expanded(child: shown.isEmpty
                    ? const Center(child: Text('No records are available in this category yet. Run the workbook importer to populate the offline directory.'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(14),
                        itemCount: shown.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _DirectoryCard(
                          item: shown[i], category: key, onOpen: openLink),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 3, 12, 10),
                    child: Text(
                      key == 'police'
                        ? 'Secondary-source reference only. Not an official emergency directory. Use official emergency helplines.'
                        : 'Listings do not confirm opening status, service availability or current contact details. © OpenStreetMap contributors · ODbL',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9, color: key == 'police' ? AppTokens.alertRed : AppTokens.textMuted),
                    ),
                  ),
                ]),
    );
  }
}

class _DirectoryCard extends StatelessWidget {
  const _DirectoryCard({required this.item, required this.category, required this.onOpen});
  final Map<String, dynamic> item;
  final String category;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final police = category == 'police';
    final name = category == 'busStations' ? item['Station']
      : category == 'hotels' ? item['Hotel / guest house']
      : category == 'restaurants' ? item['Restaurant']
      : item['Police Station'] ?? item['Station / Post'];
    final city = item['City'] ?? '';
    final detail = category == 'busStations' ? item['Type']
      : category == 'hotels' ? item['Type']
      : category == 'restaurants' ? item['Cuisine / specialty'] ?? item['Area / street']
      : item['Area / Sector'] ?? item['Police Zone'] ?? item['Police Division'] ?? item['Circle'];
    final phone = item['Phone'];
    final link = item['OSM link'] ?? item['Google Maps'] ?? '';
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppTokens.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text((name ?? 'Unnamed listing').toString(),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTokens.textPrimary)),
        const SizedBox(height: 3),
        Text([city, detail ?? ''].where((v) => v.toString().trim().isNotEmpty).join(' · '),
          style: const TextStyle(fontSize: 11, color: AppTokens.textSecondary)),
        if (phone != null && phone.toString().isNotEmpty)
          const Padding(padding: EdgeInsets.only(top: 5),
            child: Text('Contact details hidden until independently verified',
              style: TextStyle(fontSize: 10, color: AppTokens.textMuted))),
        Row(children: [
          if (link.toString().isNotEmpty)
            TextButton.icon(onPressed: () => onOpen(link.toString()),
              icon: const Icon(Icons.open_in_new, size: 14),
              label: Text(item['OSM link'] != null ? 'Open OSM' : 'Map search')),
          const Spacer(),
          Text(police ? 'Secondary source' : 'Unverified',
            style: TextStyle(fontSize: 9, color: police ? AppTokens.alertRed : AppTokens.gold)),
        ]),
      ]),
    );
  }
}
