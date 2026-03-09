import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/screens/listing_detail_screen.dart';
import 'package:kigali_city_service_places/state/listing_provider.dart';
import 'package:kigali_city_service_places/widgets/listing_card.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ListingProvider listingProvider = context.watch<ListingProvider>();
    final List<Listing> bookmarks = listingProvider.bookmarkedListings;

    if (bookmarks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No bookmarks yet. Tap the bookmark icon on a listing to save it here.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: bookmarks.length,
      itemBuilder: (BuildContext context, int index) {
        final Listing listing = bookmarks[index];

        return ListingCard(
          listing: listing,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ListingDetailScreen(listing: listing),
              ),
            );
          },
          trailing: IconButton(
            icon: const Icon(Icons.bookmark_remove_outlined),
            onPressed: () {
              listingProvider.toggleBookmark(listing.id);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Removed from bookmarks')),
              );
            },
          ),
        );
      },
    );
  }
}
