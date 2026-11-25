import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/punjab_81_cities_data.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_logo.dart';
import '../../auth/services/auth_providers.dart';
import '../../auth/screens/login_screen.dart';
import '../../map/screens/map_screen.dart';
import '../../search/screens/search_results_screen.dart';
import '../../favorites/screens/saved_places_screen.dart';
import '../../ai/screens/map_ai_screen.dart';
import '../../trips/screens/smart_route_planner_screen.dart';
import '../../trips/screens/smart_budget_planner_screen.dart';
import '../../trips/screens/my_trips_screen.dart';
import '../../events/services/events_service.dart';
import '../../events/screens/events_list_screen.dart';
import '../../events/screens/event_details_screen.dart';
import '../../business/screens/business_registration_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../places/screens/city_guide_screen.dart';
import '../../places/screens/offline_city_packs_screen.dart';
import '../../places/screens/road_infrastructure_alerts_screen.dart';
import '../../places/screens/facility_finder_screen.dart';
import '../../places/screens/restaurants_screen.dart';
import '../../places/screens/stays_screen.dart';
import '../../places/screens/complaints_screen.dart';
import '../../trips/screens/journey_readiness_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tabIndex = 0;

  static const List<({String en, String ur, IconData icon, IconData active})>
      _tabs = [
    (
      en: 'Explore',
      ur: 'دریافت',
      icon: Icons.explore_outlined,
      active: Icons.explore
    ),
    (
      en: 'Routes',
      ur: 'روٹس',
      icon: Icons.alt_route_outlined,
      active: Icons.alt_route
    ),
    (
      en: 'Budget',
      ur: 'بجٹ',
      icon: Icons.account_balance_wallet_outlined,
      active: Icons.account_balance_wallet
    ),
    (
      en: 'Essentials',
      ur: 'ضروریات',
      icon: Icons.grid_view_outlined,
      active: Icons.grid_view_rounded
    ),
  ];

  String _titleFor(AppLanguage lang) => switch (_tabIndex) {
        0 => lang == AppLanguage.urdu ? 'پنجاب دریافت کریں' : 'Explore Punjab',
        1 =>
          lang == AppLanguage.urdu ? 'سمارٹ روٹ پلانر' : 'Smart Route Planner',
        2 => lang == AppLanguage.urdu ? 'بجٹ پلانر' : 'Budget Planner',
        _ => lang == AppLanguage.urdu ? 'ضروریات' : 'Essentials',
      };

  Widget _bodyForTab(AppLanguage lang) {
    switch (_tabIndex) {
      case 1:
        return const SmartRoutePlannerScreen();
      case 2:
        return const SmartBudgetPlannerScreen();
      case 3:
        return _EssentialsTab(onOpenAI: _openAiConcierge);
      default:
        return _ExploreTab(
          onOpenTab: (index) => setState(() => _tabIndex = index),
        );
    }
  }

  void _openAiConcierge() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AiConciergeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final isUrdu = lang == AppLanguage.urdu;
    final wide = MediaQuery.sizeOf(context).width >= 1024;

    Widget shell = Column(
      children: [
        _TopBar(
          wide: wide,
          title: _titleFor(lang),
          isUrdu: isUrdu,
        ),
        Expanded(child: _bodyForTab(lang)),
      ],
    );

    if (wide) {
      shell = Row(
        children: [
          _Sidebar(
            selectedTab: _tabIndex,
            isUrdu: isUrdu,
            onSelectTab: (index) => setState(() => _tabIndex = index),
          ),
          Expanded(child: shell),
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppTokens.dashboardBg,
      body: SafeArea(child: shell),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _tabIndex == 3
          ? null
          : SizedBox(
              width: 52,
              height: 52,
              child: FloatingActionButton(
                onPressed: _openAiConcierge,
                backgroundColor: AppTokens.emerald,
                foregroundColor: Colors.white,
                elevation: 6,
                shape: const CircleBorder(),
                tooltip: isUrdu ? 'اے آئی گائیڈ' : 'AI Travel Concierge',
                child: const Icon(Icons.auto_awesome, size: 22),
              ),
            ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              height: 68,
              selectedIndex: _tabIndex,
              onDestinationSelected: (i) => setState(() => _tabIndex = i),
              destinations: [
                for (var i = 0; i < _tabs.length; i++)
                  NavigationDestination(
                    icon: Icon(_tabs[i].icon),
                    selectedIcon:
                        Icon(_tabs[i].active, color: AppTokens.emerald),
                    label: isUrdu ? _tabs[i].ur : _tabs[i].en,
                  ),
              ],
            ),
    );
  }
}

