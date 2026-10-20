import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary       = Color(0xFFFF7A00);
  static const Color primaryLight  = Color(0xFFFF9A40);
  static const Color primaryDark   = Color(0xFFCC6200);
  static const Color secondary     = Color(0xFF1C1C1E);
  static const Color background    = Color(0xFF0D0D0D);
  static const Color card          = Color(0xFF1A1A1A);
  static const Color white         = Colors.white;
  static const Color grey          = Color(0xFF9E9E9E);
  static const Color border        = Color(0xFF2C2C2E);
  static const Color danger        = Color(0xFFf44336);
  static const Color error         = Color(0xFFf44336);
  static const Color success       = Color(0xFF4CAF50);
  static const Color warning       = Color(0xFFFFB347);
  static const Color info          = Color(0xFF74B9FF);

  static const Color textDark           = Color(0xFFFFFFFF);
  static const Color textDarkSecondary  = Color(0xFF9E9E9E);
  static const Color textLight          = Color(0xFF1A1A1A);
  static const Color textLightSecondary = Color(0xFF6B6B8A);

  static const Color accent       = Color(0xFFFF6B6B);
  static const Color accentGreen  = Color(0xFF4ECDC4);
  static const Color accentOrange = Color(0xFFFF7A00);

  static const Color darkBg      = Color(0xFF0D0D0D);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkCard    = Color(0xFF1A1A1A);
  static const Color darkBorder  = Color(0xFF2C2C2E);

  static const Color lightBg      = Color(0xFFF5F5FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard    = Color(0xFFFAFAFF);
  static const Color lightBorder  = Color(0xFFE8E8F0);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF7A00), Color(0xFFCC6200)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF45B7D1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2C2C2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0D0D0D), Color(0xFF1A1A1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
