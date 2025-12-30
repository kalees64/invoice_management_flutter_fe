import 'package:flutter/material.dart';

/// Centralized Constants for the Application
/// This file contains all colors, spacings, radii, and API constants
/// making it easy to reuse in other projects.

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);

  // Sidebar
  static const Color sidebarBg = Color(0xFF1F2937);
  static const Color sidebarActive = Color(0xFF374151);

  // Background
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF6366F1),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFF3B82F6),
  ];
}

class AppSpacings {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Common Edge Insets
  static const EdgeInsets pagePadding = EdgeInsets.all(xxl);
  static const EdgeInsets cardPadding = EdgeInsets.all(xl);
  static const EdgeInsets dialogPadding = EdgeInsets.all(xxl);
  static const EdgeInsets elementPadding = EdgeInsets.all(m);
}

class AppRadii {
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;

  static BorderRadius radiusS = BorderRadius.circular(s);
  static BorderRadius radiusM = BorderRadius.circular(m);
  static BorderRadius radiusL = BorderRadius.circular(l);
}

class AppApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  static const String apiPrefix = '/api';

  // Auth
  static const String login = '$apiPrefix/auth/login/admin';
  static const String refresh = '$apiPrefix/auth/refresh';

  // Dashboard
  static const String dashboardStats = '$apiPrefix/admin/dashboard-stats';
  static const String recentOrders = '$apiPrefix/admin/recent-orders';

  // Management
  static const String customers = '$apiPrefix/admin/users/customers';
  static const String providers = '$apiPrefix/admin/users/providers';
  static const String categories = '$apiPrefix/admin/categories';
  static const String updateStatus = '$apiPrefix/admin/users'; // + /{id}/status

  // Banners
  static const String bannersAll = '$apiPrefix/banners/admin/all';
  static const String banners = '$apiPrefix/banners/admin';
}