// ── Top header bar ──────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  const _TopBar({
    required this.wide,
    required this.title,
    required this.isUrdu,
  });

  final bool wide;
  final String title;
  final bool isUrdu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = AppTokens.textMuted;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTokens.border)),
      ),
      child: Row(
        children: [
          if (!wide) ...[
            const AppLogoMark3D(size: 32),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'SmartMap Punjab',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTokens.fontHeading,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTokens.emerald,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ] else ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppTokens.fontHeading,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                  ),
                ),
                Text(
                  isUrdu
                      ? 'سمارٹ میپ پنجاب · آزاد گائیڈ'
                      : 'SmartMap Punjab · Independent guide',
                  style: TextStyle(fontSize: 10.5, color: muted),
                ),
              ],
            ),
            const Spacer(),
          ],
          const SizedBox(width: 6),
          Tooltip(
            message:
                isUrdu ? 'آف لائن ڈیٹا لوڈ ہے' : 'Offline city data is bundled',
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const OfflineCityPacksScreen()),
              ),
              icon: const Icon(Icons.cloud_done_outlined,
                  size: 20, color: AppTokens.success),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ),
          const SizedBox(width: 4),
          _LanguageToggle(isUrdu: isUrdu),
          const SizedBox(width: 6),
          _SosButton(isUrdu: isUrdu),
        ],
      ),
    );
  }
}

class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle({required this.isUrdu});

  final bool isUrdu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget option(
        String label, bool selected, bool urduLabel, AppLanguage language) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ref.read(languageProvider.notifier).setLanguage(language),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: selected ? AppTokens.emerald : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: urduLabel ? AppTokens.fontUrdu : AppTokens.fontBody,
              fontSize: urduLabel ? 14 : 10.5,
              height: urduLabel ? 1.5 : 1.2,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : AppTokens.textSecondary,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppTokens.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          option('EN', !isUrdu, false, AppLanguage.english),
          option('اردو', isUrdu, true, AppLanguage.urdu),
        ],
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({required this.isUrdu});

  final bool isUrdu;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => const _SosDialog(),
        ),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.call_rounded, size: 13, color: Colors.white),
              const SizedBox(width: 3),
              const Text(
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
}

