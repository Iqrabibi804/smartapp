import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_client.dart';
import '../../business/models/business_model.dart';
import '../services/admin_service.dart';

class AdminBusinessesScreen extends ConsumerStatefulWidget {
  const AdminBusinessesScreen({super.key});

  @override
  ConsumerState<AdminBusinessesScreen> createState() => _AdminBusinessesScreenState();
}

class _AdminBusinessesScreenState extends ConsumerState<AdminBusinessesScreen> {
  String? _statusFilter = 'pending';

  static const _filters = [
    ('pending', 'Pending'),
    ('verified', 'Verified'),
    ('rejected', 'Rejected'),
    (null, 'All'),
  ];

  Future<void> _updateStatus(BusinessModel business, String status) async {
    String? reason;

    if (status == 'rejected') {
      reason = await showDialog<String>(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: const Text('Reason for rejection'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Let the owner know why'),
              maxLines: 3,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text('Reject'),
              ),
            ],
          );
        },
      );
      if (reason == null) return;
    }

    try {
      await ref.read(adminServiceProvider).setBusinessStatus(business.id, status, reason: reason);
      ref.invalidate(adminBusinessesProvider(_statusFilter));
      ref.invalidate(adminStatsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${business.name} marked as $status.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(e))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessesAsync = ref.watch(adminBusinessesProvider(_statusFilter));

    return Scaffold(
      appBar: AppBar(title: const Text('Business Verification')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: _filters.map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f.$2),
                    selected: _statusFilter == f.$1,
                    onSelected: (_) => setState(() => _statusFilter = f.$1),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: businessesAsync.when(
              data: (businesses) {
                if (businesses.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No businesses in this category.'),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: businesses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _AdminBusinessCard(
                    business: businesses[i],
                    onApprove: () => _updateStatus(businesses[i], 'verified'),
                    onReject: () => _updateStatus(businesses[i], 'rejected'),
                    onSuspend: () => _updateStatus(businesses[i], 'suspended'),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Could not load businesses.')),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminBusinessCard extends StatelessWidget {
  final BusinessModel business;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onSuspend;

  const _AdminBusinessCard({
    required this.business,
    required this.onApprove,
    required this.onReject,
    required this.onSuspend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(business.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 2),
          Text(business.address, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          if (business.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(business.description, style: const TextStyle(fontSize: 13)),
          ],
          if (business.phone != null) ...[
            const SizedBox(height: 4),
            Text('Phone: ${business.phone}', style: const TextStyle(fontSize: 12)),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (business.status != 'verified')
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onApprove,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              if (business.status != 'verified') const SizedBox(width: 8),
              if (business.status == 'pending')
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Reject'),
                  ),
                ),
              if (business.status == 'verified')
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSuspend,
                    icon: const Icon(Icons.pause, size: 16),
                    label: const Text('Suspend'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
