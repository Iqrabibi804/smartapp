import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../services/admin_service.dart';
import 'admin_businesses_screen.dart';
import 'admin_users_screen.dart';
import 'admin_reviews_screen.dart';
import 'admin_places_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(adminStatsProvider),
        child: statsAsync.when(
          data: (stats) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _StatCard(label: 'Total Users', value: stats.totalUsers, icon: Icons.people),
                  _StatCard(label: 'Active Users', value: stats.activeUsers, icon: Icons.person_outline),
                  _StatCard(label: 'Total Places', value: stats.totalPlaces, icon: Icons.place),
                  _StatCard(label: 'Total Events', value: stats.totalEvents, icon: Icons.event),
                  _StatCard(
                    label: 'Pending Businesses',
                    value: stats.pendingBusinesses,
                    icon: Icons.hourglass_top,
                    highlight: stats.pendingBusinesses > 0,
                  ),
                  _StatCard(
                    label: 'Verified Businesses',
                    value: stats.verifiedBusinesses,
                    icon: Icons.verified,
                  ),
                  _StatCard(label: 'Total Reviews', value: stats.totalReviews, icon: Icons.rate_review),
                  _StatCard(
                    label: 'Reported Reviews',
                    value: stats.reportedReviews,
                    icon: Icons.flag,
                    highlight: stats.reportedReviews > 0,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Manage System', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _ManageTile(
                icon: Icons.storefront_outlined,
                title: 'Business Verification',
                subtitle: '${stats.pendingBusinesses} pending application(s)',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminBusinessesScreen()),
                ),
              ),
              const SizedBox(height: 10),
              _ManageTile(
                icon: Icons.rate_review_outlined,
                title: 'Review Moderation',
                subtitle: '${stats.reportedReviews} reported review(s)',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminReviewsScreen()),
                ),
              ),
              const SizedBox(height: 10),
              _ManageTile(
                icon: Icons.place_outlined,
                title: 'Place Management',
                subtitle: 'Add, edit, verify or remove places',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminPlacesScreen()),
                ),
              ),
              const SizedBox(height: 10),
              _ManageTile(
                icon: Icons.people_outline,
                title: 'User Management',
                subtitle: 'View, suspend or reactivate users',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminUsersScreen()),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            children: const [
              SizedBox(height: 120),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Could not load dashboard.\nMake sure you are signed in as an admin.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final bool highlight;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? AppColors.accent.withValues(alpha: 0.1) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight ? AppColors.accent.withValues(alpha: 0.4) : Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: highlight ? AppColors.accent : AppColors.primary),
          const SizedBox(height: 8),
          Text('$value', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ManageTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManageTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }
}
