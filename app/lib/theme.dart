import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4286402173),
      surfaceTint: Color(4286402173),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4294956794),
      onPrimaryContainer: Color(4281469237),
      secondary: Color(4285290602),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294302704),
      onSecondaryContainer: Color(4280686117),
      tertiary: Color(4286730824),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4294957779),
      onTertiaryContainer: Color(4281536778),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294965242),
      onSurface: Color(4280228383),
      onSurfaceVariant: Color(4283253836),
      outline: Color(4286542972),
      outlineVariant: Color(4291871692),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281675316),
      inversePrimary: Color(4293768426),
      primaryFixed: Color(4294956794),
      onPrimaryFixed: Color(4281469237),
      primaryFixedDim: Color(4293768426),
      onPrimaryFixedVariant: Color(4284692068),
      secondaryFixed: Color(4294302704),
      onSecondaryFixed: Color(4280686117),
      secondaryFixedDim: Color(4292394964),
      onSecondaryFixedVariant: Color(4283646290),
      tertiaryFixed: Color(4294957779),
      onTertiaryFixed: Color(4281536778),
      tertiaryFixedDim: Color(4294359211),
      onTertiaryFixedVariant: Color(4284955442),
      surfaceDim: Color(4293056478),
      surfaceBright: Color(4294965242),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294766839),
      surfaceContainer: Color(4294437873),
      surfaceContainerHigh: Color(4294043116),
      surfaceContainerHighest: Color(4293648358),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4284428896),
      surfaceTint: Color(4286402173),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287980692),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4283383118),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4286803585),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4284626734),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288374877),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965242),
      onSurface: Color(4280228383),
      onSurfaceVariant: Color(4282990664),
      outline: Color(4284898404),
      outlineVariant: Color(4286805888),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281675316),
      inversePrimary: Color(4293768426),
      primaryFixed: Color(4287980692),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4286204795),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4286803585),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4285159016),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4288374877),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4286533702),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293056478),
      surfaceBright: Color(4294965242),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294766839),
      surfaceContainer: Color(4294437873),
      surfaceContainerHigh: Color(4294043116),
      surfaceContainerHighest: Color(4293648358),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4281995581),
      surfaceTint: Color(4286402173),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4284428896),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281146668),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4283383118),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282062864),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284626734),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965242),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280885800),
      outline: Color(4282990664),
      outlineVariant: Color(4282990664),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281675316),
      inversePrimary: Color(4294960378),
      primaryFixed: Color(4284428896),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4282784840),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4283383118),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281870135),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4284626734),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282917402),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293056478),
      surfaceBright: Color(4294965242),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294766839),
      surfaceContainer: Color(4294437873),
      surfaceContainerHigh: Color(4294043116),
      surfaceContainerHighest: Color(4293648358),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293768426),
      surfaceTint: Color(4293768426),
      onPrimary: Color(4283048012),
      primaryContainer: Color(4284692068),
      onPrimaryContainer: Color(4294956794),
      secondary: Color(4292394964),
      onSecondary: Color(4282133307),
      secondaryContainer: Color(4283646290),
      onSecondaryContainer: Color(4294302704),
      tertiary: Color(4294359211),
      onTertiary: Color(4283180573),
      tertiaryContainer: Color(4284955442),
      onTertiaryContainer: Color(4294957779),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279702038),
      onSurface: Color(4293648358),
      onSurfaceVariant: Color(4291871692),
      outline: Color(4288253334),
      outlineVariant: Color(4283253836),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293648358),
      inversePrimary: Color(4286402173),
      primaryFixed: Color(4294956794),
      onPrimaryFixed: Color(4281469237),
      primaryFixedDim: Color(4293768426),
      onPrimaryFixedVariant: Color(4284692068),
      secondaryFixed: Color(4294302704),
      onSecondaryFixed: Color(4280686117),
      secondaryFixedDim: Color(4292394964),
      onSecondaryFixedVariant: Color(4283646290),
      tertiaryFixed: Color(4294957779),
      onTertiaryFixed: Color(4281536778),
      tertiaryFixedDim: Color(4294359211),
      onTertiaryFixedVariant: Color(4284955442),
      surfaceDim: Color(4279702038),
      surfaceBright: Color(4282267452),
      surfaceContainerLowest: Color(4279373073),
      surfaceContainerLow: Color(4280228383),
      surfaceContainer: Color(4280557091),
      surfaceContainerHigh: Color(4281215021),
      surfaceContainerHighest: Color(4281938744),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294097135),
      surfaceTint: Color(4293768426),
      onPrimary: Color(4281074480),
      primaryContainer: Color(4290019250),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4292723672),
      onSecondary: Color(4280291616),
      secondaryContainer: Color(4288776861),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294622383),
      onTertiary: Color(4281076742),
      tertiaryContainer: Color(4290413432),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279702038),
      onSurface: Color(4294965754),
      onSurfaceVariant: Color(4292200400),
      outline: Color(4289503144),
      outlineVariant: Color(4287332488),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293648358),
      inversePrimary: Color(4284757861),
      primaryFixed: Color(4294956794),
      onPrimaryFixed: Color(4280614954),
      primaryFixedDim: Color(4293768426),
      onPrimaryFixedVariant: Color(4283442770),
      secondaryFixed: Color(4294302704),
      onSecondaryFixed: Color(4279897115),
      secondaryFixedDim: Color(4292394964),
      onSecondaryFixedVariant: Color(4282528065),
      tertiaryFixed: Color(4294957779),
      onTertiaryFixed: Color(4280616707),
      tertiaryFixedDim: Color(4294359211),
      onTertiaryFixedVariant: Color(4283640611),
      surfaceDim: Color(4279702038),
      surfaceBright: Color(4282267452),
      surfaceContainerLowest: Color(4279373073),
      surfaceContainerLow: Color(4280228383),
      surfaceContainer: Color(4280557091),
      surfaceContainerHigh: Color(4281215021),
      surfaceContainerHighest: Color(4281938744),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294965754),
      surfaceTint: Color(4293768426),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294097135),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965754),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4292723672),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965752),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294622383),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279702038),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965754),
      outline: Color(4292200400),
      outlineVariant: Color(4292200400),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293648358),
      inversePrimary: Color(4282587461),
      primaryFixed: Color(4294958586),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294097135),
      onPrimaryFixedVariant: Color(4281074480),
      secondaryFixed: Color(4294631413),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4292723672),
      onSecondaryFixedVariant: Color(4280291616),
      tertiaryFixed: Color(4294959322),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294622383),
      onTertiaryFixedVariant: Color(4281076742),
      surfaceDim: Color(4279702038),
      surfaceBright: Color(4282267452),
      surfaceContainerLowest: Color(4279373073),
      surfaceContainerLow: Color(4280228383),
      surfaceContainer: Color(4280557091),
      surfaceContainerHigh: Color(4281215021),
      surfaceContainerHighest: Color(4281938744),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
