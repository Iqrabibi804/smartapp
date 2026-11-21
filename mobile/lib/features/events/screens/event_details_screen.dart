import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../models/event_model.dart';
import '../services/events_service.dart';

const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailsProvider(eventId));

    return Scaffold(
      appBar: AppBar(),
      body: eventAsync.when(
        data: (event) => _EventDetailsContent(event: event),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load this event.')),
      ),
    );
  }
}

class _EventDetailsContent extends StatelessWidget {
  final EventModel event;
  const _EventDetailsContent({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateLabel = '${event.date.day} ${_months[event.date.month - 1]} ${event.date.year}';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(Icons.event, size: 48, color: AppColors.accent),
          ),
        ),
        const SizedBox(height: 20),
        Text(event.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _DetailRow(icon: Icons.calendar_today, label: dateLabel),
        _DetailRow(icon: Icons.access_time, label: '${event.startTime} – ${event.endTime}'),
        _DetailRow(icon: Icons.location_on_outlined, label: event.address),
        if (event.organizer.isNotEmpty)
          _DetailRow(icon: Icons.groups_outlined, label: 'Organized by ${event.organizer}'),
        _DetailRow(icon: Icons.confirmation_number_outlined, label: event.ticketInfo),
        if (event.description.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(event.description, style: const TextStyle(height: 1.4)),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
