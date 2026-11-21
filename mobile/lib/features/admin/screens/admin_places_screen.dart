import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../places/models/place_model.dart';
import '../services/admin_service.dart';

class AdminPlacesScreen extends ConsumerStatefulWidget {
  const AdminPlacesScreen({super.key});

  @override
  ConsumerState<AdminPlacesScreen> createState() => _AdminPlacesScreenState();
}

class _AdminPlacesScreenState extends ConsumerState<AdminPlacesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEditPlaceDialog(PlaceModel place) {
    final nameCtrl = TextEditingController(text: place.name);
    final descCtrl = TextEditingController(text: place.description);
    final addressCtrl = TextEditingController(text: place.address);
    final phoneCtrl = TextEditingController(text: place.phone ?? '');
    final websiteCtrl = TextEditingController(text: place.website ?? '');
    bool isVerified = place.verified;
    bool isFeatured = place.featured;
    String priceRange = place.priceRange;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text('Edit Place: ${place.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Place Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: addressCtrl,
                      decoration: const InputDecoration(labelText: 'Address'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: websiteCtrl,
                      decoration: const InputDecoration(labelText: 'Website URL'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: priceRange,
                      decoration: const InputDecoration(labelText: 'Price Range'),
                      items: const [
                        DropdownMenuItem(value: 'free', child: Text('Free')),
                        DropdownMenuItem(value: 'low', child: Text('Low (\$)')),
                        DropdownMenuItem(value: 'medium', child: Text('Medium (\$\$)')),
                        DropdownMenuItem(value: 'high', child: Text('High (\$\$\$)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => priceRange = val);
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Verified'),
                      value: isVerified,
                      onChanged: (val) => setDialogState(() => isVerified = val),
                    ),
                    SwitchListTile(
                      title: const Text('Featured Place'),
                      value: isFeatured,
                      onChanged: (val) => setDialogState(() => isFeatured = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final data = {
                      'name': nameCtrl.text.trim(),
                      'description': descCtrl.text.trim(),
                      'address': addressCtrl.text.trim(),
                      'phone': phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
                      'website': websiteCtrl.text.trim().isEmpty ? null : websiteCtrl.text.trim(),
                      'priceRange': priceRange,
                      'verified': isVerified,
                      'featured': isFeatured,
                    };
                    await ref.read(adminServiceProvider).updatePlace(place.id, data);
                    ref.invalidate(adminPlacesProvider({'query': _searchQuery}));
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Place updated successfully')),
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeletePlace(PlaceModel place) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Place'),
        content: Text('Are you sure you want to delete "${place.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await ref.read(adminServiceProvider).deletePlace(place.id);
              ref.invalidate(adminPlacesProvider({'query': _searchQuery}));
              ref.invalidate(adminStatsProvider);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Place deleted')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = {'query': _searchQuery};
    final placesAsync = ref.watch(adminPlacesProvider(filter));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Management'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search places by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
            ),
          ),
          Expanded(
            child: placesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Failed to load places: $err'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(adminPlacesProvider(filter)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (places) {
                if (places.isEmpty) {
                  return const Center(
                    child: Text('No places found matching your search.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final p = places[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.black12),
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                p.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (p.featured)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'FEATURED',
                                  style: TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold),
                                ),
                              ),
                            Icon(
                              p.verified ? Icons.verified : Icons.error_outline,
                              color: p.verified ? AppColors.primaryTeal : Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${p.address}\n${p.reviewCount > 0 ? 'Rating: ${p.rating}★ (${p.reviewCount} reviews)' : 'No reviews yet'}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.primaryTeal),
                              onPressed: () => _showEditPlaceDialog(p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDeletePlace(p),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
