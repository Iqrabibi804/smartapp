import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../places/screens/place_details_screen.dart';
import '../models/trip_model.dart';

class TripDetailsScreen extends StatefulWidget {
  final TripModel trip;
  const TripDetailsScreen({super.key, required this.trip});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  int _selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;

    return Scaffold(
      appBar: AppBar(title: Text('${trip.destination} — ${trip.days}d trip')),
      body: Column(
        children: [
          _BudgetSummary(trip: trip),
          if (trip.itinerary.length > 1)
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: trip.itinerary.length,
                itemBuilder: (context, i) {
                  final selected = i == _selectedDay;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('Day ${trip.itinerary[i].day}'),
                      selected: selected,
                      selectedColor: const Color(0xFF059669),
                      backgroundColor: const Color(0xFFF1F5F9),
                      side: BorderSide(color: selected ? const Color(0xFF059669) : const Color(0xFFCBD5E1)),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : const Color(0xFF1E293B),
                        fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _selectedDay = i),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: trip.itinerary.isEmpty
                ? const Center(child: Text('No itinerary generated.'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trip.itinerary[_selectedDay].places.length,
              itemBuilder: (context, i) {
                final place = trip.itinerary[_selectedDay].places[i];
                return _ItineraryStop(
                  timeSlot: place.timeSlot,
                  name: place.name,
                  placeId: place.placeId,
                  isLast: i == trip.itinerary[_selectedDay].places.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetSummary extends StatelessWidget {
  final TripModel trip;
  const _BudgetSummary({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: trip.overBudget ? AppColors.error.withValues(alpha: 0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: trip.overBudget ? AppColors.error.withValues(alpha: 0.4) : Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated cost', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text('Rs. ${trip.estimatedCost.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          if (trip.budget > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your budget', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                Text('Rs. ${trip.budget.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13)),
              ],
            ),
            if (trip.overBudget) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.warning_amber, size: 16, color: AppColors.error),
                  const SizedBox(width: 6),
                  Text(
                    'Over budget by Rs. ${(trip.estimatedCost - trip.budget).toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'Rs. ${(trip.budget - trip.estimatedCost).toStringAsFixed(0)} remaining',
                    style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ],
          const SizedBox(height: 4),
          const Text(
            'Estimate only — actual costs may vary.',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ItineraryStop extends StatelessWidget {
  final String timeSlot;
  final String name;
  final String? placeId;
  final bool isLast;

  const _ItineraryStop({
    required this.timeSlot,
    required this.name,
    required this.placeId,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.black12)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: placeId == null
                    ? null
                    : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PlaceDetailsScreen(placeId: placeId!)),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(timeSlot,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 2),
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
