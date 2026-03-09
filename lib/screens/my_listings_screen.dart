import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/screens/listing_detail_screen.dart';
import 'package:kigali_city_service_places/screens/listing_form_screen.dart';
import 'package:kigali_city_service_places/state/listing_provider.dart';
import 'package:kigali_city_service_places/widgets/listing_card.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ListingProvider listingProvider = context.watch<ListingProvider>();
    final List<Listing> myListings = listingProvider.myListings;

    if (myListings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'You have no listings yet. Tap "Add Listing" to create one.',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: myListings.length,
      itemBuilder: (BuildContext context, int index) {
        final Listing listing = myListings[index];

        return ListingCard(
          listing: listing,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ListingDetailScreen(listing: listing),
              ),
            );
          },
          trailing: PopupMenuButton<String>(
            onSelected: (String value) =>
                _onAction(context, listingProvider, listing, value),
            itemBuilder: (_) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
              PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onAction(
    BuildContext context,
    ListingProvider listingProvider,
    Listing listing,
    String value,
  ) async {
    if (value == 'edit') {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ListingFormScreen(existingListing: listing),
        ),
      );
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Listing'),
          content: Text(
            'Delete "${listing.name}"? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await listingProvider.deleteListing(listing.id);
    if (!context.mounted) {
      return;
    }

    if (listingProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(listingProvider.errorMessage!)));
      listingProvider.clearError();
    }
  }
}
