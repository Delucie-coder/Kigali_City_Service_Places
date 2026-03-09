import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/core/constants/listing_categories.dart';
import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/screens/listing_detail_screen.dart';
import 'package:kigali_city_service_places/state/listing_provider.dart';
import 'package:kigali_city_service_places/widgets/listing_card.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ListingProvider listingProvider = context.watch<ListingProvider>();
    final List<Listing> listings = listingProvider.filteredListings;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            onChanged: listingProvider.setSearchQuery,
            decoration: const InputDecoration(
              hintText: 'Search services and places',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: listingCategories.length,
            itemBuilder: (BuildContext context, int index) {
              final String category = listingCategories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(category),
                  selected: listingProvider.categoryFilter == category,
                  onSelected: (_) =>
                      listingProvider.setCategoryFilter(category),
                ),
              );
            },
          ),
        ),
        if (listingProvider.errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              listingProvider.errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        Expanded(
          child: listings.isEmpty
              ? const Center(child: Text('No listings found.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  itemCount: listings.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Listing listing = listings[index];
                    return ListingCard(
                      listing: listing,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ListingDetailScreen(listing: listing),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
