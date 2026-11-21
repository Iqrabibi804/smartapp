import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../services/admin_service.dart';

class AdminReviewsScreen extends ConsumerStatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  ConsumerState<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends ConsumerState<AdminReviewsScreen> {
  bool _reportedOnly = true;

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(adminReviewsProvider(_reportedOnly));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Moderation'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Reported Only'),
                  selected: _reportedOnly,
                  onSelected: (val) => setState(() => _reportedOnly = true),
                  selectedColor: AppColors.accentCoral.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('All Reviews'),
                  selected: !_reportedOnly,
                  onSelected: (val) => setState(() => _reportedOnly = false),
                  selectedColor: AppColors.primaryTeal.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
          Expanded(
            child: reviewsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Failed to load reviews: $err'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(adminReviewsProvider(_reportedOnly)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (reviews) {
                if (reviews.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _reportedOnly ? Icons.check_circle_outline : Icons.rate_review_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _reportedOnly
                              ? 'No reported reviews pending moderation!'
                              : 'No reviews found.',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final r = reviews[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    r.placeName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: r.status == 'reported'
                                        ? Colors.orange.withValues(alpha: 0.2)
                                        : r.status == 'rejected'
                                            ? Colors.red.withValues(alpha: 0.2)
                                            : Colors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    r.status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: r.status == 'reported'
                                          ? Colors.orange[800]
                                          : r.status == 'rejected'
                                              ? Colors.red[800]
                                              : Colors.green[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  'By ${r.userName}',
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: List.generate(
                                    5,
                                    (starIdx) => Icon(
                                      starIdx < r.rating ? Icons.star : Icons.star_border,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (r.comment.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                '"${r.comment}"',
                                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  label: const Text('Reject Review', style: TextStyle(color: Colors.red)),
                                  onPressed: () async {
                                    await ref
                                        .read(adminServiceProvider)
                                        .setReviewStatus(r.id, 'rejected');
                                    ref.invalidate(adminReviewsProvider(_reportedOnly));
                                    ref.invalidate(adminStatsProvider);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Review rejected')),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.check, color: Colors.white),
                                  label: const Text('Approve Review'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryTeal,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await ref
                                        .read(adminServiceProvider)
                                        .setReviewStatus(r.id, 'approved');
                                    ref.invalidate(adminReviewsProvider(_reportedOnly));
                                    ref.invalidate(adminStatsProvider);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Review approved')),
                                      );
                                    }
                                  },
                                ),
                              ],
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
