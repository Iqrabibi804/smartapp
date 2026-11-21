import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/punjab_81_cities_data.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/services/auth_providers.dart';
import '../../auth/screens/login_screen.dart';
import '../../map/screens/map_screen.dart';
import '../../search/screens/search_results_screen.dart';
import '../../categories/services/categories_service.dart';
import '../../categories/models/category_model.dart';
import '../../favorites/screens/saved_places_screen.dart';
import '../../ai/screens/map_ai_screen.dart';
import '../../trips/screens/trip_planner_screen.dart';
import '../../trips/screens/my_trips_screen.dart';
import '../../events/services/events_service.dart';
import '../../events/screens/events_list_screen.dart';
import '../../events/screens/event_details_screen.dart';
import '../../business/screens/business_registration_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../places/models/place_model.dart';
import '../../places/screens/place_details_screen.dart';
import '../../places/screens/city_guide_screen.dart';
import '../../places/screens/city_explorer_screen.dart';
import '../../places/services/places_providers.dart';
import '../../trips/screens/budget_calculator_screen.dart';
import '../../trips/screens/group_bill_splitter_screen.dart';
import '../../places/screens/local_vs_tourist_price_screen.dart';
import '../../places/screens/offline_city_packs_screen.dart';
import '../../places/screens/offline_payment_guide_screen.dart';
import '../../places/screens/road_infrastructure_alerts_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tabIndex = 0;

  Widget _bodyForTab(int index) {
    switch (index) {
      case 0:
        return const _HomeTabContent();
      case 1:
        return const MapScreen();
      case 2:
        return const CityExplorerScreen();
      case 3:
        return const SavedPlacesScreen();
      case 4:
        return const _ProfileTabPlaceholder();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(child: _bodyForTab(_tabIndex)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MapAiScreen()),
          );
        },
        backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
        icon: const Icon(Icons.auto_awesome, color: Color(0xFF10B981)),
        label: Text(
          AppStrings.tr('ai_guide', lang),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A)),
            label: AppStrings.tr('tab_home', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map, color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A)),
            label: AppStrings.tr('tab_map', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_city_outlined),
            selectedIcon: Icon(Icons.location_city, color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A)),
            label: AppStrings.tr('tab_cities', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark, color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A)),
            label: AppStrings.tr('tab_saved', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A)),
            label: AppStrings.tr('tab_profile', lang),
          ),
        ],
      ),
    );
  }
}

class _HomeTabContent extends ConsumerStatefulWidget {
  const _HomeTabContent();

