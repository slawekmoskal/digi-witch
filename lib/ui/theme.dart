import 'package:flutter/material.dart';

// Palette from the app icon: deep indigo + warm parchment, gold as the accent.
// Body text keeps the platform font for legibility; headings and numbers use
// Cormorant Garamond (OFL, assets/fonts) for the "old card" feel.
const indigo = Color(0xFF4B3F72);
const gold = Color(0xFFC9A44C);
const parchment = Color(0xFFF3E9D2);
const serif = 'Cormorant';

TextStyle? _serif(TextStyle? s, double size) => s?.copyWith(
  fontFamily: serif,
  fontSize: size,
  fontWeight: FontWeight.w600,
  fontVariations: const [FontVariation.weight(600)], // variable font axis
  fontFeatures: const [FontFeature.liningFigures()], // even-height digits

  height: 1.15,
);

ThemeData buildTheme(Brightness b) {
  final light = b == Brightness.light;
  final scheme = ColorScheme.fromSeed(seedColor: indigo, brightness: b)
      .copyWith(
        primary: light ? indigo : const Color(0xFFD3C8F5),
        onPrimary: light ? const Color(0xFFFFF8EC) : const Color(0xFF241D42),
        secondary: light ? const Color(0xFF8A6A1F) : const Color(0xFFE6C77F),
        tertiary: gold,
        surface: light ? const Color(0xFFFFFBF3) : const Color(0xFF1F1B36),
        surfaceContainerLow: light
            ? const Color(0xFFF8F1E2)
            : const Color(0xFF262142),
        surfaceContainerHighest: light
            ? const Color(0xFFEFE4CB)
            : const Color(0xFF332D55),
        outlineVariant: light
            ? const Color(0xFFE2D5B5)
            : const Color(0xFF4A4370),
      );
  final base =
      (light
              ? Typography.material2021().black
              : Typography.material2021().white)
          .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);
  final text = base.copyWith(
    displayLarge: _serif(base.displayLarge, 60),
    displayMedium: _serif(base.displayMedium, 48),
    displaySmall: _serif(base.displaySmall, 40),
    headlineLarge: _serif(base.headlineLarge, 36),
    headlineMedium: _serif(base.headlineMedium, 31),
    headlineSmall: _serif(base.headlineSmall, 27),
    titleLarge: _serif(base.titleLarge, 25),
    titleMedium: _serif(base.titleMedium, 21),
    bodyLarge: base.bodyLarge?.copyWith(height: 1.45),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: 15, height: 1.45),
  );
  final radius = BorderRadius.circular(20);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    textTheme: text,
    scaffoldBackgroundColor: light
        ? const Color(0xFFF6F0E3)
        : const Color(0xFF15122A),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: text.headlineSmall?.copyWith(color: scheme.onSurface),
    ),
    cardTheme: CardThemeData(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: scheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide(color: scheme.outlineVariant),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
      collapsedShape: Border(),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
    ),
  );
}
