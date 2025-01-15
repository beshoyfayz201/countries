
import 'package:countriesmms/features/home_countries/presentation/controller/countries_provider.dart';
import 'package:countriesmms/features/home_countries/presentation/screens/home_screen.dart';
import 'package:countriesmms/routes/routes.dart';
import 'package:get/get.dart';

appPages() => [
      // onboarding
      GetPage(
        name: Routes.home,
        page: () => const HomeScreen(),
        binding:BindingsBuilder(
          () {
          Get.lazyPut(() => CountryController());
        }) ,
      ),
      
];