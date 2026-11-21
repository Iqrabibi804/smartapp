import 'package:flutter/material.dart';
import '../../../core/data/punjab_81_cities_data.dart';
import 'city_guide_screen.dart';

class CityExplorerScreen extends StatefulWidget {
  const CityExplorerScreen({super.key});

  @override
  State<CityExplorerScreen> createState() => _CityExplorerScreenState();
}

class _CityExplorerScreenState extends State<CityExplorerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRegion = 'All';
  List<PunjabCity> _displayedCities = Punjab81CitiesData.allCities;

  final List<String> _regions = [
    'All',
    'Central Punjab',
    'Potohar / North',
    'South Punjab',
    'Western Punjab',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter() {
    final query = _searchController.text.trim();
    List<PunjabCity> results = Punjab81CitiesData.search(query);

    if (_selectedRegion != 'All') {
      results = results.where((c) => c.region == _selectedRegion).toList();
    }

    setState(() {
      _displayedCities = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explore Punjab Cities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text('Official Census 81 Cities Directory', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Region Filter Header
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF1E293B) : primaryColor,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search any city (e.g. Sialkot, Taxila, Multan)...',
                    hintStyle: const TextStyle(color: Colors.white60, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70),
                            onPressed: () {
                              _searchController.clear();
                              _filter();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.black.withValues(alpha: 0.18),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _regions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final reg = _regions[i];
                      final isSelected = reg == _selectedRegion;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedRegion = reg);
                          _filter();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.3),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                Icon(Icons.check, size: 14, color: isDark ? const Color(0xFF0F172A) : primaryColor),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                reg,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected
                                      ? (isDark ? const Color(0xFF0F172A) : primaryColor)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // City Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${_displayedCities.length} Cities in Punjab',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryTextColor, fontSize: 13),
                ),
                Text(
                  'Tap city to open guide',
                  style: TextStyle(fontSize: 11, color: secondaryTextColor),
                ),
              ],
            ),
          ),

          // Cities Grid / List
          Expanded(
            child: _displayedCities.isEmpty
                ? Center(
                    child: Text('No city found. Try a different search term.', style: TextStyle(color: secondaryTextColor)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: _displayedCities.length,
                    itemBuilder: (context, index) {
                      final city = _displayedCities[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: cardBg,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: cardBorder),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CityGuideScreen(city: city)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    city.coverImage,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 80,
                                      height: 80,
                                      color: isDark ? const Color(0xFF334155) : Colors.blueGrey.shade100,
                                      child: Icon(Icons.location_city, color: isDark ? Colors.white60 : Colors.blueGrey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              city.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: primaryTextColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: primaryColor.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              city.urduName,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        city.tagline,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, color: secondaryTextColor),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.people_alt_outlined, size: 13, color: secondaryTextColor),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Pop: ${(city.population2023 / 1000).toStringAsFixed(0)}k',
                                            style: TextStyle(fontSize: 11, color: secondaryTextColor),
                                          ),
                                          const SizedBox(width: 10),
                                          Icon(Icons.location_on_outlined, size: 13, color: secondaryTextColor),
                                          const SizedBox(width: 2),
                                          Text(
                                            city.district,
                                            style: TextStyle(fontSize: 11, color: secondaryTextColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: secondaryTextColor.withValues(alpha: 0.5)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
