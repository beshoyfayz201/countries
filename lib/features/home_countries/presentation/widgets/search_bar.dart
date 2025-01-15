import 'package:countriesmms/features/home_countries/presentation/controller/countries_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBar extends GetView<CountryController> {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search countries...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.grey.shade100,
          filled: true,
        ),
        onChanged: (value) {
          controller.setSearchQuery(value);
        },
      ),
    );
  }
}
