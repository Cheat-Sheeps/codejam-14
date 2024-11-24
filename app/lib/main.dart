import 'package:app/pages/login_page.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/config_service.dart';
import 'package:app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocketbase/pocketbase.dart';

final di = GetIt.instance;

Future<void> setup() async {
  di.registerSingletonAsync<ConfigService>(() async {
    final service = await ConfigService.create('assets/config.yaml');
    Stripe.publishableKey = service['stripePublishableKey'];
    await Stripe.instance.applySettings();
    return service;
  });

  di.registerSingletonWithDependencies<PocketBase>(() {
    final apiEndpoint = di<ConfigService>()['apiEndpoint'];
    return PocketBase(apiEndpoint);
  }, dependsOn: [ConfigService]);

  di.registerSingletonWithDependencies<AuthService>(() {
    return AuthService();
  }, dependsOn: [PocketBase]);

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
      title: 'LiveJam',
      theme: MaterialTheme(createTextTheme(context, "Ubuntu", "Oswald")).lightMediumContrast(),
      darkTheme: MaterialTheme(createTextTheme(context, "Ubuntu", "Oswald")).darkMediumContrast(),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}

TextTheme createTextTheme(BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(displayFontString, baseTextTheme);
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
