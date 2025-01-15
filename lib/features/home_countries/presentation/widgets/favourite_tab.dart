import 'package:countriesmms/features/home_countries/presentation/controller/countries_provider.dart';
import 'package:countriesmms/features/home_countries/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// lib/screens/tabs/favorites_tab.dart
class FavoritesTab extends GetView<CountryController> {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final favorites = controller.favoriteCountries;

        if (favorites.isEmpty) {
          return const Center(
            child: Text('No favorite countries yet'),
          );
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return CountryListItem(country: favorites[index]);
          },
        );
      },
    );
  }
}
