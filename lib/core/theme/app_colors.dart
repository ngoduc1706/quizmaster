import 'package:flutter/material.dart';

/// Application color scheme
class AppColors {
  AppColors._();

  // Light Theme
  static const Color lightPrimary = Color(0xFF6366F1);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1E293B);
  static const Color lightOnBackground = Color(0xFF1E293B);
  static const Color lightError = Color(0xFFEF4444);
  static const Color lightOnError = Color(0xFFFFFFFF);
  
  // Dark Theme - Improved contrast for better visibility
  static const Color darkPrimary = Color(0xFF818CF8);
  static const Color darkSurface = Color(0xFF1E293B); // Card background
  static const Color darkBackground = Color(0xFF0F172A); // Main background
  static const Color darkOnPrimary = Color(0xFFFFFFFF); // Text on primary buttons
  static const Color darkOnSurface = Color(0xFFE2E8F0); // Text on cards - brighter
  static const Color darkOnBackground = Color(0xFFE2E8F0); // Text on background - brighter
  static const Color darkError = Color(0xFFF87171);
  static const Color darkOnError = Color(0xFFFFFFFF);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Difficulty Colors
  static const Color easy = Color(0xFF10B981);
  static const Color medium = Color(0xFFF59E0B);
  static const Color hard = Color(0xFFEF4444);
  
  // Subscription Colors
  static const Color freeTier = Color(0xFF6B7280);
  static const Color proTier = Color(0xFF6366F1);
  
  // Status Colors
  static const Color active = Color(0xFF10B981);
  static const Color inactive = Color(0xFF6B7280);
  static const Color pending = Color(0xFFF59E0B);
  static const Color completed = Color(0xFF10B981);
  static const Color failed = Color(0xFFEF4444);
  
  // Primary color getter (for backward compatibility)
  static Color get primary => lightPrimary;
}








