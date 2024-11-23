import 'package:app/home_page.dart';
import 'package:app/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pocketbase/pocketbase.dart';

final di = GetIt.instance;

void setup() {
  di.registerSingletonAsync<ConfigService>(() {
    return ConfigService.create('assets/config.yaml');
  });

  di.registerSingletonWithDependencies<PocketBase>(() {
    final apiEndpoint = di<ConfigService>()['apiEndpoint'];
    return PocketBase(apiEndpoint);
  }, dependsOn: [ConfigService]);
}

void main() {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

