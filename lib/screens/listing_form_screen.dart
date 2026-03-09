import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:kigali_city_service_places/core/constants/listing_categories.dart';
import 'package:kigali_city_service_places/models/listing.dart';
import 'package:kigali_city_service_places/state/listing_provider.dart';

class ListingFormScreen extends StatefulWidget {
  const ListingFormScreen({super.key, this.existingListing});

  final Listing? existingListing;

  @override
  State<ListingFormScreen> createState() => _ListingFormScreenState();
}

class _ListingFormScreenState extends State<ListingFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Uuid _uuid = const Uuid();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _contactController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  late String _selectedCategory;

  bool get _isEditing => widget.existingListing != null;

  @override
  void initState() {
    super.initState();
    final Listing? existing = widget.existingListing;

    _nameController = TextEditingController(text: existing?.name ?? '');
    _addressController = TextEditingController(text: existing?.address ?? '');
    _contactController = TextEditingController(
      text: existing?.contactNumber ?? '',
    );
    _descriptionController = TextEditingController(
      text: existing?.description ?? '',
    );
    _latitudeController = TextEditingController(
      text: existing?.latitude.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: existing?.longitude.toString() ?? '',
    );
    _selectedCategory = existing?.category ?? listingCategories[1];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ListingProvider listingProvider = context.watch<ListingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Listing' : 'Create Listing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Place or Service Name',
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: listingCategories
                    .where((String category) => category != 'All')
                    .map(
                      (String category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (String? value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      validator: _coordinateValidator,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      validator: _coordinateValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (listingProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    listingProvider.errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: listingProvider.isBusy ? null : _submit,
                  child: listingProvider.isBusy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Save Changes' : 'Create Listing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _coordinateValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final double? parsed = double.tryParse(value.trim());
    if (parsed == null) {
      return 'Invalid number';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ListingProvider provider = context.read<ListingProvider>();
    provider.clearError();

    final Listing payload = Listing(
      id: widget.existingListing?.id ?? _uuid.v4(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      address: _addressController.text.trim(),
      contactNumber: _contactController.text.trim(),
      description: _descriptionController.text.trim(),
      latitude: double.parse(_latitudeController.text.trim()),
      longitude: double.parse(_longitudeController.text.trim()),
      createdBy: widget.existingListing?.createdBy ?? '',
      timestamp: widget.existingListing?.timestamp ?? DateTime.now(),
    );

    if (_isEditing) {
      await provider.updateListing(payload);
    } else {
      await provider.createListing(payload);
    }

    if (!mounted) {
      return;
    }

    if (provider.errorMessage == null) {
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    provider.clearError();
  }
}
