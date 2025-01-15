// lib/screens/tabs/countries_tab.dart
import 'package:countriesmms/features/home_countries/presentation/controller/countries_provider.dart';
import 'package:countriesmms/features/home_countries/presentation/screens/home_screen.dart';
import 'package:countriesmms/features/home_countries/presentation/widgets/retry_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountriesTab extends GetView<CountryController> {
  const CountriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchBar(
              onChanged: (value) => controller.setSearchQuery(value),
              hintText: 'Search for a country',
              leading: const Icon(Icons.search, size: 30, color: Colors.grey)),
        ),
        Expanded(
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.countries.value == null) {
                return RetryWidget(onRetry: () {
                  controller.fetchCountries();
                });
              }

              if (controller.filteredCountries.isEmpty) {
                return const Center(child: Text('No countries found'));
              }

              return ListView(
                  children: controller.filteredCountries
                      .map((country) => CountryListItem(country: country!))
                      .toList());
            },
          ),
        ),
      ],
    );
  }
}
