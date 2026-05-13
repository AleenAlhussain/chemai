import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────────────────────
// AppColors — all properties are static getters backed by `isDark`.
// Set `AppColors.isDark` before triggering a rebuild to switch palettes.
// ──────────────────────────────────────────────────────────────────────────────
abstract final class AppColors {
  static bool isDark = true;

  // ── Semantic constants (theme-invariant) ───────────────────────────────────
  static const amber  = Color(0xFFFBBF24); // level / achievement gold
  static const danger = Color(0xFFEF4444); // destructive actions
  static const warning = Color(0xFFFBBF24);

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static Color get bgDeep    => isDark ? const Color(0xFF070A1C) : const Color(0xFFDDE1FF);
  static Color get bgBase    => isDark ? const Color(0xFF0C0F2A) : const Color(0xFFECEDFF);
  static Color get bgCard    => isDark ? const Color(0xFF121638) : const Color(0xFFFFFFFF);
  static Color get bgCardAlt => isDark ? const Color(0xFF181D48) : const Color(0xFFF4F5FF);

  // ── Brand accents ──────────────────────────────────────────────────────────
  static Color get purple      => isDark ? const Color(0xFF8B7DF8) : const Color(0xFF6366F1);
  static Color get purpleLight => isDark ? const Color(0xFFB5A8FF) : const Color(0xFF818CF8);
  static Color get purpleDim   => isDark ? const Color(0xFF3D3280) : const Color(0xFFE0E7FF);
  static Color get cyan        => isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2);
  static Color get cyanDim     => isDark ? const Color(0xFF0891B2) : const Color(0xFFBAE6FD);
  static Color get green       => isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
  static Color get greenDim    => isDark ? const Color(0xFF065F46) : const Color(0xFFD1FAE5);

  // ── Text ──────────────────────────────────────────────────────────────────
  static Color get textPrimary   => isDark ? const Color(0xFFF0F2FF) : const Color(0xFF0D1035);
  static Color get textSecondary => isDark ? const Color(0xFF8B92B8) : const Color(0xFF475569);
  static Color get textMuted     => isDark ? const Color(0xFF464D7A) : const Color(0xFF94A3B8);
  static Color get textCyan      => cyan;

  // ── Borders ───────────────────────────────────────────────────────────────
  static Color get borderDefault  => isDark ? const Color(0xFF1E2458) : const Color(0xFFC7CCEF);
  static Color get borderSelected => isDark ? const Color(0xFF6366F1) : const Color(0xFF6366F1);
  static Color get borderGlow     => cyan;

  // ── Status ────────────────────────────────────────────────────────────────
  static Color get online => green;
  static Color get locked => isDark ? const Color(0xFF464D7A) : const Color(0xFF94A3B8);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static LinearGradient get gradientPurple => LinearGradient(
    colors: [purple, isDark ? const Color(0xFF5B8BFF) : const Color(0xFF818CF8)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient get gradientCyan => LinearGradient(
    colors: [cyan, cyanDim],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient get gradientCard => LinearGradient(
    colors: [bgCard, bgCardAlt],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static RadialGradient get gradientBg => RadialGradient(
    center: Alignment.center,
    radius: 1.2,
    colors: [bgBase, bgDeep],
  );
}
