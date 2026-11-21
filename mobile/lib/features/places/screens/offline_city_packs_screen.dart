import 'dart:async';
import 'package:flutter/material.dart';

class CityPackInfo {
  final String id;
  final String cityName;
  final String urduName;
  final String sizeMb;
  final String spotsCount;
  final String highlights;
  final String icon;
  bool isDownloaded;
  double downloadProgress;

  CityPackInfo({
    required this.id,
    required this.cityName,
    required this.urduName,
    required this.sizeMb,
    required this.spotsCount,
    required this.highlights,
    required this.icon,
    this.isDownloaded = false,
    this.downloadProgress = 0.0,
  });
}

class OfflineCityPacksScreen extends StatefulWidget {
  const OfflineCityPacksScreen({super.key});

  @override
  State<OfflineCityPacksScreen> createState() => _OfflineCityPacksScreenState();
}

class _OfflineCityPacksScreenState extends State<OfflineCityPacksScreen> {
  final List<CityPackInfo> _packs = [
    CityPackInfo(
      id: 'lhr',
      cityName: 'Lahore Heritage & Food',
      urduName: 'لاہور مکمل ہیریٹیج و میٹرو گائیڈ',
      sizeMb: '32 MB',
      spotsCount: '180+ مقامات',
      highlights: 'شاہی قلعہ، بادشاہی مسجد، فوڈ اسٹریٹ، اورنج لائن روٹ، ایمرجنسی ہاسپٹل',
      icon: '🕌',
      isDownloaded: true,
      downloadProgress: 1.0,
    ),
    CityPackInfo(
      id: 'mre',
      cityName: 'Murree & Galyat Mountains',
      urduName: 'مری و گلیات آف لائن ٹریول پیک',
      sizeMb: '26 MB',
      spotsCount: '95+ مقامات',
      highlights: 'مال روڈ، پتریاٹہ چیئر لفٹ، نتھیا گلی، لینڈ سلائیڈ چیک، سگنل کے بغیر روٹ',
      icon: '🌲',
      isDownloaded: true,
      downloadProgress: 1.0,
    ),
    CityPackInfo(
      id: 'shw',
      cityName: 'Sahiwal & Harappa Museum',
      urduName: 'ساہیوال و ہڑپہ تاریخی پیک',
      sizeMb: '18 MB',
      spotsCount: '60+ مقامات',
      highlights: 'ہڑپہ میوزیم، مستند دیسی مکھن و مٹھائی دکانیں، چنگچی اور کوسٹر اڈے',
      icon: '🏺',
      isDownloaded: true,
      downloadProgress: 1.0,
    ),
    CityPackInfo(
      id: 'isb_rwp',
      cityName: 'Islamabad & Rawalpindi',
      urduName: 'اسلام آباد و راولپنڈی میٹرو پیک',
      sizeMb: '34 MB',
      spotsCount: '150+ مقامات',
      highlights: 'فیصل مسجد، دامن کوہ، راجہ بازار، میٹرو بس روٹ، کینٹ ہسپتال',
      icon: '🏛️',
    ),
    CityPackInfo(
      id: 'hrp',
      cityName: 'Haripur & Khanpur Dam',
      urduName: 'ہری پور و خانپور ڈیم واٹر پیک',
      sizeMb: '20 MB',
      spotsCount: '50+ مقامات',
      highlights: 'خانپور ڈیم بوٹنگ اسپاٹس، چپلی کباب روٹس، ہری پور لوکل کرایہ فہرست',
      icon: '🚤',
    ),
    CityPackInfo(
      id: 'mlt_bwp',
      cityName: 'Multan & Bahawalpur',
      urduName: 'ملتان و بہاولپور صوفی و قلعہ پیک',
      sizeMb: '28 MB',
      spotsCount: '110+ مقامات',
      highlights: 'شاہ رکن عالم دربار، قلعہ دراوڑ چولستان، نور محل، سرائیکی گائیڈ',
      icon: '🏰',
    ),
  ];

  void _startDownload(CityPackInfo pack) {
    setState(() {
      pack.downloadProgress = 0.05;
    });

    Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        pack.downloadProgress += 0.15;
        if (pack.downloadProgress >= 1.0) {
          pack.downloadProgress = 1.0;
          pack.isDownloaded = true;
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${pack.urduName} کامیابی سے ڈاؤنلوڈ ہو گیا! اب یہ بغیر انٹرنیٹ کے چلے گا۔'),
              backgroundColor: const Color(0xFF059669),
            ),
          );
        }
      });
    });
  }

  void _deletePack(CityPackInfo pack) {
    setState(() {
      pack.isDownloaded = false;
      pack.downloadProgress = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pack.cityName} آف لائن ڈیٹا ہٹا دیا گیا')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final downloadedCount = _packs.where((p) => p.isDownloaded).length;
    final totalUsedMb = _packs.where((p) => p.isDownloaded).fold<int>(
          0,
          (sum, p) => sum + int.parse(p.sizeMb.replaceAll(RegExp(r'[^0-9]'), '')),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('آف لائن سٹی پیکس (30MB Packs)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Header Banner ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF047857)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cloud_download, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بغیر سم ڈیٹا و انٹرنیٹ کے چلائیں',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Download full city pack in ~30MB. Maps, bus routes, Urdu audio, and SOS work 100% offline.',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Storage Status Indicator ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sd_storage, color: Color(0xFF059669), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'ڈاؤنلوڈ شدہ شہر: $downloadedCount / ${_packs.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'استعمال: $totalUsedMb MB',
                      style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'تمام شہروں کے آف لائن پیکس (Downloadable Packs):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),

            // ── Packs List ──
            for (final pack in _packs) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: pack.isDownloaded
                        ? const Color(0xFF10B981)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(pack.icon, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pack.urduName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(pack.cityName, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(pack.sizeMb, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pack.highlights,
                      style: const TextStyle(fontSize: 12, height: 1.3),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.place, size: 14, color: Color(0xFF059669)),
                        const SizedBox(width: 4),
                        Text(pack.spotsCount, style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                        const Spacer(),
                        if (pack.downloadProgress > 0 && pack.downloadProgress < 1.0) ...[
                          SizedBox(
                            width: 120,
                            child: LinearProgressIndicator(
                              value: pack.downloadProgress,
                              color: const Color(0xFF059669),
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                        ] else if (pack.isDownloaded) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, size: 14, color: Color(0xFF10B981)),
                                SizedBox(width: 4),
                                Text('آف لائن تیار ہے', style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                            tooltip: 'حذف کریں',
                            onPressed: () => _deletePack(pack),
                          ),
                        ] else ...[
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF059669),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => _startDownload(pack),
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text('ڈاؤنلوڈ 30MB', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
