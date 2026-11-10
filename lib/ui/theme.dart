import 'package:flutter/material.dart';

// Calm palette: deep indigo + warm parchment. Contrast checked against M3 defaults (≥ 4.5:1 for body text).
const _seed = Color(0xFF4B3F72);

ThemeData buildTheme(Brightness b) {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: b);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: b == Brightness.light
        ? const Color(0xFFF8F5EF)
        : scheme.surface,
    cardTheme: const CardThemeData(
      margin: EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
    ),
    textTheme: Typography.material2021(platform: TargetPlatform.android).black
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
  );
}