  @override
  ConsumerState<_HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends ConsumerState<_HomeTabContent> {
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;

  static const _banners = [
    (
      'Lahore: Heart of Punjab',
      'Badshahi Mosque, Shahi Qila, Shalimar & Food Street',
      'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1200&q=80',
      'lahore',
      'لاہور',
      'Historical & Food Street',
    ),
    (
      'Islamabad & Margalla Hills',
      'Faisal Mosque, Daman-e-Koh, Monal & Pine Trails',
      'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=1200&q=80',
      'islamabad',
      'اسلام آباد',
      'Scenic & Fine Dining',
    ),
    (
      'Bahawalpur & Cholistan Desert',
      'Derawar Fort, Noor Mahal & Jeep Rally Heritage',
      'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1200&q=80',
      'bahawalpur',
      'بہاولپور',
      'Desert & Royal Palaces',
    ),
    (
      'Murree & Galliyat Foothills',
      'Mall Road, Patriata Cable Car & Cool Alpine Vistas',
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80',
      'murree',
      'مری',
      'Hill Station & Snow',
    ),
    (
      'Taxila: Gandhara UNESCO Site',
      'Dharmarajika Stupa, Sirkap & Ancient Buddhist Relics',
      'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1200&q=80',
      'taxila',
      'ٹیکسلا',
      'Ancient Civilization',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        final page = _bannerController.page?.round() ?? 0;
        final next = (page + 1) % _banners.length;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _makeCall(String number) async {
    final uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final popularPlacesAsync = ref.watch(popularPlacesProvider);
    final lang = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // ── Top Header & Location ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 360;
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isDark ? Colors.white12 : const Color(0xFF0F172A).withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.location_on, size: 14, color: Color(0xFF059669)),
                                          SizedBox(width: 4),
                                          Text('Punjab, Pakistan 🇵🇰',
                                              style: TextStyle(
                                                color: Color(0xFF059669),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF059669).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text('TDCP Verified 🛡️',
                                          style: TextStyle(
                                            color: Color(0xFF059669),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppStrings.tr('app_title', lang),
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: primaryTextColor),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              // Language Selector Pill
                              PopupMenuButton<AppLanguage>(
                                icon: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A).withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.language, size: 16, color: primaryTextColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        lang == AppLanguage.english
                                            ? 'EN'
                                            : lang == AppLanguage.urdu
                                                ? 'اردو'
                                                : lang == AppLanguage.punjabi
                                                    ? 'پنجابی'
                                                    : lang == AppLanguage.chinese
                                                        ? '中文'
                                                        : 'عربي',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                                onSelected: (selectedLang) => ref.read(languageProvider.notifier).setLanguage(selectedLang),
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: AppLanguage.english, child: Text('🇬🇧 English (Global)')),
                                  PopupMenuItem(value: AppLanguage.urdu, child: Text('🇵🇰 اردو (Pakistan)')),
                                  PopupMenuItem(value: AppLanguage.punjabi, child: Text('🇵🇰 پنجابی (Punjab)')),
                                  PopupMenuItem(value: AppLanguage.chinese, child: Text('🇨🇳 中文 (Chinese)')),
                                  PopupMenuItem(value: AppLanguage.arabic, child: Text('🇸🇦 العربية (Arabic)')),
                                ],
                              ),
                              const SizedBox(width: 8),
                              // Pakistan Cultural Theme Palette Selector
                              PopupMenuButton<PakistanPalette>(
                                tooltip: 'Pakistan Theme Palette',
                                icon: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A).withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black12),
                                  ),
                                  child: const Icon(Icons.palette_outlined, size: 16, color: Color(0xFF006644)),
                                ),
                                onSelected: (p) {
                                  ref.read(pakistanPaletteProvider.notifier).setPalette(p);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        p == PakistanPalette.heritageAndNature
                                            ? '🎨 Theme: Heritage & Nature (قومی پرچم و دیسی اینٹ)'
                                            : p == PakistanPalette.northernPeaksAndGlaciers
                                                ? '🏔️ Theme: Northern Peaks & Glaciers (سیف الملوک و عطاء آباد)'
                                                : '🛺 Theme: Vibrant Truck Art (ٹرک آرٹ و چمبیلی)',
                                      ),
                                      backgroundColor: const Color(0xFF006644),
                                    ),
                                  );
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: PakistanPalette.heritageAndNature, child: Row(children: [
                                    CircleAvatar(radius: 6, backgroundColor: Color(0xFF006644)),
                                    SizedBox(width: 8),
                                    Text('🌲 Heritage & Nature (#006644)')
                                  ])),
                                  PopupMenuItem(value: PakistanPalette.northernPeaksAndGlaciers, child: Row(children: [
                                    CircleAvatar(radius: 6, backgroundColor: Color(0xFF1D4ED8)),
                                    SizedBox(width: 8),
                                    Text('🏔️ Northern Peaks (#1D4ED8)')
                                  ])),
                                  PopupMenuItem(value: PakistanPalette.vibrantTruckArt, child: Row(children: [
                                    CircleAvatar(radius: 6, backgroundColor: Color(0xFF0D9488)),
                                    SizedBox(width: 8),
                                    Text('🛺 Truck Art Palette (#0D9488)')
                                  ])),
                                ],
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.06),
                                child: IconButton(
                                  icon: const Icon(Icons.tune, color: Color(0xFF0F172A), size: 18),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const CityExplorerScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // The same content as above but stacked vertically for narrow screens
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white12 : const Color(0xFF0F172A).withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.location_on, size: 14, color: Color(0xFF059669)),
                                    SizedBox(width: 4),
                                    Text('Punjab, Pakistan 🇵🇰',
                                        style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF059669).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('TDCP Verified 🛡️',
                                    style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppStrings.tr('app_title', lang),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5, color: primaryTextColor),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Language Selector Pill
                              PopupMenuButton<AppLanguage>(
                                icon: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A).withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.language, size: 16, color: primaryTextColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        lang == AppLanguage.english
                                            ? 'EN'
                                            : lang == AppLanguage.urdu
                                                ? 'اردو'
                                                : lang == AppLanguage.punjabi
                                                    ? 'پنجابی'
                                                    : lang == AppLanguage.chinese
                                                        ? '中文'
                                                        : 'عربي',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                                onSelected: (selectedLang) => ref.read(languageProvider.notifier).setLanguage(selectedLang),
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: AppLanguage.english, child: Text('🇬🇧 English (Global)')),
                                  PopupMenuItem(value: AppLanguage.urdu, child: Text('🇵🇰 اردو (Pakistan)')),
                                  PopupMenuItem(value: AppLanguage.punjabi, child: Text('🇵🇰 پنجابی (Punjab)')),
                                  PopupMenuItem(value: AppLanguage.chinese, child: Text('🇨🇳 中文 (Chinese)')),
                                  PopupMenuItem(value: AppLanguage.arabic, child: Text('🇸🇦 العربية (Arabic)')),
                                ],
                              ),
                              const SizedBox(width: 8),
                              // Palette Selector
                              PopupMenuButton<PakistanPalette>(
                                tooltip: 'Pakistan Theme Palette',
                                icon: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A).withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black12),
                                  ),
                                  child: const Icon(Icons.palette_outlined, size: 16, color: Color(0xFF006644)),
                                ),
                                onSelected: (p) {
                                  ref.read(pakistanPaletteProvider.notifier).setPalette(p);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        p == PakistanPalette.heritageAndNature
                                            ? '🎨 Theme: Heritage & Nature (قومی پرچم و دیسی اینٹ)'
                                            : p == PakistanPalette.northernPeaksAndGlaciers
                                                ? '🏔️ Theme: Northern Peaks & Glaciers (سیف الملوک و عطاء آباد)'
                                                : '🛺 Theme: Vibrant Truck Art (ٹرک آرٹ و چمبیلی)',
                                      ),
                                      backgroundColor: const Color(0xFF006644),
                                    ),
                                  );
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: PakistanPalette.heritageAndNature, child: Row(children: [
                                    CircleAvatar(radius: 6, backgroundColor: Color(0xFF006644)),
                                    SizedBox(width: 8),
                                    Text('🌲 Heritage & Nature (#006644)')
                                  ])),
                                  PopupMenuItem(value: PakistanPalette.northernPeaksAndGlaciers, child: Row(children: [
                                    CircleAvatar(radius: 6, backgroundColor: Color(0xFF1D4ED8)),
                                    SizedBox(width: 8),
                                    Text('🏔️ Northern Peaks (#1D4ED8)')
                                  ])),
                                  PopupMenuItem(value: PakistanPalette.vibrantTruckArt, child: Row(children: [
                                    CircleAvatar(radius: 6, backgroundColor: Color(0xFF0D9488)),
                                    SizedBox(width: 8),
                                    Text('🛺 Truck Art Palette (#0D9488)')
                                  ])),
                                ],
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.06),
                                child: IconButton(
                                  icon: const Icon(Icons.tune, color: Color(0xFF0F172A), size: 18),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const CityExplorerScreen()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              );
            },
          )
        ),

        // ── Search Bar ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchResultsScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppStrings.tr('search_hint', lang),
                      style: TextStyle(color: secondaryTextColor, fontSize: 14),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: secondaryTextColor, size: 14),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── 🚨 1-Tap Emergency Helpline Ribbon (24/7 Free Call) ─────────────
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildHelplineChip('🚑 Rescue 1122', '1122', const Color(0xFFDC2626)),
              const SizedBox(width: 8),
              _buildHelplineChip('👮 Police 15', '15', const Color(0xFF2563EB)),
              const SizedBox(width: 8),
              _buildHelplineChip('🛣️ Motorway 130', '130', const Color(0xFFD97706)),
              const SizedBox(width: 8),
              _buildHelplineChip('🏛️ Tourist Help 1421', '1421', const Color(0xFF059669)),
              const SizedBox(width: 8),
              _buildHelplineChip('📞 Citizen Portal 1787', '1787', const Color(0xFF7C3AED)),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── 3D Hero Banner Carousel with City Guides ────────────────────────
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            itemBuilder: (context, i) {
              final b = _banners[i];
              return GestureDetector(
                onTap: () {
                  final matchedCity = Punjab81CitiesData.allCities.firstWhere(
                    (c) => c.name.toLowerCase() == b.$4.toLowerCase(),
                    orElse: () => Punjab81CitiesData.allCities.first,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => CityGuideScreen(city: matchedCity)),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        b.$3,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade400),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color(0x77000000),
                              Color(0xDD000000),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Top Pill: City Urdu Badge & Tag
                      Positioned(
                        top: 14,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    b.$6,
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF059669),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                b.$5,
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bottom Details & Action
                      Positioned(
                        bottom: 14,
                        left: 16,
                        right: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.$1,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    b.$2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.88),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white38),
                              ),
                              child: const Row(
                                children: [
                                  Text('Guide', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),
        Center(
          child: SmoothPageIndicator(
            controller: _bannerController,
            count: _banners.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 5,
              dotWidth: 6,
              activeDotColor: Color(0xFF059669),
              dotColor: Colors.black12,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ── 🌟 3D LAYMAN ASSISTANT HUB (عام آدمی کے لیے 4 بڑے امدادی کارڈز) ───
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.tr('smart_assistant', lang),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('آسان سفری سہولیات', style: TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2x2 Grid of Large, 3D Embossed Cards
              Row(
                children: [
                  // 1. Hospitals & Emergency
                  _build3DAssistantCard(
                    title: AppStrings.tr('hospitals', lang),
                    urduTitle: 'ہاسپٹلز و کلینک',
                    subtitle: '24/7 Verified Emergency',
                    badge: '🚑 Free Help',
                    icon: Icons.local_hospital_rounded,
                    colors: [const Color(0xFF065F46), const Color(0xFF047857)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SearchResultsScreen(
                            initialCategoryName: 'Hospitals & Medical',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // 2. Route Planner
                  _build3DAssistantCard(
                    title: AppStrings.tr('route_planner', lang),
                    urduTitle: 'سمارٹ روٹ پلانر',
                    subtitle: 'M-2 / M-3 Motorway & Fuel',
                    badge: '🛣️ Highway',
                    icon: Icons.alt_route_rounded,
                    colors: [const Color(0xFF0F172A), const Color(0xFF1E293B)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TripPlannerScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // 3. Bakeries & Cakes
                  _build3DAssistantCard(
                    title: AppStrings.tr('bakeries', lang),
                    urduTitle: 'کیک، بیکریز و کھانا',
                    subtitle: 'Order Fresh from Top Shops',
                    badge: '🎂 Food Delivery',
                    icon: Icons.cake_rounded,
                    colors: [const Color(0xFF831843), const Color(0xFF9D174D)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SearchResultsScreen(
                            initialCategoryName: 'Bakeries & Cakes',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // 4. Tourist SOS & Police
                  _build3DAssistantCard(
                    title: AppStrings.tr('tourist_sos', lang),
                    urduTitle: 'ٹورسٹ پولیس و مدد',
                    subtitle: 'Direct Call 1421 & 1122',
                    badge: '🚨 24/7 SOS',
                    icon: Icons.shield_rounded,
                    colors: [const Color(0xFF7F1D1D), const Color(0xFFB91C1C)],
                    onTap: () => _showEmergencyModal(context),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // ── 🇵🇰 PAKISTAN-FIRST POWER FEATURES ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.tr('pakistan_tools', lang),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('🇵🇰 No Other App Has This', style: TextStyle(color: Color(0xFFDC2626), fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _build3DAssistantCard(
                    title: AppStrings.tr('budget_calculator', lang),
                    urduTitle: 'بجٹ کیلکولیٹر',
                    subtitle: 'روپے ڈالیں، پلان بنائیں',
                    badge: '💰 Rs. Plan',
                    icon: Icons.calculate_rounded,
                    colors: [const Color(0xFF065F46), const Color(0xFF059669)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BudgetCalculatorScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _build3DAssistantCard(
                    title: AppStrings.tr('group_splitter', lang),
                    urduTitle: 'گروپ بل تقسیم',
                    subtitle: 'دوستوں کا حساب کتاب',
                    badge: '👥 Friends',
                    icon: Icons.group_rounded,
                    colors: [const Color(0xFF1E3A5F), const Color(0xFF2563EB)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const GroupBillSplitterScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _build3DAssistantCard(
                    title: AppStrings.tr('anti_scam', lang),
                    urduTitle: 'اصلی بمقابلہ سیاحتی ریٹ',
                    subtitle: 'لوٹ مار سے بچاؤ',
                    badge: '⚠️ Fair Rate',
                    icon: Icons.price_check_rounded,
                    colors: [const Color(0xFF7F1D1D), const Color(0xFFDC2626)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LocalVsTouristPriceScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _build3DAssistantCard(
                    title: AppStrings.tr('offline_packs', lang),
                    urduTitle: 'بغیر نیٹ سٹی پیک',
                    subtitle: '30MB میں پورا شہر',
                    badge: '📥 Offline',
                    icon: Icons.cloud_download_rounded,
                    colors: [const Color(0xFF4C1D95), const Color(0xFF7C3AED)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OfflineCityPacksScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _build3DAssistantCard(
                    title: 'Offline Pay Hub',
                    urduTitle: 'بغیر نیٹ ادائیگیاں',
                    subtitle: '*786# & *2262# گائیڈ',
                    badge: '📶 USSD & OTC',
                    icon: Icons.account_balance_wallet_rounded,
                    colors: [const Color(0xFF006644), const Color(0xFF004D33)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OfflinePaymentGuideScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _build3DAssistantCard(
                    title: 'Road & Landslide',
                    urduTitle: 'سڑک و لینڈ سلائیڈ الرٹس',
                    subtitle: 'لائیو بابوسر و KKH چوک پوائنٹس',
                    badge: '🚧 Live Waze',
                    icon: Icons.warning_amber_rounded,
                    colors: [const Color(0xFF991B1B), const Color(0xFFE65F2B)],
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RoadInfrastructureAlertsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),


        // ── 💡 LAYMAN VISUAL TRUST GUIDE: "یہ ایپ آپ کی کیسے مدد کرے گی؟" ────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cardBorderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.help_outline, color: Color(0xFF059669), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'یہ ایپ آپ کی کیسے مدد کرے گی؟',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryTextColor),
                          ),
                          Text(
                            'Simple visual guide for tourists and laymen',
                            style: TextStyle(fontSize: 11, color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: cardBorderColor),
                const SizedBox(height: 10),
                _buildLaymanFeature(
                  icon: Icons.shield_outlined,
                  color: const Color(0xFFEC4899),
                  urdu: 'خواتین اور فیملی سیفٹی آڈٹ:',
                  eng: 'ہر اسپاٹ پر صاف فیملی واش روم، محفوظ ماحول اور لیڈی ٹریولر تصدیق',
                ),
                const SizedBox(height: 8),
                _buildLaymanFeature(
                  icon: Icons.price_check,
                  color: const Color(0xFFD97706),
                  urdu: 'آج کا ریٹ (Anti-Scam Rate):',
                  eng: 'مری و فورٹس پر زائد پیسے طلب کرنے سے بچاؤ — روزانہ کا تصدیق شدہ ریٹ',
                ),
                const SizedBox(height: 8),
                _buildLaymanFeature(
                  icon: Icons.wifi_off_outlined,
                  color: const Color(0xFF2563EB),
                  urdu: 'آف لائن روڈ اسٹیٹس اور لینڈ سلائیڈ:',
                  eng: 'پہاڑوں اور صحرا میں سگنل بند ہونے پر بھی لوکلز کی لائیو روڈ بلاک الرٹس',
                ),
                const SizedBox(height: 8),
                _buildLaymanFeature(
                  icon: Icons.calendar_month_outlined,
                  color: const Color(0xFF7C3AED),
                  urdu: 'پنجاب کلچرل و عرس کیلنڈر:',
                  eng: 'درباروں، میلوں اور فیسٹیولز کے رش کی پیشگی معلومات اور ہوٹل الرٹ',
                ),
                const SizedBox(height: 8),
                _buildLaymanFeature(
                  icon: Icons.airport_shuttle_outlined,
                  color: const Color(0xFF059669),
                  urdu: 'عوامی وین و چنگچی روٹس:',
                  eng: 'لاہور سے کٹاس راج یا روہتاس فورٹ تک کم خرچ لوکل ویگن کنکشن',
                ),
                const SizedBox(height: 8),
                _buildLaymanFeature(
                  icon: Icons.eco_outlined,
                  color: const Color(0xFF10B981),
                  urdu: 'گرین ٹورسٹ اسکور و ڈسکاؤنٹ:',
                  eng: 'کوڑے دان کے استعمال پر گرین کوائنز حاصل کریں اور اگلی ٹرپ پر انعام پائیں',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── 🌟 EXPLORE BY PUNJAB CITIES (81 CITIES SELECTOR) ────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Where do you want to go?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                    ),
                    Text(
                      'Choose a city to explore its food, hospitals & sights',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: secondaryTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CityExplorerScreen()),
                  );
                },
                child: const Text('All 81 Cities →', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF059669))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Horizontal Cities Cards
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: 8, // Show top 8 famous cities on home
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final city = Punjab81CitiesData.allCities[i];
              return _CityQuickCard(city: city);
            },
          ),
        ),

        const SizedBox(height: 24),

        // ── Categories Section (Clean Rounded Pill Design) ──────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Explore Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchResultsScreen()),
                  );
                },
                child: const Text('See all'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 96,
          child: categoriesAsync.when(
            data: (categories) => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final cat = categories[i];
                return _CleanCategoryCard(
                  cat: cat,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SearchResultsScreen(
                          initialCategoryId: cat.id,
                          initialCategoryName: cat.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(
              child: Text('Could not load categories', style: TextStyle(fontSize: 12, color: secondaryTextColor)),
            ),
          ),
        ),

        const SizedBox(height: 26),

        // ── Must-Visit Punjab Destinations (Photos & Ratings) ───────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Must-Visit Destinations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                    ),
                    Text(
                      'Top-rated iconic places across Punjab & Islamabad',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: secondaryTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchResultsScreen()),
                  );
                },
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: popularPlacesAsync.when(
            data: (places) {
              if (places.isEmpty) {
                return const Center(child: Text('No destinations available'));
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: places.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, i) => _DestinationCard(place: places[i]),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('Could not load places: $e', style: const TextStyle(fontSize: 12)),
            ),
          ),
        ),

        const SizedBox(height: 26),

        // ── Events & Festivals Section ──────────────────────────────────────
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _EventsSection(),
        ),
      ],
    );
  }

  Widget _buildHelplineChip(String label, String number, Color color) {
    return InkWell(
      onTap: () => _makeCall(number),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Icon(Icons.call, size: 11, color: color),
          ],
        ),
      ),
    );
  }

  Widget _build3DAssistantCard({
    required String title,
    required String urduTitle,
    required String subtitle,
    required String badge,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                urduTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 9,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaymanFeature({
    required IconData icon,
    required Color color,
    required String urdu,
    required String eng,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                urdu,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
              Text(
                eng,
                style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEmergencyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.shield, color: Color(0xFFDC2626), size: 28),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tourist 24/7 Emergency Helplines',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'سیاحوں کے لیے مفت ہنگامی حکومتی سہولیات',
                        style: TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 1. Rescue 1122
            _emergencyDialTile(
              title: 'Rescue 1122 (Ambulance & Fire)',
              urdu: 'ریسکیو 1122 ایمبولینس و طبی امداد (مفت)',
              number: '1122',
              color: const Color(0xFFDC2626),
              icon: Icons.medical_services_rounded,
            ),

            // 2. Tourist Police Helpline 1421 & 15
            _emergencyDialTile(
              title: 'Tourist Police (Punjab Helpline)',
              urdu: 'ٹورسٹ پولیس 1421 و پنجاب پولیس 15',
              number: '1421',
              color: const Color(0xFF2563EB),
              icon: Icons.local_police_rounded,
            ),

            // 3. Motorway Police 130
            _emergencyDialTile(
              title: 'Motorway Police Helpline (130)',
              urdu: 'موٹروے ایمرجنسی و ہائی وے پٹرول 130',
              number: '130',
              color: const Color(0xFFD97706),
              icon: Icons.car_crash_rounded,
            ),

            // 4. Citizen Complaints Portal 1787
            _emergencyDialTile(
              title: 'Tourist Grievance Portal (1787)',
              urdu: 'سیاحتی شکایات، زائد کرایہ و ہوٹل فراڈ رپورٹ',
              number: '1787',
              color: const Color(0xFF7C3AED),
              icon: Icons.gavel_rounded,
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close (بند کریں)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emergencyDialTile({
    required String title,
    required String urdu,
    required String number,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text(urdu, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _makeCall(number),
            icon: const Icon(Icons.call, size: 14),
            label: Text('Call $number', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── City Quick Card (On Home Screen) ─────────────────────────────────────────

class _CityQuickCard extends StatelessWidget {
  final PunjabCity city;
  const _CityQuickCard({required this.city});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => CityGuideScreen(city: city)),
        );
      },
      child: Container(
        width: 145,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              city.coverImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.blueGrey),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  city.urduName,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    city.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ── Clean Category Card ──────────────────────────────────────────────────────

class _CleanCategoryCard extends StatelessWidget {
  final CategoryModel cat;
  final VoidCallback onTap;

  const _CleanCategoryCard({
    required this.cat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(iconForCategory(cat.icon), color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A), size: 26),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              cat.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11, color: isDark ? Colors.white : const Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Destination Card with Image, Rating, Price ──────────────────────────────

class _DestinationCard extends StatelessWidget {
  final PlaceModel place;
  const _DestinationCard({required this.place});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PlaceDetailsScreen(placeId: place.id)),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 125,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (place.images.isNotEmpty)
                    Image.network(
                      place.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallbackImage(),
                    )
                  else
                    _fallbackImage(),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text(
                            place.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 11, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          place.address.isNotEmpty ? place.address : place.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF10B981).withValues(alpha: 0.15) : const Color(0xFF0F172A).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      place.priceRange.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 36, color: Colors.grey),
      ),
    );
  }
}

// ── Events Section ──────────────────────────────────────────────────────────

class _EventsSection extends ConsumerWidget {
  const _EventsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderColor = isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.06);
    final itemBgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.event, color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Upcoming Festivals & Tours',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EventsListScreen()),
                  );
                },
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          eventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return Text(
                  'No upcoming events right now.',
                  style: TextStyle(color: secondaryTextColor, fontSize: 13),
                );
              }
              return Column(
                children: events.take(3).map((event) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: itemBgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: event.id)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 48,
                                height: 48,
                                color: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A).withValues(alpha: 0.08),
                                child: Icon(Icons.festival, color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A), size: 24),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.name,
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryTextColor),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${event.date.day}/${event.date.month}/${event.date.year} · ${event.address}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 11, color: secondaryTextColor),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 14, color: secondaryTextColor),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const Text(
              'Could not load events.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Tab ─────────────────────────────────────────────────────────────

class _ProfileTabPlaceholder extends ConsumerWidget {
  const _ProfileTabPlaceholder();

  Future<void> _makeCall(String number) async {
    final uri = Uri.parse('tel:$number');
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _showSafetyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shield, color: Color(0xFFDC2626), size: 28),
                SizedBox(width: 10),
                Text('Tourist Safety & 24/7 Helplines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Toll-free emergency numbers active across all Punjab cities and tourist routes:',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 16),
            _sosItem('Rescue 1122 Ambulance', '1122', Icons.medical_services, Colors.red, () => _makeCall('1122')),
            _sosItem('Tourist Police Helpline', '15', Icons.local_police, Colors.blue, () => _makeCall('15')),
            _sosItem('Tourism Department Punjab', '1787', Icons.support_agent, Colors.teal, () => _makeCall('1787')),
            _sosItem('Motorway & Highway Police', '130', Icons.traffic, Colors.indigo, () => _makeCall('130')),
          ],
        ),
      ),
    );
  }

  static Widget _sosItem(String title, String num, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('Dial $num', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: onTap,
            child: const Text('Call', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final isAdmin = user?.role == 'admin';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderColor = isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.06);
    final currentThemeMode = ref.watch(themeModeProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ── Profile Header Card ──
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cardBorderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: isDark ? Colors.white12 : const Color(0xFF0F172A).withValues(alpha: 0.08),
                child: Icon(
                  isAdmin ? Icons.admin_panel_settings : Icons.person,
                  size: 44,
                  color: isDark ? const Color(0xFF10B981) : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user?.name ?? 'Tourist Guest',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'tourist@smartmap.ai',
                style: TextStyle(color: secondaryTextColor, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: isAdmin ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isAdmin ? Colors.red.shade300 : const Color(0xFF10B981)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAdmin ? Icons.security : Icons.luggage,
                      size: 14,
                      color: isAdmin ? Colors.red.shade700 : const Color(0xFF059669),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAdmin ? 'Punjab Tourism Administrator' : 'Verified Tourist Traveler',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isAdmin ? Colors.red.shade700 : const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── 🎨 Theme Mode Setting ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardBorderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: const Color(0xFF10B981), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'App Appearance / ڈارک موڈ سیٹنگز',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _themeOptionChip(
                      label: '☀️ Light',
                      urdu: 'روشن موڈ',
                      isSelected: currentThemeMode == ThemeMode.light,
                      onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _themeOptionChip(
                      label: '🌙 Dark',
                      urdu: 'ڈارک موڈ',
                      isSelected: currentThemeMode == ThemeMode.dark,
                      onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _themeOptionChip(
                      label: '📱 System',
                      urdu: 'فون سسٹم',
                      isSelected: currentThemeMode == ThemeMode.system,
                      onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Tourist Dashboard Section ──
        Text(
          '🎒 Traveler Dashboard',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: primaryTextColor),
        ),
        const SizedBox(height: 10),

        _dashboardTile(
          context: context,
          icon: Icons.alt_route,
          color: const Color(0xFF3B82F6),
          title: 'My Custom Trip Plans',
          subtitle: 'View saved itineraries, multi-city tours & routes',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyTripsScreen()));
          },
        ),

        _dashboardTile(
          context: context,
          icon: Icons.bookmark_outline,
          color: const Color(0xFFF59E0B),
          title: 'Saved Places & Bookmarks',
          subtitle: 'Quick access to your favorite historical sites & food',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedPlacesScreen()));
          },
        ),

        _dashboardTile(
          context: context,
          icon: Icons.shield_outlined,
          color: const Color(0xFFDC2626),
          title: 'Tourist Safety & Emergency SOS',
          subtitle: '24/7 Police 15, Rescue 1122 & Highway helpline 130',
          onTap: () => _showSafetyModal(context),
        ),

        _dashboardTile(
          context: context,
          icon: Icons.gavel_outlined,
          color: const Color(0xFF8B5CF6),
          title: 'Citizen Portal (Complaints & Feedback)',
          subtitle: 'Report overcharging, hotel issues, or roadside complaints',
          onTap: () => _openUrl('https://citizenportal.gov.pk'),
        ),

        _dashboardTile(
          context: context,
          icon: Icons.storefront_outlined,
          color: const Color(0xFF059669),
          title: 'Register a Tourist Business',
          subtitle: 'List your hotel, bakery, restaurant or transport service',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BusinessRegistrationScreen()));
          },
        ),

        const SizedBox(height: 20),

        // ── Admin Panel Section (Only visible or emphasized for Admins) ──
        if (isAdmin) ...[
          const Text(
            '🛡️ Tourism Official Admin Console',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF991B1B)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Specialized administrative tools for Punjab Tourism Department officers to moderate listings, approve businesses, and manage verified spots.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, color: Colors.white, size: 30),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Open Administrator Dashboard',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Verify places, approve business registrations & moderate reviews',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // ── Role Distinction Explanation Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Color(0xFF0F172A)),
                  SizedBox(width: 8),
                  Text('Tourist (User) vs Admin Distinction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '• Tourist (You): Discovers 81 Punjab cities, searches hospitals, orders cakes, plans trips, reviews places, and uses emergency helplines.\n• Administrator: Tourism Department authority responsible for verifying new listings, checking business licenses, and issuing tourist alerts.',
                style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Log Out Button ──
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).logout();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _themeOptionChip({
    required String label,
    required String urdu,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF059669)
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF059669)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              urdu,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.85)
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.06)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? const Color(0xFF94A3B8) : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 13, color: isDark ? Colors.white38 : Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
