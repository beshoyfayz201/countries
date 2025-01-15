import 'package:countriesmms/core/services/local%20storage/sql_helper.dart';
import 'package:countriesmms/routes/app_pages.dart';
import 'package:countriesmms/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.instance;

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Countries App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      getPages: appPages(),
      initialRoute: Routes.home,
    );
  }
}
