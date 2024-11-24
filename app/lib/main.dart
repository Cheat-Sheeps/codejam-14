import 'package:app/pages/home_page.dart';
import 'package:app/services/config_service.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
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

void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await di.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MaterialTheme(createTextTheme(context, "Roboto", "Ubuntu")).lightMediumContrast(),
      darkTheme: MaterialTheme(createTextTheme(context, "Roboto", "Ubuntu")).darkMediumContrast(),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


TextTheme createTextTheme(
    BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme =
      GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}