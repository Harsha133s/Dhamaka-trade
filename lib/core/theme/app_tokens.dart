/// Premium Dark Theme Tokens
/// Design system constants for TradeVerse AI premium theme

import 'package:flutter/material.dart';

/// Color palette for the premium dark theme
class AppColors {
  // Base backgrounds
  static const Color backgroundBase = Color(0xFF0F1419);
  static const Color cardBackground = Color(0xFF151B24);
  static const Color cardBackgroundTop = Color(0xFF1A2330); // For gradient
  
  // Primary & accent colors
  static const Color primaryAccent = Color(0xFF5B7CFF);
  static const Color primaryAccentLight = Color(0xFF6A8BFF);
  
  // Status colors
  static const Color success = Color(0xFF00D97E);
  static const Color warning = Color(0xFFFFB020);
  static const Color danger = Color(0xFFFF5C5C);
  
  // Text colors
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF9AA6B2);
  
  // UI elements
  static const Color divider = Color(0xFF1F2632);
  static const Color border = Color(0xFF2A3542);
  static const Color inputFill = Color(0xFF213045);
  
  // Category-specific gradients
  static const LinearGradient profitGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0BAF7B), Color(0xFF152836)],
  );
  
  static const LinearGradient riskGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB020), Color(0xFF371B1B)],
  );
  
  static const LinearGradient communityGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B7CFF), Color(0xFF1A2333)],
  );
  
  // Button gradients
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF5B7CFF), Color(0xFF6A8BFF)],
  );
  
  // Card gradient overlay (subtle 8% top-to-bottom)
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A2330), Color(0xFF151B24)],
    stops: [0.0, 1.0],
  );
  
  // Glassmorphism colors
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassHighlight = Color(0x0AFFFFFF);
  
  // Background gradients for glassmorphism
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F1419),
      Color(0xFF1A2333),
      Color(0xFF151B24),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient cardGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF),
      Color(0x0AFFFFFF),
    ],
  );
}

/// Border radius values
class AppRadius {
  static const double card = 14.0;
  static const double input = 10.0;
  static const double button = 12.0;
  static const double pill = 16.0;
  static const double actionBar = 18.0;
  static const double progressBar = 6.0;
}

/// Elevation and shadow values
class AppElevation {
  static const double none = 0.0;
  static const double low = 4.0;
  static const double medium = 8.0;
  static const double high = 12.0;
  
  // Soft shadows
  static List<BoxShadow> softShadow({double opacity = 0.3}) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: opacity),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> glowShadow(Color color, {double opacity = 0.4}) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: 16,
      spreadRadius: 2,
    ),
  ];
  
  static List<BoxShadow> innerShadow() => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: -2,
    ),
  ];
}

/// Typography scale with letter-spacing adjustments
class AppTypography {
  // Headlines (reduced letter-spacing by 4px for compact look)
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    height: 30 / 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    height: 26 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  );
  
  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    height: 20 / 13,
    fontWeight: FontWeight.w400,
  );
  
  // Special purpose
  static const TextStyle numbers = TextStyle(
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w500,
  );
}

/// Spacing values
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

/// Animation durations
class AppDurations {
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 300);
}

/// Blur effects for glass-morphism
class AppBlur {
  static const double appBar = 20.0;
  static const double modal = 30.0;
  static const double card = 15.0;
  static const double button = 10.0;
  static const double overlay = 25.0;
}

/// Opacity values
class AppOpacity {
  static const double disabled = 0.38;
  static const double inactive = 0.6;
  static const double divider = 0.08;
  static const double overlay = 0.06;
  static const double appBar = 0.7;
}

/// Legacy AppTokens class for compatibility
class AppTokens {
  // Background colors
  static const Color backgroundDark = AppColors.backgroundBase;
  static const Color surfaceLight = AppColors.cardBackground;
  
  // Text colors
  static const Color textSecondary = AppColors.textSecondary;
  
  // Accent colors
  static const Color accentBlue = AppColors.primaryAccent;
}

/// Grain overlay for cards
class GrainOverlay extends StatelessWidget {
  final double opacity;
  
  const GrainOverlay({super.key, this.opacity = 0.06});
  
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          painter: _GrainPainter(),
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Simple noise pattern
    final random = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < size.width * size.height / 100; i++) {
      final x = (random * i * 7) % size.width;
      final y = (random * i * 13) % size.height;
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
