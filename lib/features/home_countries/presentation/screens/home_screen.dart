// lib/providers/country_provider.dart
import 'package:countriesmms/features/home_countries/data/model/countries_list/countries_list.dart';
import 'package:countriesmms/features/home_countries/presentation/controller/countries_provider.dart';
import 'package:countriesmms/features/home_countries/presentation/widgets/coutries_tap.dart';
import 'package:countriesmms/features/home_countries/presentation/widgets/favourite_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// lib/screens/home_screen.dart
class HomeScreen extends GetView<CountryController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Countries'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Countries'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : const TabBarView(
                  children: [
                    CountriesTab(),
                    FavoritesTab(),
                  ],
                ),
        ),
      ),
    );
  }
}

// lib/widgets/search_bar.dart

// lib/widgets/country_list_item.dart
class CountryListItem extends GetView<CountryController> {
  final CountriesList country;

  const CountryListItem({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          child: Image.network(
            country.flagImg ?? "",
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.flag),
          ),
        ),
        title: Text(country.name?.common ?? ""),
        subtitle: Text(country.capital ?? ""),
        trailing: GetBuilder<CountryController>(
          builder: (z) => IconButton(
            icon: Icon(
              country.isFavorite == 1 ? Icons.favorite : Icons.favorite_border,
              color: country.isFavorite == 1 ? Colors.red : null,
            ),
            onPressed: () {
              controller.toggleFavorite(country.name?.common ?? '');
            },
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CountryDetailsScreen(country: country),
            ),
          );
        },
      ),
    );
  }
}

// lib/screens/country_details_screen.dart
class CountryDetailsScreen extends GetView<CountryController> {
  final CountriesList country;

  const CountryDetailsScreen({
    super.key,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name?.common ?? ''),
        actions: [
          GetBuilder<CountryController>(
            builder: (x) {
              return IconButton(
                icon: Icon(
                  country.isFavorite == 1
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: country.isFavorite == 1 ? Colors.red : null,
                ),
                onPressed: () {
                  controller.toggleFavorite(country.name?.common ?? '');
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                country.flagImg ?? "",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem('Capital', country.capital ?? ""),
                  _buildDetailItem('Population',
                      '${(int.tryParse(country.population ?? "") ?? 0 / 1000000).toStringAsFixed(1)}M'),
                  _buildDetailItem('Languages', (country.languages ?? "")),
                  _buildDetailItem('Currencies', (country.currencies ?? '')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
