import 'package:flutter/material.dart';
import 'package:kigali_city_service_places/models/listing.dart';
import 'dart:math' as math;

class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    this.trailing,
  });

  final Listing listing;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  image: listing.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(listing.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: listing.imageUrl == null
                    ? Icon(
                        Icons.place_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      listing.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          listing.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          listing.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        if (listing.latitude != 0)
                          Text(
                            _calculateDistance(listing),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
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

  String _calculateDistance(Listing listing) {
    // Mock user location (Kigali Center)
    const double userLat = -1.9441;
    const double userLng = 30.0619;

    // Haversine formula approximation
    const double p = 0.017453292519943295;
    final double a =
        0.5 -
        math.cos((listing.latitude - userLat) * p) / 2 +
        math.cos(userLat * p) *
            math.cos(listing.latitude * p) *
            (1 - math.cos((listing.longitude - userLng) * p)) /
            2;
    final double distance = 12742 * math.asin(math.sqrt(a));

    return '${distance.toStringAsFixed(1)} km';
  }
}
