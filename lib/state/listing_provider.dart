import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/repositories/listing_repository.dart';

class ListingProvider extends ChangeNotifier {
  ListingProvider({required ListingRepository listingRepository})
    : _listingRepository = listingRepository {
    _subscription = _listingRepository.watchListings().listen((
      List<Listing> data,
    ) {
      _allListings
        ..clear()
        ..addAll(data);
      notifyListeners();
    });
    _loadBookmarks();
  }

  final ListingRepository _listingRepository;
  StreamSubscription<List<Listing>>? _subscription;

  final List<Listing> _allListings = <Listing>[];
  final Set<String> _bookmarkedIds = <String>{};
  String _searchQuery = '';
  String _categoryFilter = 'All';
  String? _currentUserId;
  bool _isBusy = false;
  String? _errorMessage;

  List<Listing> get allListings => List<Listing>.unmodifiable(_allListings);
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get categoryFilter => _categoryFilter;
  String? get currentUserId => _currentUserId;
  List<Listing> get bookmarkedListings {
    return _allListings
        .where((Listing listing) => _bookmarkedIds.contains(listing.id))
        .toList(growable: false);
  }

  bool isBookmarked(String id) => _bookmarkedIds.contains(id);

  Future<void> _loadBookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarks = prefs.getStringList('bookmarks');
    if (bookmarks != null) {
      _bookmarkedIds.addAll(bookmarks);
      notifyListeners();
    }
  }

  Future<void> toggleBookmark(String id) async {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', _bookmarkedIds.toList());
  }

  List<Listing> get filteredListings {
    final String normalizedQuery = _searchQuery.toLowerCase();

    return _allListings
        .where((Listing listing) {
          final bool categoryMatches =
              _categoryFilter == 'All' || listing.category == _categoryFilter;
          final bool queryMatches =
              normalizedQuery.isEmpty ||
              listing.name.toLowerCase().contains(normalizedQuery) ||
              listing.address.toLowerCase().contains(normalizedQuery) ||
              listing.category.toLowerCase().contains(normalizedQuery) ||
              listing.description.toLowerCase().contains(normalizedQuery);
          return categoryMatches && queryMatches;
        })
        .toList(growable: false);
  }

  List<Listing> get myListings {
    if (_currentUserId == null) {
      return const <Listing>[];
    }
    return _allListings
        .where((Listing listing) => listing.createdBy == _currentUserId)
        .toList(growable: false);
  }

  void bindUser(String? uid) {
    _currentUserId = uid;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _categoryFilter = category;
    notifyListeners();
  }

  Future<void> createListing(Listing listing) async {
    if (_currentUserId == null) {
      _setError('Please login first.');
      return;
    }

    final Listing enriched = listing.copyWith(createdBy: _currentUserId);
    await _perform(() => _listingRepository.createListing(enriched));
  }

  Future<void> updateListing(Listing listing) async {
    if (_currentUserId == null) {
      _setError('Please login first.');
      return;
    }

    await _perform(
      () => _listingRepository.updateListing(
        listing,
        requesterUid: _currentUserId!,
      ),
    );
  }

  Future<void> deleteListing(String listingId) async {
    if (_currentUserId == null) {
      _setError('Please login first.');
      return;
    }

    await _perform(
      () => _listingRepository.deleteListing(
        listingId,
        requesterUid: _currentUserId!,
      ),
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _perform(Future<void> Function() action) async {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
    } catch (error) {
      _setError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  void _setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
