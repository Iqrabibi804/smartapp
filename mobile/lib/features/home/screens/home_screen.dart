import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/punjab_81_cities_data.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/offline/offline_status_banner.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_logo.dart';
import '../../auth/services/auth_providers.dart';
import '../../auth/screens/login_screen.dart';
import '../../map/screens/map_screen.dart';
import '../../search/screens/search_results_screen.dart';
import '../../favorites/screens/saved_places_screen.dart';
import '../../ai/screens/map_ai_screen.dart';
import '../../trips/screens/trip_planner_screen.dart';
import '../../trips/screens/my_trips_screen.dart';
import '../../events/services/events_service.dart';
import '../../events/screens/events_list_screen.dart';
import '../../events/screens/event_details_screen.dart';
import '../../business/screens/business_registration_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../places/screens/city_guide_screen.dart';
import '../../places/screens/city_explorer_screen.dart';
import '../../trips/screens/budget_calculator_screen.dart';
import '../../trips/screens/group_bill_splitter_screen.dart';
import '../../places/screens/local_vs_tourist_price_screen.dart';
import '../../places/screens/offline_city_packs_screen.dart';
import '../../places/screens/offline_payment_guide_screen.dart';
import '../../places/screens/road_infrastructure_alerts_screen.dart';
import '../../places/screens/facility_finder_screen.dart';
import '../../places/screens/culture_companion_screen.dart';
import '../../places/screens/permits_screen.dart';
import '../../places/screens/foreigner_toolkit_screen.dart';
import '../../places/screens/digital_tourist_pass_screen.dart';
import '../../places/screens/complaints_screen.dart';
import '../../trips/screens/journey_readiness_screen.dart';

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
      backgroundColor: isDark ? AppTokens.scaffoldDark : AppTokens.dashboardBg,
      body: SafeArea(child: _bodyForTab(_tabIndex)),
      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MapAiScreen()),
                );
              },
              backgroundColor: AppTokens.emerald,
              foregroundColor: Colors.white,
              elevation: 4,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 16),
              extendedIconLabelSpacing: 6,
              icon: const Icon(Icons.auto_awesome,
                  size: 17, color: AppTokens.gold),
              label: Text(
                AppStrings.tr('ai_guide', lang),
                style: const TextStyle(
                  fontFamily: AppTokens.fontBody,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon:
                const Icon(Icons.home, color: AppTokens.pakistanGreen),
            label: AppStrings.tr('tab_home', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map, color: AppTokens.pakistanGreen),
            label: AppStrings.tr('tab_map', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_city_outlined),
            selectedIcon:
                const Icon(Icons.location_city, color: AppTokens.pakistanGreen),
            label: AppStrings.tr('tab_cities', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_border),
            selectedIcon:
                const Icon(Icons.bookmark, color: AppTokens.pakistanGreen),
            label: AppStrings.tr('tab_saved', lang),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon:
                const Icon(Icons.person, color: AppTokens.pakistanGreen),
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

  static const List<
      ({
        String asset,
        String tag,
        String title,
        String subtitle,
        String cityId,
        String urdu
      })> _heroSlides = [
    (
      asset: 'assets/images/landmarks/taxila_dharmarajika.jpg',
      tag: 'UNESCO HERITAGE',
      title: 'Taxila: Gandhara UNESCO Site',
      subtitle: 'Dharmarajika Stupa, Sirkap & ancient Buddhist relics',
      cityId: 'taxila',
      urdu: 'ٹیکسلا',
    ),
    (
      asset: 'assets/images/landmarks/badshahi_mosque.jpg',
      tag: 'ROYAL HERITAGE',
      title: 'Lahore: Royal Heritage',
      subtitle: 'Badshahi Mosque, Lahore Fort & Walled City lanes',
      cityId: 'lahore',
      urdu: 'لاہور',
    ),
  ];

  static const List<({String id, String asset, String caption})>
      _popularCities = [
    (
      id: 'lahore',
      asset: 'assets/images/landmarks/lahore_fort.jpg',
      caption: 'Lahore Fort'
    ),
    (
      id: 'multan',
      asset: 'assets/images/landmarks/multan_shrine.jpg',
      caption: 'Shah Rukn-e-Alam'
    ),
    (
      id: 'rawalpindi',
      asset: 'assets/images/landmarks/rawalpindi_bazaar.jpg',
      caption: 'Raja Bazaar'
    ),
    (
      id: 'bahawalpur',
      asset: 'assets/images/landmarks/noor_mahal.jpg',
      caption: 'Noor Mahal'
    ),
  ];

  static const List<
      ({
        String asset,
        String title,
        String city,
        String cityId,
        String label,
        String tag
      })> _landmarks = [
    (
      asset: 'assets/images/landmarks/badshahi_mosque.jpg',
      title: 'Badshahi Mosque',
      city: 'Lahore',
      cityId: 'lahore',
      label: 'Mughal mosque, 1673',
      tag: 'HERITAGE',
    ),
    (
      asset: 'assets/images/landmarks/derawar_fort.jpg',
      title: 'Derawar Fort',
      city: 'Bahawalpur',
      cityId: 'bahawalpur',
      label: 'Cholistan desert fort',
      tag: 'DESERT',
    ),
    (
      asset: 'assets/images/landmarks/shalimar_gardens.jpg',
      title: 'Shalimar Gardens',
      city: 'Lahore',
      cityId: 'lahore',
      label: 'UNESCO Mughal garden',
      tag: 'UNESCO',
    ),
    (
      asset: 'assets/images/landmarks/taxila_dharmarajika.jpg',
      title: 'Dharmarajika Stupa',
      city: 'Taxila',
      cityId: 'taxila',
      label: 'UNESCO Gandhara site',
      tag: 'UNESCO',
    ),
    (
      asset: 'assets/images/landmarks/murree.jpg',
      title: 'Murree Hills',
      city: 'Murree',
      cityId: 'murree',
      label: 'Hill station, 2,291 m',
      tag: 'HILLS',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerController.hasClients) {
        final page = _bannerController.page?.round() ?? 0;
        final next = (page + 1) % _heroSlides.length;
        _bannerController.animateToPage(
          next,
          duration: const Duration(milliseconds: 650),
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

  PunjabCity? _cityById(String id) {
    for (final city in Punjab81CitiesData.allCities) {
      if (city.id.toLowerCase() == id.toLowerCase()) return city;
    }
    return null;
  }

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void _openCity(String id) {
    final city = _cityById(id);
    if (city != null) _push(CityGuideScreen(city: city));
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = isDark ? AppTokens.scaffoldDark : AppTokens.dashboardBg;
    final ink = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1F2937);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final surface = isDark ? AppTokens.surfaceDark : Colors.white;
    final border = isDark ? AppTokens.borderDark : AppTokens.cardBorderWarm;

    return ColoredBox(
      color: background,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          const OfflineStatusBanner(),
          _buildHeader(lang, isDark, ink, muted, surface, border),
          const SizedBox(height: 6),
          _buildSearch(lang, isDark, muted, surface, border),
          const SizedBox(height: 18),
          _buildCategories(isDark, ink),
          const SizedBox(height: 20),
          _buildHero(isDark),
          const SizedBox(height: 8),
          Center(
            child: SmoothPageIndicator(
              controller: _bannerController,
              count: _heroSlides.length,
              effect: ExpandingDotsEffect(
                dotHeight: 5,
                dotWidth: 6,
                activeDotColor: AppTokens.gold,
                dotColor:
                    isDark ? AppTokens.borderDark : AppTokens.cardBorderWarm,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildTravelerEssentials(lang, isDark, ink, muted, surface, border),
          const SizedBox(height: 26),
          _buildPopularCities(ink, muted),
          const SizedBox(height: 26),
          _buildMustVisit(ink, muted),
          const SizedBox(height: 26),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: _EventsSection(),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 13, color: muted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Independent guide · Not affiliated with any government body.',
                    style: TextStyle(fontSize: 10.5, color: muted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(
    AppLanguage lang,
    bool isDark,
    Color ink,
    Color muted,
    Color surface,
    Color border,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
      child: Row(
        children: [
          const AppLogoMark3D(size: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SmartMap Punjab',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTokens.fontHeading,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: isDark ? Colors.white : AppTokens.emerald,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Punjab, Pakistan · Independent guide',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9.5, color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildLanguageToggle(lang, isDark, muted, surface, border),
          const SizedBox(width: 6),
          _buildSosButton(),
        ],
      ),
    );
  }

  Widget _buildLanguageToggle(
    AppLanguage lang,
    bool isDark,
    Color muted,
    Color surface,
    Color border,
  ) {
    final isUrdu = lang == AppLanguage.urdu;
    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _languageOption(
              'EN',
              !isUrdu,
              isDark,
              muted,
              () => ref
                  .read(languageProvider.notifier)
                  .setLanguage(AppLanguage.english)),
          _languageOption(
              'اردو',
              isUrdu,
              isDark,
              muted,
              () => ref
                  .read(languageProvider.notifier)
                  .setLanguage(AppLanguage.urdu)),
        ],
      ),
    );
  }

  Widget _languageOption(
    String label,
    bool selected,
    bool isDark,
    Color muted,
    VoidCallback onTap,
  ) {
    final isUrduLabel = label == 'اردو';
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        decoration: BoxDecoration(
          color: selected ? AppTokens.emerald : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: isUrduLabel ? AppTokens.fontUrdu : AppTokens.fontBody,
            fontSize: isUrduLabel ? 12 : 10.5,
            height: isUrduLabel ? 1.7 : 1.2,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : muted,
          ),
        ),
      ),
    );
  }

  Widget _buildSosButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () => _showEmergencyModal(context),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppTokens.alertRed,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: AppTokens.alertRed.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emergency_rounded, size: 14, color: Colors.white),
              SizedBox(width: 4),
              Text(
                'SOS',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Search ────────────────────────────────────────────────────────────────

  Widget _buildSearch(
    AppLanguage lang,
    bool isDark,
    Color muted,
    Color surface,
    Color border,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(26),
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: () => _push(const SearchResultsScreen()),
          child: Container(
            height: 52,
            padding: const EdgeInsets.only(left: 8, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppTokens.pastelMint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search_rounded,
                      size: 19, color: AppTokens.emerald),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search Lahore, Taxila, food, hotels...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: muted),
                  ),
                ),
                Icon(Icons.tune_rounded, size: 17, color: muted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Categories ────────────────────────────────────────────────────────────

  Widget _buildCategories(bool isDark, Color ink) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _QuickCategory(
              label: 'Cities',
              icon: Icons.location_city_rounded,
              background: AppTokens.pastelMint,
              foreground: AppTokens.emerald,
              labelColor: ink,
              onTap: () => _push(const CityExplorerScreen()),
            ),
          ),
          Expanded(
            child: _QuickCategory(
              label: 'Heritage',
              icon: Icons.account_balance_rounded,
              background: AppTokens.pastelGold,
              foreground: const Color(0xFFA16207),
              labelColor: ink,
              onTap: () => _push(
                const SearchResultsScreen(
                    initialCategoryName: 'Historical & Religious'),
              ),
            ),
          ),
          Expanded(
            child: _QuickCategory(
              label: 'Food',
              icon: Icons.restaurant_rounded,
              background: AppTokens.pastelRose,
              foreground: const Color(0xFFC2410C),
              labelColor: ink,
              onTap: () => _push(
                const SearchResultsScreen(initialCategoryName: 'Restaurants'),
              ),
            ),
          ),
          Expanded(
            child: _QuickCategory(
              label: 'Stays',
              icon: Icons.hotel_rounded,
              background: AppTokens.pastelBlue,
              foreground: AppTokens.multaniBlue,
              labelColor: ink,
              onTap: () => _push(
                const SearchResultsScreen(initialCategoryName: 'Hotels'),
              ),
            ),
          ),
          Expanded(
            child: _QuickCategory(
              label: 'Medical',
              icon: Icons.local_hospital_rounded,
              background: AppTokens.pastelLilac,
              foreground: const Color(0xFF6D28D9),
              labelColor: ink,
              onTap: () => _push(
                FacilityFinderScreen(initialType: kFacilityTypes.first),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────

  Widget _buildHero(bool isDark) {
    return SizedBox(
      height: 198,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: _heroSlides.length,
        itemBuilder: (context, i) {
          final slide = _heroSlides[i];
          return GestureDetector(
            onTap: () => _openCity(slide.cityId),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    slide.asset,
                    fit: BoxFit.cover,
                    cacheWidth: 1100,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: AppTokens.emeraldDeep,
                      child: Center(
                        child: Icon(Icons.landscape_rounded,
                            color: Colors.white38, size: 40),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x22000000),
                          Color(0x55000000),
                          Color(0xE6062618),
                        ],
                        stops: [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    right: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTokens.gold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            slide.tag,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            slide.urdu,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontFamily: AppTokens.fontUrdu,
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slide.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: AppTokens.fontHeading,
                                  color: Colors.white,
                                  fontSize: 19,
                                  height: 1.15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                slide.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.78),
                                  fontSize: 10.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTokens.gold,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Explore',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white, size: 13),
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
    );
  }

  // ── Traveler Essentials ───────────────────────────────────────────────────

  Widget _buildTravelerEssentials(
    AppLanguage lang,
    bool isDark,
    Color ink,
    Color muted,
    Color surface,
    Color border,
  ) {
    final showUrdu = lang == AppLanguage.urdu;
    final tools = <({
      String title,
      String subtitle,
      String urdu,
      IconData icon,
      Color accent,
      Color accentBg,
      VoidCallback onTap
    })>[
      (
        title: 'Route Planner',
        subtitle: 'Plan a route with fuel stops',
        urdu: 'روٹ اور ایندھن کی منصوبہ بندی',
        icon: Icons.alt_route_rounded,
        accent: AppTokens.emerald,
        accentBg: AppTokens.pastelMint,
        onTap: () => _push(const TripPlannerScreen()),
      ),
      (
        title: 'Anti-Scam Rates',
        subtitle: 'Know fair prices before you bargain',
        urdu: 'منصفانہ ریٹ کی رہنمائی',
        icon: Icons.price_check_rounded,
        accent: AppTokens.gold,
        accentBg: AppTokens.pastelGold,
        onTap: () => _push(const LocalVsTouristPriceScreen()),
      ),
      (
        title: 'Offline City Packs',
        subtitle: 'City guides without a signal',
        urdu: 'بغیر نیٹ شہر کی گائیڈ',
        icon: Icons.cloud_download_rounded,
        accent: AppTokens.multaniBlue,
        accentBg: AppTokens.pastelBlue,
        onTap: () => _push(const OfflineCityPacksScreen()),
      ),
      (
        title: 'Budget Calculator',
        subtitle: 'Estimate your trip in rupees',
        urdu: 'روپوں میں سفر کا بجٹ',
        icon: Icons.calculate_rounded,
        accent: AppTokens.emerald,
        accentBg: AppTokens.pastelMint,
        onTap: () => _push(const BudgetCalculatorScreen()),
      ),
      (
        title: 'Bill Splitter',
        subtitle: 'Split group expenses fairly',
        urdu: 'گروپ کا بل برابر تقسیم کریں',
        icon: Icons.groups_rounded,
        accent: const Color(0xFFB45309),
        accentBg: AppTokens.pastelGold,
        onTap: () => _push(const GroupBillSplitterScreen()),
      ),
      (
        title: 'Road & Landslide Alerts',
        subtitle: 'Advisories to verify before travel',
        urdu: 'سڑک اور لینڈ سلائیڈ معلومات',
        icon: Icons.warning_amber_rounded,
        accent: AppTokens.alertRed,
        accentBg: AppTokens.pastelRose,
        onTap: () => _push(const RoadInfrastructureAlertsScreen()),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Traveler Essentials',
            subtitle: 'Six everyday tools for a smoother Punjab trip',
            actionLabel: 'More tools',
            actionColor: AppTokens.emerald,
            onAction: () => _showMoreTools(),
            ink: ink,
            muted: muted,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tools.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: showUrdu ? 164 : 142,
            ),
            itemBuilder: (context, i) {
              final tool = tools[i];
              return _ToolCard(
                title: tool.title,
                subtitle: tool.subtitle,
                urduSubtitle: tool.urdu,
                icon: tool.icon,
                accent: tool.accent,
                accentBg: tool.accentBg,
                showUrdu: showUrdu,
                isDark: isDark,
                surface: surface,
                border: border,
                ink: ink,
                muted: muted,
                onTap: tool.onTap,
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Popular Cities ────────────────────────────────────────────────────────

  Widget _buildPopularCities(Color ink, Color muted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _SectionHeader(
            title: 'Popular Cities',
            subtitle: 'Real places, photographed on location',
            actionLabel: 'All 81 cities',
            actionColor: AppTokens.emerald,
            onAction: () => _push(const CityExplorerScreen()),
            ink: ink,
            muted: muted,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 164,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            scrollDirection: Axis.horizontal,
            itemCount: _popularCities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final entry = _popularCities[i];
              final city = _cityById(entry.id);
              if (city == null) return const SizedBox.shrink();
              return _CityPhotoCard(
                city: city,
                asset: entry.asset,
                caption: entry.caption,
                onTap: () => _openCity(entry.id),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Must-Visit Destinations ───────────────────────────────────────────────

  Widget _buildMustVisit(Color ink, Color muted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _SectionHeader(
            title: 'Must-Visit Destinations',
            subtitle: 'Photographs from Wikimedia Commons contributors',
            actionLabel: 'View all',
            actionColor: AppTokens.emerald,
            onAction: () => _push(const SearchResultsScreen()),
            ink: ink,
            muted: muted,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 216,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            scrollDirection: Axis.horizontal,
            itemCount: _landmarks.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final landmark = _landmarks[i];
              return _LandmarkCard(
                asset: landmark.asset,
                title: landmark.title,
                city: landmark.city,
                label: landmark.label,
                tag: landmark.tag,
                onTap: () => _openCity(landmark.cityId),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── More tools sheet ──────────────────────────────────────────────────────

  void _showMoreTools() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppTokens.surfaceDark : Colors.white;
    final ink = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1F2937);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final items = <({
          IconData icon,
          Color color,
          String title,
          String subtitle,
          VoidCallback onTap
        })>[
          (
            icon: Icons.local_hospital_rounded,
            color: AppTokens.emerald,
            title: 'Hospitals & clinics',
            subtitle: 'Find medical facilities by type',
            onTap: () => _pushFromSheet(
                ctx, FacilityFinderScreen(initialType: kFacilityTypes.first)),
          ),
          (
            icon: Icons.cake_rounded,
            color: const Color(0xFFC2410C),
            title: 'Bakeries & cakes',
            subtitle: 'Fresh bakes from listed shops',
            onTap: () => _pushFromSheet(
                  ctx,
                  const SearchResultsScreen(
                      initialCategoryName: 'Bakeries & Cakes'),
                ),
          ),
          (
            icon: Icons.account_balance_wallet_rounded,
            color: AppTokens.multaniBlue,
            title: 'Offline payment guide',
            subtitle: 'USSD and over-the-counter options',
            onTap: () => _pushFromSheet(ctx, const OfflinePaymentGuideScreen()),
          ),
          (
            icon: Icons.checklist_rtl_rounded,
            color: const Color(0xFF0F766E),
            title: 'Journey readiness',
            subtitle: 'A checklist before you leave',
            onTap: () => _pushFromSheet(ctx, const JourneyReadinessScreen()),
          ),
          (
            icon: Icons.diversity_3_rounded,
            color: AppTokens.gold,
            title: 'Local culture',
            subtitle: 'Etiquette and useful phrases',
            onTap: () => _pushFromSheet(ctx, const CultureCompanionScreen()),
          ),
          (
            icon: Icons.assignment_rounded,
            color: const Color(0xFF1E3A8A),
            title: 'Permits & NOC',
            subtitle: 'Guidance only — no online submission',
            onTap: () => _pushFromSheet(ctx, const PermitsScreen()),
          ),
          (
            icon: Icons.public_rounded,
            color: const Color(0xFF134E4A),
            title: 'Foreign visitor toolkit',
            subtitle: 'PTA, currency and embassies',
            onTap: () => _pushFromSheet(ctx, const ForeignerToolkitScreen()),
          ),
          (
            icon: Icons.badge_rounded,
            color: AppTokens.emeraldDeep,
            title: 'Digital tourist pass',
            subtitle: 'On-device ID — not a government pass',
            onTap: () => _pushFromSheet(ctx, const DigitalTouristPassScreen()),
          ),
          (
            icon: Icons.report_problem_rounded,
            color: AppTokens.alertRed,
            title: 'Report an issue',
            subtitle: 'Saved on device — not submitted',
            onTap: () => _pushFromSheet(ctx, const ComplaintsScreen()),
          ),
        ];

        return Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          ),
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(ctx).padding.bottom + 12,
          ),
          child: SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(ctx).size.height * 0.72),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 4),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTokens.borderDark
                            : AppTokens.cardBorderWarm,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'More traveler tools',
                    style: TextStyle(
                      fontFamily: AppTokens.fontHeading,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Supporting guides, kept out of the main grid.',
                    style: TextStyle(fontSize: 11.5, color: muted),
                  ),
                  const SizedBox(height: 10),
                  for (final item in items)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      leading: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(item.icon, size: 20, color: item.color),
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: ink),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 12, color: muted),
                      onTap: item.onTap,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _pushFromSheet(BuildContext sheetContext, Widget screen) {
    Navigator.of(sheetContext).pop();
    _push(screen);
  }

  // ── Emergency SOS ─────────────────────────────────────────────────────────

  void _showEmergencyModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppTokens.surfaceDark : Colors.white;
    final ink = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1F2937);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: EdgeInsets.fromLTRB(
            20, 10, 20, MediaQuery.of(ctx).padding.bottom + 18),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppTokens.borderDark
                          : AppTokens.cardBorderWarm,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBE8E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.sos_rounded,
                          color: AppTokens.alertRed, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency helplines',
                            style: TextStyle(
                              fontFamily: AppTokens.fontHeading,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: ink,
                            ),
                          ),
                          Text(
                            'Calls open your phone dialer. This app does not dispatch help.',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _emergencyTile(
                  title: 'Rescue 1122',
                  subtitle: 'Ambulance, fire & rescue',
                  number: '1122',
                  color: AppTokens.alertRed,
                  icon: Icons.medical_services_rounded,
                  ink: ink,
                  muted: muted,
                ),
                _emergencyTile(
                  title: 'Police 15',
                  subtitle: 'Police emergency',
                  number: '15',
                  color: AppTokens.multaniBlue,
                  icon: Icons.local_police_rounded,
                  ink: ink,
                  muted: muted,
                ),
                _emergencyTile(
                  title: 'Motorway 130',
                  subtitle: 'Motorway & highway police',
                  number: '130',
                  color: AppTokens.gold,
                  icon: Icons.directions_car_filled_rounded,
                  ink: ink,
                  muted: muted,
                ),
                _emergencyTile(
                  title: 'Tourist Help 1421',
                  subtitle: 'Punjab tourist police helpline',
                  number: '1421',
                  color: AppTokens.emerald,
                  icon: Icons.support_agent_rounded,
                  ink: ink,
                  muted: muted,
                ),
                const SizedBox(height: 4),
                Text(
                  'Numbers are public helplines in Pakistan. Verify locally if a line does not answer.',
                  style: TextStyle(fontSize: 10, color: muted, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emergencyTile({
    required String title,
    required String subtitle,
    required String number,
    required Color color,
    required IconData icon,
    required Color ink,
    required Color muted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: ink),
                ),
                Text(subtitle, style: TextStyle(fontSize: 10.5, color: muted)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _makeCall(number),
            icon: const Icon(Icons.call, size: 13),
            label: Text(
              number,
              style:
                  const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.actionColor,
    required this.onAction,
    required this.ink,
    required this.muted,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback onAction;
  final Color ink;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppTokens.fontHeading,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: ink,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: actionColor),
          ),
        ),
      ],
    );
  }
}

// ── Quick category ──────────────────────────────────────────────────────────

class _QuickCategory extends StatelessWidget {
  const _QuickCategory({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.labelColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration:
                BoxDecoration(color: background, shape: BoxShape.circle),
            child: Icon(icon, size: 24, color: foreground),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 10.5, fontWeight: FontWeight.w600, color: labelColor),
          ),
        ],
      ),
    );
  }
}

// ── Tool card ───────────────────────────────────────────────────────────────

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.title,
    required this.subtitle,
    required this.urduSubtitle,
    required this.icon,
    required this.accent,
    required this.accentBg,
    required this.showUrdu,
    required this.isDark,
    required this.surface,
    required this.border,
    required this.ink,
    required this.muted,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String urduSubtitle;
  final IconData icon;
  final Color accent;
  final Color accentBg;
  final bool showUrdu;
  final bool isDark;
  final Color surface;
  final Color border;
  final Color ink;
  final Color muted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: accentBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 20, color: accent),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_outward_rounded, size: 14, color: muted),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.5, height: 1.25, color: muted),
                ),
                if (showUrdu) ...[
                  const SizedBox(height: 4),
                  Text(
                    urduSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: AppTokens.fontUrdu,
                      fontSize: 10.5,
                      height: 1.4,
                      color: accent,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── City photo card ─────────────────────────────────────────────────────────

class _CityPhotoCard extends StatelessWidget {
  const _CityPhotoCard({
    required this.city,
    required this.asset,
    required this.caption,
    required this.onTap,
  });

  final PunjabCity city;
  final String asset;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 164,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              cacheWidth: 640,
              errorBuilder: (_, __, ___) =>
                  const ColoredBox(color: AppTokens.emeraldDeep),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x11000000),
                    Color(0x33000000),
                    Color(0xDD000000)
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
            Positioned(
              top: 9,
              left: 9,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.22)),
                ),
                child: Text(
                  caption,
                  style: const TextStyle(
                      fontSize: 8.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Positioned(
              left: 11,
              right: 11,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTokens.fontHeading,
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    city.urduName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: AppTokens.fontUrdu,
                      color: Colors.white70,
                      fontSize: 10,
                      height: 1.5,
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

// ── Landmark card ───────────────────────────────────────────────────────────

class _LandmarkCard extends StatelessWidget {
  const _LandmarkCard({
    required this.asset,
    required this.title,
    required this.city,
    required this.label,
    required this.tag,
    required this.onTap,
  });

  final String asset;
  final String title;
  final String city;
  final String label;
  final String tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF1F2937);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 208,
        decoration: BoxDecoration(
          color: isDark ? AppTokens.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark ? AppTokens.borderDark : AppTokens.cardBorderWarm),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 124,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    asset,
                    fit: BoxFit.cover,
                    cacheWidth: 640,
                    errorBuilder: (_, __, ___) =>
                        const ColoredBox(color: AppTokens.emeraldDeep),
                  ),
                  Positioned(
                    top: 9,
                    left: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: tag == 'UNESCO'
                            ? AppTokens.gold
                            : Colors.black.withValues(alpha: 0.48),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTokens.fontHeading,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10.5, color: muted),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 11, color: AppTokens.gold),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: muted),
                        ),
                      ),
                      const Text(
                        'Guide',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTokens.gold,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 11, color: AppTokens.gold),
                    ],
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

