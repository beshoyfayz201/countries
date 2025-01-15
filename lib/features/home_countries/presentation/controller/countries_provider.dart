import 'package:countriesmms/core/services/local%20storage/sql_helper.dart';
import 'package:countriesmms/features/home_countries/data/data_source/remote/countries_remote_ds.dart';
import 'package:countriesmms/features/home_countries/data/model/countries_list/countries_list.dart';
import 'package:get/get.dart';

class CountryController extends GetxController {
  Rxn<List<CountriesList>?> countries = Rxn<List<CountriesList>?>();
  final _searchQuery = ''.obs;
  final isLoading = false.obs;
  late DatabaseHelper databaseHelper;
  @override
  onInit() {
    databaseHelper = DatabaseHelper.instance;
    fetchCountries();

    super.onInit();
  }

  String get searchQuery => _searchQuery.value;

  List<CountriesList?> get filteredCountries {
    if (_searchQuery.value.isEmpty) return countries.value ?? [];
    return (countries.value ?? [])
        .where((country) => (country.name?.common ?? "")
            .toLowerCase()
            .contains(_searchQuery.value.toLowerCase()))
        .toList();
  }

  List<CountriesList> get favoriteCountries {
    return (countries.value ?? [])
        .where((country) => country.isFavorite == 1)
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  CountryRemoteDataSource countryRepo = CountryRemoteDataSource();
  Future<void> fetchCountries() async {
    countries.value = [];
    isLoading.value = true;

    try {
      var storedCountries = await databaseHelper.getCountries();
      final result = await countryRepo.fetchCountries();
      result.fold(
        (l) {
          Get.snackbar('Error', l);
          countries.value?.addAll(storedCountries);
        },
        (r) {
          countries.value = r;
          for (var storedCountry in storedCountries) {
            final index = (countries.value ?? []).indexWhere((country) =>
                country.name?.common == storedCountry.name?.common);
            if (index != -1) {
              countries.value?[index] = storedCountry;
            }
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(String countryName) {
    final index = (countries.value ?? [])
        .indexWhere((country) => country.name?.common == countryName);
    if (index != -1) {
      countries.value![index].isFavorite =
          countries.value![index].isFavorite == 0 ? 1 : 0;
      if (countries.value![index].isFavorite == 1) {
        databaseHelper.addCountry(countries.value![index]);
      } else {
        databaseHelper.removeCountry(countries.value![index].id!);
      }
    }
    update();
  }
}
