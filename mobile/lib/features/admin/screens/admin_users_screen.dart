import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_client.dart';
import '../services/admin_service.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  Future<void> _toggleStatus(BuildContext context, WidgetRef ref, AdminUser user) async {
    final newStatus = user.accountStatus == 'active' ? 'suspended' : 'active';
    try {
      await ref.read(adminServiceProvider).setUserStatus(user.id, newStatus);
      ref.invalidate(adminUsersProvider);
      ref.invalidate(adminStatsProvider);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.name} is now $newStatus.')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: usersAsync.when(
        data: (users) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(adminUsersProvider),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final user = users[i];
              final suspended = user.accountStatus == 'suspended';
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(user.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              ),
                              if (user.role == 'admin')
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('Admin',
                                      style: TextStyle(fontSize: 10, color: AppColors.primary)),
                                ),
                            ],
                          ),
                          Text(user.email,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          if (suspended)
                            const Text('Suspended',
                                style: TextStyle(fontSize: 11, color: AppColors.error, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: suspended ? 'Reactivate' : 'Suspend',
                      icon: Icon(
                        suspended ? Icons.play_circle_outline : Icons.block,
                        color: suspended ? AppColors.success : AppColors.error,
                        size: 20,
                      ),
                      onPressed: () => _toggleStatus(context, ref, user),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load users.')),
      ),
    );
  }
}
