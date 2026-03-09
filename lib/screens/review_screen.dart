import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/models/review.dart';
import 'package:kigali_city_service_places/state/listing_provider.dart';
import 'package:kigali_city_service_places/state/review_provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();

  String? _selectedListingId;
  int _rating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ListingProvider listingProvider = context.watch<ListingProvider>();
    final ReviewProvider reviewProvider = context.watch<ReviewProvider>();

    final List<Listing> listings = listingProvider.allListings;
    final List<Review> reviews = reviewProvider.reviews;

    if (listings.isNotEmpty && _selectedListingId == null) {
      _selectedListingId = listings.first.id;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add Review',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                if (listings.isEmpty)
                  const Text('No listings available to review yet.')
                else
                  DropdownButtonFormField<String>(
                    initialValue: _selectedListingId,
                    decoration: const InputDecoration(
                      labelText: 'Select place',
                    ),
                    items: listings
                        .map(
                          (Listing listing) => DropdownMenuItem<String>(
                            value: listing.id,
                            child: Text(listing.name),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedListingId = value;
                      });
                    },
                  ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: _rating,
                  decoration: const InputDecoration(labelText: 'Rating'),
                  items: List<int>.generate(5, (int i) => i + 1)
                      .map(
                        (int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value Star${value == 1 ? '' : 's'}'),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (int? value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _rating = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Comment'),
                  validator: (String? value) {
                    if (value == null || value.trim().length < 5) {
                      return 'Write at least 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                if (reviewProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      reviewProvider.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: reviewProvider.isSubmitting || listings.isEmpty
                        ? null
                        : () => _submit(context, listings),
                    child: reviewProvider.isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Submit Review'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Recent Reviews',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('No reviews yet. Be the first to write one.'),
          )
        else
          ...reviews.map((Review review) => _ReviewTile(review: review)),
      ],
    );
  }

  Future<void> _submit(BuildContext context, List<Listing> listings) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String? listingId = _selectedListingId;
    if (listingId == null) {
      return;
    }

    final Listing selected = listings.firstWhere(
      (Listing item) => item.id == listingId,
      orElse: () => listings.first,
    );

    final ReviewProvider reviewProvider = context.read<ReviewProvider>();
    reviewProvider.clearError();

    await reviewProvider.submitReview(
      listingId: selected.id,
      listingName: selected.name,
      rating: _rating,
      comment: _commentController.text,
    );

    if (!mounted) {
      return;
    }

    if (reviewProvider.errorMessage == null) {
      _commentController.clear();
      setState(() {
        _rating = 5;
      });
    }
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    review.listingName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text('${review.rating}/5'),
              ],
            ),
            const SizedBox(height: 6),
            Text(review.comment),
            const SizedBox(height: 8),
            Text(
              '${review.createdByName} · ${DateFormat('dd MMM yyyy, HH:mm').format(review.timestamp)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
