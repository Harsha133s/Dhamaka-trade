/// Modern Glassmorphic UI Components
/// Reusable glass-effect widgets for TradeVerse AI

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../theme/app_tokens.dart';

/// Modern glassmorphic container with blur effects
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final double opacity;
  final VoidCallback? onTap;
  final bool showBorder;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blur = 15,
    this.opacity = 0.1,
    this.onTap,
    this.showBorder = true,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = SizedBox(
      width: width,
      height: height,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: borderRadius,
        blur: blur,
        alignment: Alignment.bottomCenter,
        border: showBorder ? 1.2 : 0,
        linearGradient: (gradient as LinearGradient?) ?? AppColors.cardGlassGradient,
        borderGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x33FFFFFF),
            Color(0x11FFFFFF),
          ],
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      container = Container(margin: margin, child: container);
    }

    if (onTap != null) {
      container = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: container,
      );
    }

    return container
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, duration: 600.ms, curve: Curves.easeOut);
  }
}

/// Modern glassmorphic card for trading data
class GlassTradingCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? valueColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final bool showTrend;
  final double? trendValue;

  const GlassTradingCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.valueColor,
    this.onTap,
    this.width,
    this.height,
    this.showTrend = false,
    this.trendValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trendColor = trendValue != null
        ? trendValue! >= 0
            ? AppColors.success
            : AppColors.danger
        : null;

    return GlassContainer(
      width: width,
      height: height,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with title and icon
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.glassHighlight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: icon!,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
              if (showTrend && trendValue != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendColor?.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendValue! >= 0 ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: trendColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${trendValue! >= 0 ? '+' : ''}${trendValue!.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Main value
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Modern glassmorphic button
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isPrimary;
  final bool isLoading;
  final double? width;
  final double? height;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: GlassmorphicContainer(
        width: width ?? double.infinity,
        height: height ?? 48,
        borderRadius: AppRadius.button,
        blur: AppBlur.button,
        alignment: Alignment.center,
        border: isPrimary ? 0 : 1,
        linearGradient: isPrimary
            ? AppColors.primaryButtonGradient
            : AppColors.cardGlassGradient,
        borderGradient: const LinearGradient(
          colors: [
            Color(0x33FFFFFF),
            Color(0x11FFFFFF),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          isPrimary ? Colors.white : AppColors.primaryAccent,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: isPrimary ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .scale(
          duration: 200.ms,
          curve: Curves.easeOut,
        )
        .then()
        .shimmer(
          duration: 2000.ms,
          color: Colors.white.withValues(alpha: 0.1),
        );
  }
}

/// Glassmorphic app bar
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;

  const GlassAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.appBar, sigmaY: AppBlur.appBar),
        child: Container(
          decoration: BoxDecoration(
            color: (backgroundColor ?? AppColors.backgroundBase).withValues(alpha: 0.8),
            border: const Border(
              bottom: BorderSide(
                color: AppColors.glassBorder,
                width: 0.5,
              ),
            ),
          ),
          child: AppBar(
            title: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: leading,
            actions: actions,
            centerTitle: centerTitle,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Glassmorphic bottom navigation bar
class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.appBar, sigmaY: AppBlur.appBar),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xCC0F1419),
            border: Border(
              top: BorderSide(
                color: AppColors.glassBorder,
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryAccent,
            unselectedItemColor: AppColors.textSecondary,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}