// ── Desktop sidebar ─────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.selectedTab,
    required this.isUrdu,
    required this.onSelectTab,
  });

  final int selectedTab;
  final bool isUrdu;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        en: 'Explore Dashboard',
        ur: 'دریافت ڈیش بورڈ',
        icon: Icons.explore_outlined,
        tab: 0
      ),
      (
        en: 'Smart Route & Trip Planner',
        ur: 'سمارٹ روٹ پلانر',
        icon: Icons.alt_route_outlined,
        tab: 1
      ),
      (
        en: 'Budget Calculator',
        ur: 'بجٹ کیلکولیٹر',
        icon: Icons.account_balance_wallet_outlined,
        tab: 2
      ),
    ];

    Widget link({
      required String label,
      required IconData icon,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Material(
        color: selected ? AppTokens.emeraldTint : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(icon,
                    size: 19,
                    color:
                        selected ? AppTokens.emerald : AppTokens.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? AppTokens.emerald
                          : AppTokens.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void push(Widget screen) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppTokens.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Row(
              children: [
                const AppLogoMark3D(size: 36),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'SmartMap Punjab',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTokens.fontHeading,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppTokens.emerald,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTokens.border),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
            child: Column(
              children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: link(
                      label: isUrdu ? item.ur : item.en,
                      icon: item.icon,
                      selected: selectedTab == item.tab,
                      onTap: () => onSelectTab(item.tab),
                    ),
                  ),
                link(
                  label: isUrdu ? 'ہسپتال اور میڈیکل' : 'Hospitals & Medical',
                  icon: Icons.local_hospital_outlined,
                  selected: false,
                  onTap: () => push(const FacilityFinderScreen()),
                ),
                link(
                  label: isUrdu ? 'سٹے اور ہوٹل' : 'Stays & Hotels',
                  icon: Icons.hotel_outlined,
                  selected: false,
                  onTap: () => push(const StaysScreen()),
                ),
                link(
                  label: isUrdu
                      ? 'بیکری اور مقامی کھانا'
                      : 'Bakeries & Local Food',
                  icon: Icons.bakery_dining_outlined,
                  selected: false,
                  onTap: () => push(const SearchResultsScreen(
                      initialCategoryName: 'Bakeries & Cakes')),
                ),
                link(
                  label: isUrdu
                      ? 'محفوظ ٹرپس اور آف لائن'
                      : 'Saved Trips & Offline',
                  icon: Icons.bookmarks_outlined,
                  selected: false,
                  onTap: () => push(const SavedPlacesScreen()),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTokens.dashboardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTokens.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTokens.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          isUrdu
                              ? 'آف لائن ہائی وے ڈیٹا'
                              : 'Offline highway data',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppTokens.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isUrdu
                        ? 'ایڈوائزری ایپ کے ساتھ محفوظ ہے'
                        : 'Advisories ship inside the app',
                    style: const TextStyle(
                        fontSize: 10.5, color: AppTokens.textMuted),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () => push(const OfflineCityPacksScreen()),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(30),
                        padding: EdgeInsets.zero,
                        side: const BorderSide(color: AppTokens.emeraldBorder),
                        foregroundColor: AppTokens.emerald,
                        textStyle: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                      child: Text(isUrdu ? 'پیک دیکھیں' : 'Manage packs'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Explore tab ─────────────────────────────────────────────────────────────

class _ExploreTab extends ConsumerStatefulWidget {
  const _ExploreTab({required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  ConsumerState<_ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<_ExploreTab> {
  String _filter = 'all';
  final Set<String> _bookmarks = <String>{};

  static const List<
      ({
        String id,
        String en,
        String ur,
        String placeEn,
        String placeUr,
        String? asset,
        String? cityId,
        List<String> tags,
        String season,
        String distance,
      })> _destinations = [
    (
      id: 'walled-city',
      en: 'Lahore (Walled City)',
      ur: 'لاہور (اندھیروں والا شہر)',
      placeEn: 'Lahore District',
      placeUr: 'ضلع لاہور',
      asset: 'assets/images/landmarks/lahore_fort.jpg',
      cityId: 'lahore',
      tags: ['history', 'family'],
      season: 'Oct–Mar',
      distance: 'Walled City',
    ),
    (
      id: 'badshahi',
      en: 'Badshahi Mosque',
      ur: 'بادشاہی مسجد',
      placeEn: 'Walled City, Lahore',
      placeUr: 'اندھیروں والا شہر، لاہور',
      asset: 'assets/images/landmarks/badshahi_mosque.jpg',
      cityId: 'lahore',
      tags: ['history', 'spiritual'],
      season: 'Oct–Mar',
      distance: '1 km from Fort',
    ),
    (
      id: 'shalimar',
      en: 'Shalimar Gardens',
      ur: 'شالیمار باغ',
      placeEn: 'Lahore',
      placeUr: 'لاہور',
      asset: 'assets/images/landmarks/shalimar_gardens.jpg',
      cityId: 'lahore',
      tags: ['history', 'family'],
      season: 'Oct–Mar',
      distance: '5 km from Lahore',
    ),
    (
      id: 'taxila',
      en: 'Taxila (Gandhara)',
      ur: 'ٹیکسلا (گندھارا)',
      placeEn: 'Taxila, Rawalpindi',
      placeUr: 'ٹیکسلا، راولپنڈی',
      asset: 'assets/images/landmarks/taxila_dharmarajika.jpg',
      cityId: 'taxila',
      tags: ['history'],
      season: 'Oct–Mar',
      distance: '≈ 35 km from Islamabad',
    ),
    (
      id: 'multan',
      en: 'Multan (Shrines)',
      ur: 'ملتان (مزارات)',
      placeEn: 'Multan',
      placeUr: 'ملتان',
      asset: 'assets/images/landmarks/multan_shrine.jpg',
      cityId: 'multan',
      tags: ['spiritual', 'family'],
      season: 'Oct–Mar',
      distance: '≈ 340 km from Lahore',
    ),
    (
      id: 'murree',
      en: 'Murree & Patriata',
      ur: 'مری اور پٹریاٹا',
      placeEn: 'Murree, Galyat',
      placeUr: 'مری، گلیات',
      asset: 'assets/images/landmarks/murree.jpg',
      cityId: 'murree',
      tags: ['hills', 'family'],
      season: 'Apr–Oct',
      distance: '≈ 370 km from Lahore',
    ),
    (
      id: 'derawar',
      en: 'Derawar Fort',
      ur: 'قلعہ ڈیراور',
      placeEn: 'Cholistan, Bahawalpur',
      placeUr: 'چولستان، بہاولپور',
      asset: 'assets/images/landmarks/derawar_fort.jpg',
      cityId: 'bahawalpur',
      tags: ['history'],
      season: 'Oct–Mar',
      distance: '≈ 420 km from Lahore',
    ),
    (
      id: 'noor-mahal',
      en: 'Noor Mahal',
      ur: 'نور محل',
      placeEn: 'Bahawalpur',
      placeUr: 'بہاولپور',
      asset: 'assets/images/landmarks/noor_mahal.jpg',
      cityId: 'bahawalpur',
      tags: ['history', 'family'],
      season: 'Oct–Mar',
      distance: '≈ 420 km from Lahore',
    ),
    (
      id: 'raja-bazaar',
      en: 'Raja Bazaar',
      ur: 'راجہ بازار',
      placeEn: 'Rawalpindi',
      placeUr: 'راولپنڈی',
      asset: 'assets/images/landmarks/rawalpindi_bazaar.jpg',
      cityId: 'rawalpindi',
      tags: ['family'],
      season: 'Oct–Mar',
      distance: '≈ 275 km from Lahore',
    ),
    (
      id: 'rohtas',
      en: 'Rohtas Fort',
      ur: 'قلعہ روہتاس',
      placeEn: 'Jhelum',
      placeUr: 'جہلم',
      asset: null,
      cityId: 'jhelum',
      tags: ['history'],
      season: 'Oct–Mar',
      distance: '≈ 220 km from Lahore',
    ),
    (
      id: 'sahiwal',
      en: 'Sahiwal & Harappa',
      ur: 'ساہیوال اور ہڑپہ',
      placeEn: 'Sahiwal',
      placeUr: 'ساہیوال',
      asset: null,
      cityId: 'sahiwal',
      tags: ['history', 'family'],
      season: 'Oct–Mar',
      distance: '≈ 180 km from Lahore',
    ),
  ];

  static const List<({String id, String en, String ur})> _filters = [
    (id: 'all', en: 'All Destinations', ur: 'تمام مقامات'),
    (id: 'history', en: 'Historical & Mughal', ur: 'تاریخی اور مغل'),
    (id: 'hills', en: 'Hill Stations', ur: 'پہاڑی مقامات'),
    (id: 'spiritual', en: 'Spiritual & Shrines', ur: 'روحانی مقامات'),
    (id: 'family', en: 'Family & Food', ur: 'خاندان اور کھانا'),
  ];

  void _push(Widget screen) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  void _openDestination(String? cityId) {
    final city = cityId == null ? null : _city(cityId);
    if (city != null) {
      _push(CityGuideScreen(city: city));
    } else {
      _push(const SearchResultsScreen());
    }
  }

  PunjabCity? _city(String id) {
    for (final city in Punjab81CitiesData.allCities) {
      if (city.id.toLowerCase() == id.toLowerCase()) return city;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final isUrdu = lang == AppLanguage.urdu;
    String t(String en, String ur) => isUrdu ? ur : en;

    final visible = _filter == 'all'
        ? _destinations
        : _destinations.where((d) => d.tags.contains(_filter)).toList();

    return Directionality(
      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
            children: [
              _buildSearch(isUrdu, t),
              const SizedBox(height: 22),
              _SectionTitle(
                title: t('Quick Travel Tools', 'فوری سفری ٹولز'),
                subtitle: t('Plan, budget and find help in one tap',
                    'ایک ٹیپ میں منصوبہ، بجٹ اور مدد'),
              ),
              const SizedBox(height: 12),
              _QuickTools(onOpenTab: widget.onOpenTab, isUrdu: isUrdu),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: _SectionTitle(
                      title: t('Explore Punjab Destinations',
                          'پنجاب کے مقامات دریافت کریں'),
                      subtitle: t('Real places, photographed on location',
                          'حقیقی مقامات، اصل تصاویر کے ساتھ'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _push(const SearchResultsScreen()),
                    child: Text(t('View all', 'سب دیکھیں'),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTokens.emerald)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final f in _filters)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: _FilterPill(
                          label: isUrdu ? f.ur : f.en,
                          selected: _filter == f.id,
                          onTap: () => setState(() => _filter = f.id),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 900 ? 3 : 2;
                  const spacing = 12.0;
                  final tileWidth =
                      (constraints.maxWidth - spacing * (columns - 1)) /
                          columns;
                  final extent = tileWidth * 0.75 + 104;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visible.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      mainAxisExtent: extent,
                    ),
                    itemBuilder: (context, index) {
                      final d = visible[index];
                      return _DestinationCard(
                        destination: d,
                        isUrdu: isUrdu,
                        bookmarked: _bookmarks.contains(d.id),
                        onBookmark: () {
                          setState(() {
                            if (!_bookmarks.add(d.id)) {
                              _bookmarks.remove(d.id);
                            }
                          });
                        },
                        onTap: () => _openDestination(d.cityId),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 13, color: AppTokens.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t(
                        'Distances are approximate road estimates. Season tags are suggested travel windows.',
                        'فاصلے تخمینی سڑک کے اندازے ہیں۔ موسم کے ٹیگز تجویز کردہ سفری اوقات ہیں۔',
                      ),
                      style: const TextStyle(
                          fontSize: 10.5, color: AppTokens.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _EventsSection(),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 13, color: AppTokens.textMuted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t(
                        'Independent guide · Not affiliated with any government body.',
                        'آزاد گائیڈ · کسی سرکاری ادارے سے وابستہ نہیں۔',
                      ),
                      style: const TextStyle(
                          fontSize: 10.5, color: AppTokens.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch(bool isUrdu, String Function(String, String) t) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => _push(const SearchResultsScreen()),
        child: Container(
          height: 54,
          padding: const EdgeInsetsDirectional.only(start: 8, end: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTokens.border),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  t(
                    'Search cities, forts, motorways, hospitals, or food...',
                    'شہر، قلعے، موٹروے، ہسپتال یا کھانا تلاش کریں...',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 13.5, color: AppTokens.textMuted),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppTokens.emerald,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppTokens.fontHeading,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTokens.textPrimary,
            height: 1.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style:
                const TextStyle(fontSize: 11, color: AppTokens.textSecondary),
          ),
        ],
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTokens.emerald : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: selected ? AppTokens.emerald : AppTokens.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTokens.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _QuickTools extends StatelessWidget {
  const _QuickTools({required this.onOpenTab, required this.isUrdu});

  final ValueChanged<int> onOpenTab;
  final bool isUrdu;

  @override
  Widget build(BuildContext context) {
    String t(String en, String ur) => isUrdu ? ur : en;
    final tools = [
      (
        title: t('Smart Route Planner', 'سمارٹ روٹ پلانر'),
        subtitle: t('Motorway routes, fuel & toll guidance',
            'موٹروے روٹس، ایندھن اور ٹول رہنمائی'),
        icon: Icons.alt_route_rounded,
        tint: AppTokens.pastelMint,
        color: AppTokens.emerald,
        onTap: () => onOpenTab(1),
      ),
      (
        title: t('AI Budget Calculator', 'اے آئی بجٹ کیلکولیٹر'),
        subtitle: t('Day-by-day PKR trip planner', 'روز بروز PKR ٹرپ پلانر'),
        icon: Icons.account_balance_wallet_rounded,
        tint: AppTokens.pastelGold,
        color: AppTokens.gold,
        onTap: () => onOpenTab(2),
      ),
      (
        title: t('24/7 Medical & Essentials', 'چوبیس گھنٹے طبی اور ضروریات'),
        subtitle: t(
            'Hospitals, bakeries & local help', 'ہسپتال، بیکری اور مقامی مدد'),
        icon: Icons.medical_services_rounded,
        tint: AppTokens.pastelTeal,
        color: const Color(0xFF0F766E),
        onTap: () => onOpenTab(3),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final width = (constraints.maxWidth - spacing * 2) / 3;
        return Row(
          children: [
            for (var i = 0; i < tools.length; i++) ...[
              if (i > 0) const SizedBox(width: spacing),
              SizedBox(
                width: width,
                child: _QuickToolCard(
                  title: tools[i].title,
                  subtitle: tools[i].subtitle,
                  icon: tools[i].icon,
                  tint: tools[i].tint,
                  color: tools[i].color,
                  onTap: tools[i].onTap,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _QuickToolCard extends StatelessWidget {
  const _QuickToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 132,
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTokens.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                child: Icon(icon, size: 17, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTokens.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 10,
                      color: AppTokens.textSecondary,
                      height: 1.25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.destination,
    required this.isUrdu,
    required this.bookmarked,
    required this.onBookmark,
    required this.onTap,
  });

  final ({
    String id,
    String en,
    String ur,
    String placeEn,
    String placeUr,
    String? asset,
    String? cityId,
    List<String> tags,
    String season,
    String distance,
  }) destination;
  final bool isUrdu;
  final bool bookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTokens.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (destination.asset != null)
                      Image.asset(
                        destination.asset!,
                        fit: BoxFit.cover,
                        cacheWidth: 640,
                        errorBuilder: (_, __, ___) => const _PhotoPlaceholder(),
                      )
                    else
                      const _PhotoPlaceholder(),
                    PositionedDirectional(
                      top: 6,
                      start: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTokens.goldTint,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppTokens.goldBorder),
                        ),
                        child: Text(
                          '${isUrdu ? 'بہترین' : 'Best'}: ${destination.season}',
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: AppTokens.goldHover,
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 4,
                      end: 4,
                      child: GestureDetector(
                        onTap: onBookmark,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            bookmarked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16,
                            color: bookmarked
                                ? AppTokens.alertRed
                                : AppTokens.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUrdu ? destination.ur : destination.en,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            size: 11, color: AppTokens.textMuted),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            isUrdu ? destination.placeUr : destination.placeEn,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10, color: AppTokens.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Align(
                      alignment:
                          isUrdu ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        destination.distance,
                        textDirection: TextDirection.ltr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppTokens.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTokens.emeraldTint, AppTokens.pastelGold],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image_not_supported_outlined,
              size: 26, color: AppTokens.emerald),
          SizedBox(height: 4),
          Text(
            'Photo unavailable',
            style: TextStyle(fontSize: 9, color: AppTokens.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Essentials tab ──────────────────────────────────────────────────────────

class _EssentialsTab extends ConsumerWidget {
  const _EssentialsTab({required this.onOpenAI});
  final VoidCallback onOpenAI;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final isUrdu = lang == AppLanguage.urdu;
    String t(String en, String ur) => isUrdu ? ur : en;
    void push(Widget screen) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

    final gridItems = [
      (
        label: t('Pharmacies', 'فارمیسی'),
        icon: Icons.medication_rounded,
        tint: AppTokens.pastelMint,
        color: AppTokens.emerald,
        onTap: () => push(const FacilityFinderScreen(
            initialType: FacilityType(
                label: 'Pharmacies',
                icon: Icons.medication_rounded,
                query: 'pharmacy'))),
      ),
      (
        label: t('Parks', 'پارکس'),
        icon: Icons.park_rounded,
        tint: AppTokens.pastelMint,
        color: AppTokens.emerald,
        onTap: () => push(const FacilityFinderScreen(initialType: FacilityType(
            label: 'Parks', icon: Icons.park_rounded, query: 'park'))),
      ),
      (
        label: t('Parking', 'پارکنگ'),
        icon: Icons.local_parking_rounded,
        tint: AppTokens.pastelBlue,
        color: AppTokens.multaniBlue,
        onTap: () => push(const FacilityFinderScreen(initialType: FacilityType(
            label: 'Parking', icon: Icons.local_parking_rounded, query: 'parking'))),
      ),
      (
        label: t('ATMs', 'اے ٹی ایم'),
        icon: Icons.atm_rounded,
        tint: AppTokens.pastelBlue,
        color: AppTokens.multaniBlue,
        onTap: () => push(const FacilityFinderScreen(
            initialType: FacilityType(
                label: 'ATMs', icon: Icons.atm_rounded, query: 'ATM'))),
      ),
      (
        label: t('Police', 'پولیس'),
        icon: Icons.local_police_rounded,
        tint: AppTokens.pastelRose,
        color: AppTokens.alertRed,
        onTap: () => push(const FacilityFinderScreen(
            initialType: FacilityType(
                label: 'Police',
                icon: Icons.local_police_rounded,
                query: 'police'))),
      ),
      (
        label: t('Petrol pumps', 'پٹرول پمپ'),
        icon: Icons.local_gas_station_rounded,
        tint: AppTokens.pastelGold,
        color: AppTokens.gold,
        onTap: () => push(const FacilityFinderScreen(
            initialType: FacilityType(
                label: 'Petrol pumps',
                icon: Icons.local_gas_station_rounded,
                query: 'petrol'))),
      ),
      (
        label: t('Restaurants', 'ریستوران'),
        icon: Icons.restaurant_rounded,
        tint: AppTokens.pastelRose,
        color: const Color(0xFFB91C1C),
        onTap: () => push(const FacilityFinderScreen(initialType: FacilityType(
            label: 'Restaurants', icon: Icons.restaurant_rounded, categoryName: 'Restaurants'))),
      ),
      (
        label: t('Hotels & Stays', 'ہوٹل اور سٹے'),
        icon: Icons.hotel_rounded,
        tint: AppTokens.pastelBlue,
        color: AppTokens.multaniBlue,
        onTap: () => push(const StaysScreen()),
      ),
      (
        label: t('Road alerts', 'سڑک الرٹس'),
        icon: Icons.warning_amber_rounded,
        tint: AppTokens.pastelGold,
        color: AppTokens.gold,
        onTap: () => push(const RoadInfrastructureAlertsScreen()),
      ),
      (
        label: t('Journey readiness', 'سفر کی تیاری'),
        icon: Icons.checklist_rounded,
        tint: AppTokens.pastelLilac,
        color: const Color(0xFF6D28D9),
        onTap: () => push(const JourneyReadinessScreen()),
      ),
      (
        label: t('Profile & settings', 'پروفائل اور ترتیبات'),
        icon: Icons.manage_accounts_outlined,
        tint: AppTokens.pastelMint,
        color: AppTokens.emerald,
        onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const Scaffold(
                  backgroundColor: AppTokens.dashboardBg,
                  body: SafeArea(child: _ProfileTabPlaceholder()),
                ),
              ),
            ),
      ),
      (
        label: t('Map view', 'نقشہ'),
        icon: Icons.map_outlined,
        tint: AppTokens.pastelMint,
        color: AppTokens.emerald,
        onTap: () => push(const MapScreen()),
      ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 112),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _SectionTitle(
                    title: t('Essentials', 'ضروریات'),
                    subtitle: t('Hospitals, food and everyday help across Punjab',
                        'پنجاب بھر میں ہسپتال، کھانا اور روزمرہ مدد'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onOpenAI,
                  icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                  label: Text(t('Ask AI', 'اے آئی سے پوچھیں')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTokens.emerald,
                    side: const BorderSide(color: AppTokens.border),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _EssentialsHeroCard(
                    title: t('Hospitals & Medical', 'ہسپتال اور میڈیکل'),
                    subtitle: t('Emergency, trauma centres and clinics',
                        'ایمرجنسی، ٹراما سنٹر اور کلینک'),
                    icon: Icons.local_hospital_rounded,
                    tint: AppTokens.pastelRose,
                    color: AppTokens.alertRed,
                    onTap: () => push(const FacilityFinderScreen()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _EssentialsHeroCard(
                    title: t('Bakeries & Local Food', 'بیکری اور مقامی کھانا'),
                    subtitle: t('Cakes, sweets and traditional bakeries',
                        'کیک، مٹھائی اور روایتی بیکری'),
                    icon: Icons.bakery_dining_rounded,
                    tint: AppTokens.pastelGold,
                    color: AppTokens.gold,
                    onTap: () => push(const SearchResultsScreen(
                        initialCategoryName: 'Bakeries & Cakes')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: t('More essentials', 'مزید ضروریات')),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gridItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 92,
              ),
              itemBuilder: (context, index) {
                final item = gridItems[index];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: item.onTap,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTokens.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                                color: item.tint, shape: BoxShape.circle),
                            child: Icon(item.icon, size: 17, color: item.color),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.label,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTokens.textSecondary,
                                height: 1.15),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTokens.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined,
                      size: 20, color: AppTokens.emerald),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t(
                        'Directory entries are not government-verified. Check the phone number and facilities before relying on them.',
                        'ڈائریکٹری کے اندراجات سرکاری تصدیق شدہ نہیں ہیں۔ بھروسے سے پہلے فون نمبر اور سہولیات خود تصدیق کریں۔',
                      ),
                      style: const TextStyle(
                          fontSize: 10.5,
                          color: AppTokens.textSecondary,
                          height: 1.4),
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

class _EssentialsHeroCard extends StatelessWidget {
  const _EssentialsHeroCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTokens.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTokens.textPrimary,
                    height: 1.2),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 10.5,
                    color: AppTokens.textSecondary,
                    height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── SOS dialog ──────────────────────────────────────────────────────────────

class _SosDialog extends StatelessWidget {
  const _SosDialog();

  Future<void> _call(String number) async {
    final uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) await launchUrl(uri);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final lines = [
      (
        title: 'Rescue 1122',
        sub: 'Ambulance, fire & rescue',
        number: '1122',
        icon: Icons.medical_services_rounded,
        tint: AppTokens.pastelRose,
        color: AppTokens.alertRed,
        button: AppTokens.alertRed,
      ),
      (
        title: 'Tourist Police 1421',
        sub: 'Punjab tourist police helpline',
        number: '1421',
        icon: Icons.support_agent_rounded,
        tint: AppTokens.pastelMint,
        color: AppTokens.emerald,
        button: AppTokens.emerald,
      ),
      (
        title: 'Police 15',
        sub: 'Police emergency',
        number: '15',
        icon: Icons.local_police_rounded,
        tint: AppTokens.pastelBlue,
        color: AppTokens.multaniBlue,
        button: AppTokens.multaniBlue,
      ),
      (
        title: 'Motorway Police 130',
        sub: 'Motorway & highway patrol',
        number: '130',
        icon: Icons.directions_car_filled_rounded,
        tint: AppTokens.pastelGold,
        color: AppTokens.gold,
        button: AppTokens.gold,
      ),
      (
        title: 'Tourist Grievance 1787',
        sub: 'Overcharging & hotel fraud complaints',
        number: '1787',
        icon: Icons.gavel_rounded,
        tint: AppTokens.pastelLilac,
        color: const Color(0xFF6D28D9),
        button: const Color(0xFF475569),
      ),
    ];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 8, 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTokens.pastelRose,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.health_and_safety_rounded,
                        color: AppTokens.alertRed, size: 21),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '24/7 Tourist Emergency Helplines',
                          style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: AppTokens.textPrimary),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Public helplines in Punjab. Calls open your phone dialer; the app does not dispatch help.',
                          style: TextStyle(
                              fontSize: 10.5,
                              color: AppTokens.textSecondary,
                              height: 1.3),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                        size: 20, color: AppTokens.textSecondary),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTokens.border),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    for (final line in lines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTokens.dashboardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTokens.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: line.tint,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(line.icon,
                                    size: 17, color: line.color),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      line.title,
                                      style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppTokens.textPrimary),
                                    ),
                                    Text(
                                      line.sub,
                                      style: const TextStyle(
                                          fontSize: 10.5,
                                          color: AppTokens.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () => _call(line.number),
                                style: FilledButton.styleFrom(
                                  backgroundColor: line.button,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 32),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999)),
                                ),
                                icon: const Icon(Icons.call_rounded, size: 13),
                                label: Text(
                                  line.number,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 2),
                    const Text(
                      'Numbers are public helplines. Verify locally if a line does not answer.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 10, color: AppTokens.textMuted),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          backgroundColor: AppTokens.inputFill,
                          foregroundColor: AppTokens.textPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Close',
                            style: TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── AI concierge sheet ──────────────────────────────────────────────────────

class _AiConciergeSheet extends StatelessWidget {
  const _AiConciergeSheet();

  @override
  Widget build(BuildContext context) {
    final prompts = [
      'Plan a 3-day Murree trip under Rs. 25,000',
      'What should I see in one day in Lahore?',
      'Which motorway rest stops have a mosque?',
      'Is the Murree road open right now?',
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: EdgeInsets.fromLTRB(
          18, 10, 18, 18 + MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTokens.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppTokens.emeraldTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome,
                      size: 20, color: AppTokens.emerald),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Punjab Travel Concierge',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTokens.textPrimary),
                      ),
                      Text(
                        'Ask about routes, food, budgets or safety',
                        style: TextStyle(
                            fontSize: 11, color: AppTokens.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded,
                      size: 20, color: AppTokens.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Suggested questions',
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppTokens.textSecondary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final prompt in prompts)
                  ActionChip(
                    label: Text(prompt,
                        style: const TextStyle(
                            fontSize: 11, color: AppTokens.textSecondary)),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppTokens.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const MapAiScreen()));
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MapAiScreen()));
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTokens.emerald,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.chat_bubble_outline, size: 17),
                label: const Text('Open AI guide',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI answers can be wrong. Verify live road status and emergency numbers with official sources.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: AppTokens.textMuted),
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
