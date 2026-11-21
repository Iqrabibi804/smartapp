import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/data/punjab_81_cities_data.dart';
import '../../search/screens/search_results_screen.dart';
import '../../map/screens/map_screen.dart';

class CityGuideScreen extends StatefulWidget {
  final PunjabCity city;

  const CityGuideScreen({super.key, required this.city});

  @override
  State<CityGuideScreen> createState() => _CityGuideScreenState();
}

class _CityGuideScreenState extends State<CityGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  Timer? _autoPlayTimer;

  static const Map<String, List<String>> _cityGalleries = {
    'lahore': [
      'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1200&q=80', // Badshahi Mosque
      'https://images.unsplash.com/photo-1622547748225-3fc4abd2cca0?auto=format&fit=crop&w=1200&q=80', // Shahi Qila
      'https://images.unsplash.com/photo-1596401057633-54a8fe8ef647?auto=format&fit=crop&w=1200&q=80', // Wazir Khan Mosque
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80', // Food Street
      'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?auto=format&fit=crop&w=1200&q=80', // Greater Iqbal Park
    ],
    'islamabad': [
      'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=1200&q=80', // Faisal Mosque
      'https://images.unsplash.com/photo-1584551246679-0daf3d275d0f?auto=format&fit=crop&w=1200&q=80', // Margalla Hills
      'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80', // Centaurus
      'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1200&q=80', // Lok Virsa
    ],
    'rawalpindi': [
      'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80', // Raja Bazaar
      'https://images.unsplash.com/photo-1534447677768-be436bb09401?auto=format&fit=crop&w=1200&q=80', // Ayub Park
      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=1200&q=80', // Giga Mall
    ],
    'faisalabad': [
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=1200&q=80', // Clock Tower
      'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80', // D Ground
      'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1200&q=80', // Serena Faisalabad
    ],
    'multan': [
      'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272?auto=format&fit=crop&w=1200&q=80', // Shah Rukn-e-Alam
      'https://images.unsplash.com/photo-1596401057633-54a8fe8ef647?auto=format&fit=crop&w=1200&q=80', // Blue Pottery
      'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=1200&q=80', // Multan Fort
    ],
    'murree': [
      'https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22?auto=format&fit=crop&w=1200&q=80', // Snow pine forest
      'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1200&q=80', // PC Bhurban
      'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1200&q=80', // Patriata Chairlift
    ],
    'bahawalpur': [
      'https://images.unsplash.com/photo-1622547748225-3fc4abd2cca0?auto=format&fit=crop&w=1200&q=80', // Noor Mahal
      'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?auto=format&fit=crop&w=1200&q=80', // Derawar Fort Cholistan
    ],
    'gujranwala': [
      'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1200&q=80', // Food Street
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=1200&q=80', // Nishan-e-Manzil
    ],
  };

  List<String> get _cityImages {
    final key = widget.city.id.toLowerCase();
    final specific = _cityGalleries[key];
    if (specific != null && specific.isNotEmpty) {
      return specific;
    }
    return [
      widget.city.coverImage,
      'https://images.unsplash.com/photo-1589802829985-817e51171b92?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1605649487212-47bdab064df7?auto=format&fit=crop&w=1000&q=80',
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Auto-advance hero images to provide live video / dynamic animation feel
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_imagePageController.hasClients && _cityImages.length > 1) {
        final nextPage = (_currentImageIndex + 1) % _cityImages.length;
        _imagePageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _imagePageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _makeCall(String number) async {
    final cleaned = number.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleaned');
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (_) {}
    }
  }

  LatLng _getCityCoordinates(PunjabCity city) {
    switch (city.id.toLowerCase()) {
      case 'lahore':
        return const LatLng(31.5882, 74.3103);
      case 'islamabad':
        return const LatLng(33.7295, 73.0369);
      case 'rawalpindi':
        return const LatLng(33.5975, 73.0538);
      case 'faisalabad':
        return const LatLng(31.4187, 73.0791);
      case 'multan':
        return const LatLng(30.1984, 71.4682);
      case 'murree':
        return const LatLng(33.9078, 73.3942);
      case 'bahawalpur':
        return const LatLng(29.3989, 71.6742);
      case 'gujranwala':
        return const LatLng(32.1612, 74.1952);
      default:
        return const LatLng(31.5204, 74.3587);
    }
  }

  void _navigateToMap(String spotTitle) {
    final center = _getCityCoordinates(widget.city);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          initialCenter: center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final city = widget.city;
    final images = _cityImages;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 310,
              pinned: true,
              backgroundColor: isDark ? const Color(0xFF0F172A) : primaryColor,
              leading: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  city.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Dynamic Animated PageView (Video/Cinematic Feel)
                    PageView.builder(
                      controller: _imagePageController,
                      itemCount: images.length,
                      onPageChanged: (i) => setState(() => _currentImageIndex = i),
                      itemBuilder: (context, i) {
                        return AnimatedScale(
                          scale: _currentImageIndex == i ? 1.05 : 1.0,
                          duration: const Duration(seconds: 4),
                          curve: Curves.easeOut,
                          child: Image.network(
                            images[i],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0F172A)),
                          ),
                        );
                      },
                    ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    // Live Animation Indicator Badge
                    Positioned(
                      top: 48,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.photo_library, size: 12, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              '${_currentImageIndex + 1}/${images.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // City Tagline & Urdu Name
                    Positioned(
                      bottom: 56,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  city.urduName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  city.region,
                                  style: const TextStyle(color: Colors.white, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            city.tagline,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: isDark ? Colors.white : primaryColor,
                  unselectedLabelColor: isDark ? Colors.white54 : Colors.black45,
                  indicatorColor: primaryColor,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: const [
                    Tab(text: 'Overview & Highlights'),
                    Tab(text: 'Top Places & Sightseeing'),
                    Tab(text: 'Food & Cake Delivery'),
                    Tab(text: 'Cabs & Emergency SOS'),
                  ],
                ),
                backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(city, isDark, cardBg, cardBorder, primaryTextColor, secondaryTextColor, primaryColor),
            _buildPlacesTab(city, isDark, cardBg, cardBorder, primaryTextColor, secondaryTextColor, primaryColor),
            _buildFoodAndCakesTab(city, isDark, cardBg, cardBorder, primaryTextColor, secondaryTextColor, primaryColor),
            _buildTransportAndEmergencyTab(city, isDark, cardBg, cardBorder, primaryTextColor, secondaryTextColor, primaryColor),
          ],
        ),
      ),
    );
  }

  // ── 1. Overview Tab ──
  Widget _buildOverviewTab(PunjabCity city) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Summary Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF10B981), size: 22),
                  SizedBox(width: 8),
                  Text('About the City', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                city.summary,
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoBadge('District', city.district),
                  _infoBadge('Region', city.region),
                  _infoBadge('Census Pop.', '${(city.population2023 / 1000).toStringAsFixed(0)}k+'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 🌟 Clickable Iconic Highlights & Landmarks Section
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '✨ Iconic Highlights & Landmarks',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text('(Tap to Explore)', style: TextStyle(fontSize: 11, color: Color(0xFF059669))),
          ],
        ),
        const SizedBox(height: 12),
        ...city.famousFor.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    // Navigate to in-app search for this landmark
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResultsScreen(
                          initialCity: city.name,
                          initialQuery: item,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, color: Color(0xFF10B981), size: 18),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                'Must-visit landmark in ${city.name} · Tap for details & map',
                                style: const TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 18, color: Colors.black38),
                      ],
                    ),
                  ),
                ),
              ),
            )),

        const SizedBox(height: 20),

        // Signature Foods Section
        const Text(
          '🍲 Signature Specialties & Delicacies',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: city.signatureFood.map((dish) {
            return ActionChip(
              backgroundColor: const Color(0xFFFEF3C7),
              side: const BorderSide(color: Color(0xFFF59E0B)),
              label: Text(
                dish,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF92400E)),
              ),
              avatar: const Icon(Icons.restaurant_menu, size: 16, color: Color(0xFFD97706)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchResultsScreen(
                      initialCity: city.name,
                      initialQuery: dish,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── 2. Top Places & Sightseeing Tab ──
  Widget _buildPlacesTab(PunjabCity city) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Action Card to browse live database
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Verified Places in ${city.name}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Discover real-time verified spots, directions on map, reviews, and hospital & food spots.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchResultsScreen(
                        initialCity: city.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.travel_explore, size: 18),
                label: Text('Browse All Spots in ${city.name}'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'Top Recommended Sightseeing Spots',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...city.famousFor.map((spot) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    city.coverImage,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 54,
                      height: 54,
                      color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                      child: const Icon(Icons.place, color: Color(0xFF0F172A)),
                    ),
                  ),
                ),
                title: Text(spot, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Located in ${city.name}, Punjab · Tap to View on Map',
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
                trailing: const Icon(Icons.directions, color: Color(0xFF10B981)),
                onTap: () {
                  // Opens in-app MapScreen with back button!
                  _navigateToMap(spot);
                },
              ),
            )),
      ],
    );
  }

  // ── 3. Food & Cake Delivery Tab ──
  Widget _buildFoodAndCakesTab(PunjabCity city) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Cake & Bakery Ordering Banner
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.cake, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Order Cake & Bakery in this City',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Send or order fresh birthday cakes, chocolate malt, lotus biscoff, and bakery delicacies in this city. Tap to order instantly:',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _orderButton('Foodpanda App', () => _openUrl('https://www.foodpanda.pk'), Icons.delivery_dining),
                  _orderButton('Layers Bakeshop', () => _openUrl('https://layers.shop'), Icons.storefront),
                  _orderButton('TCS Sentiments (Gift)', () => _openUrl('https://www.sentimentsexpress.com'), Icons.card_giftcard),
                  _orderButton('Browse City Bakeries', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResultsScreen(
                          initialCategoryName: 'Bakeries & Cakes',
                          initialCity: city.name,
                        ),
                      ),
                    );
                  }, Icons.cake),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Top Local Food Specialties',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...city.signatureFood.map((food) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.fastfood, color: Color(0xFFF59E0B), size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('Traditional must-try dish in ${city.name}',
                            style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchResultsScreen(
                            initialCity: city.name,
                            initialQuery: food,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: const Text('Find Spots', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  // ── 4. Transport & Emergency Tab ──
  Widget _buildTransportAndEmergencyTab(PunjabCity city) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Cab & Ride Booking
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.local_taxi, color: Color(0xFF10B981), size: 22),
                  SizedBox(width: 8),
                  Text('Book a Ride or Cab', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Need a ride around town or between cities? Tap to open verified taxi networks:',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _cabCard('InDrive', 'Bargain & ride', Colors.green.shade700,
                        () => _openUrl('https://indrive.com')),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _cabCard('Yango', 'Affordable rides', Colors.red.shade700,
                        () => _openUrl('https://yango.com')),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _cabCard('Careem', 'Twin city rides', Colors.teal.shade700,
                        () => _openUrl('https://www.careem.com')),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Emergency Helplines & Hospitals Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFCA5A5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.emergency, color: Color(0xFFDC2626), size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Tourist Emergency & Medical Care',
                    style: TextStyle(color: Color(0xFF991B1B), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Immediate 24/7 emergency response numbers active across ${city.name} and Punjab:',
                style: const TextStyle(color: Colors.black87, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _sosTile('Rescue 1122 Ambulance', '1122', Icons.medical_services, Colors.red),
              const SizedBox(height: 8),
              _sosTile('Tourist Police Helpline', '15', Icons.local_police, Colors.blue),
              const SizedBox(height: 8),
              _sosTile('Punjab Tourism Helpline', '1787', Icons.support_agent, Colors.teal),
              const SizedBox(height: 8),
              _sosTile('Punjab Highway Police', '130', Icons.car_crash, Colors.indigo),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchResultsScreen(
                        initialCategoryName: 'Hospitals & Medical',
                        initialCity: city.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.local_hospital),
                label: Text('Find Hospitals in ${city.name}'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Citizen Grievance & Complaint Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.gavel, color: Color(0xFF0F172A), size: 22),
                  SizedBox(width: 8),
                  Text('Citizen Complaint & Grievance Portal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Report tourist overcharging, food adulteration, or road safety complaints directly to the government:',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFF0F172A)),
                  minimumSize: const Size(double.infinity, 42),
                ),
                onPressed: () => _openUrl('https://citizenportal.gov.pk'),
                icon: const Icon(Icons.public, size: 16),
                label: const Text('Open Pakistan Citizen Portal'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoBadge(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      ],
    );
  }

  Widget _orderButton(String title, VoidCallback onTap, IconData icon) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFBE185D),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _cabCard(String name, String sub, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.directions_car, color: color, size: 24),
            const SizedBox(height: 4),
            Text(name, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            Text(sub, style: const TextStyle(fontSize: 9, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _sosTile(String title, String number, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _makeCall(number),
            child: Text('Call $number', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, {this.backgroundColor = Colors.white});

  final TabBar _tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