// ── Events Section ──────────────────────────────────────────────────────────

class _EventsSection extends ConsumerWidget {
  const _EventsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(upcomingEventsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderColor =
        isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.06);
    final itemBgColor =
        isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

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
                  Icon(Icons.event,
                      color: isDark
                          ? const Color(0xFF10B981)
                          : const Color(0xFF0F172A),
                      size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Upcoming Festivals & Tours',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor),
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
                          MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailsScreen(eventId: event.id)),
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
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFF0F172A)
                                        .withValues(alpha: 0.08),
                                child: Icon(Icons.festival,
                                    color: isDark
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF0F172A),
                                    size: 24),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.name,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${event.date.day}/${event.date.month}/${event.date.year} · ${event.address}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: secondaryTextColor),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 14, color: secondaryTextColor),
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

  void _showSafetyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                Text('Tourist Safety & 24/7 Helplines',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
                'Toll-free emergency numbers active across all Punjab cities and tourist routes:',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 16),
            _sosItem('Rescue 1122 Ambulance', '1122', Icons.medical_services,
                Colors.red, () => _makeCall('1122')),
            _sosItem('Tourist Police Helpline', '15', Icons.local_police,
                Colors.blue, () => _makeCall('15')),
            _sosItem('Tourism Department Punjab', '1787', Icons.support_agent,
                Colors.teal, () => _makeCall('1787')),
            _sosItem('Motorway & Highway Police', '130', Icons.traffic,
                Colors.indigo, () => _makeCall('130')),
          ],
        ),
      ),
    );
  }

  static Widget _sosItem(String title, String num, IconData icon, Color color,
      VoidCallback onTap) {
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
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                Text('Dial $num',
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: onTap,
            child: const Text('Call',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderColor =
        isDark ? const Color(0xFF334155) : Colors.black.withValues(alpha: 0.06);
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
                backgroundColor: isDark
                    ? Colors.white12
                    : const Color(0xFF0F172A).withValues(alpha: 0.08),
                child: Icon(
                  isAdmin ? Icons.admin_panel_settings : Icons.person,
                  size: 44,
                  color: isDark
                      ? const Color(0xFF10B981)
                      : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user?.name ?? 'Tourist Guest',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'tourist@smartmap.ai',
                style: TextStyle(color: secondaryTextColor, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: isAdmin
                      ? const Color(0xFFFEF2F2)
                      : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isAdmin
                          ? Colors.red.shade300
                          : const Color(0xFF10B981)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAdmin ? Icons.security : Icons.luggage,
                      size: 14,
                      color: isAdmin
                          ? Colors.red.shade700
                          : const Color(0xFF059669),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAdmin ? 'App Administrator' : 'Tourist Traveler',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isAdmin
                            ? Colors.red.shade700
                            : const Color(0xFF059669),
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
                  Icon(isDark ? Icons.dark_mode : Icons.light_mode,
                      color: const Color(0xFF10B981), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'App Appearance / ڈارک موڈ سیٹنگز',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor),
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
                      onTap: () => ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.light),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _themeOptionChip(
                      label: '🌙 Dark',
                      urdu: 'ڈارک موڈ',
                      isSelected: currentThemeMode == ThemeMode.dark,
                      onTap: () => ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.dark),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _themeOptionChip(
                      label: '📱 System',
                      urdu: 'فون سسٹم',
                      isSelected: currentThemeMode == ThemeMode.system,
                      onTap: () => ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(ThemeMode.system),
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
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primaryTextColor),
        ),
        const SizedBox(height: 10),

        _dashboardTile(
          context: context,
          icon: Icons.alt_route,
          color: const Color(0xFF3B82F6),
          title: 'My Custom Trip Plans',
          subtitle: 'View saved itineraries, multi-city tours & routes',
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const MyTripsScreen()));
          },
        ),

        _dashboardTile(
          context: context,
          icon: Icons.bookmark_outline,
          color: const Color(0xFFF59E0B),
          title: 'Saved Places & Bookmarks',
          subtitle: 'Quick access to your favorite historical sites & food',
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SavedPlacesScreen()));
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
          title: 'Complaints & Reports',
          subtitle: 'Save a local report or open the Pakistan Citizen Portal',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ComplaintsScreen()),
            );
          },
        ),

        _dashboardTile(
          context: context,
          icon: Icons.storefront_outlined,
          color: const Color(0xFF059669),
          title: 'Register a Tourist Business',
          subtitle: 'List your hotel, bakery, restaurant or transport service',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const BusinessRegistrationScreen()));
          },
        ),

        const SizedBox(height: 20),

        // ── Admin Panel Section (Only visible or emphasized for Admins) ──
        if (isAdmin) ...[
          const Text(
            '🛡️ Tourism Official Admin Console',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF991B1B)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Administrative tools to moderate listings, approve businesses, and manage places.',
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AdminDashboardScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings,
                        color: Colors.white, size: 30),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Open Administrator Dashboard',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Verify places, approve business registrations & moderate reviews',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white70, size: 14),
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
                  Text('Tourist (User) vs Admin Distinction',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '• Tourist (You): Discovers 81 Punjab cities, searches hospitals, orders cakes, plans trips, reviews places, and uses emergency helplines.\n• Administrator: Tourism Department authority responsible for verifying new listings, checking business licenses, and issuing tourist alerts.',
                style:
                    TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
          label: const Text('Log Out',
              style: TextStyle(fontWeight: FontWeight.bold)),
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
                    : (isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B)),
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
        border: Border.all(
            color: isDark
                ? const Color(0xFF334155)
                : Colors.black.withValues(alpha: 0.06)),
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
                        color:
                            isDark ? const Color(0xFF94A3B8) : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 13, color: isDark ? Colors.white38 : Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
