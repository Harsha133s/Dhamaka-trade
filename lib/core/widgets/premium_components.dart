/// Premium UI Components
/// High-end components for TradeVerse AI premium dark theme

import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';

/// Premium Gradient Card with category-specific styling
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final LinearGradient? gradient;
  final CardCategory category;
  final bool showGrainOverlay;
  
  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.gradient,
    this.category = CardCategory.neutral,
    this.showGrainOverlay = true,
  });
  
  @override
  Widget build(BuildContext context) {
    LinearGradient cardGradient;
    
    switch (category) {
      case CardCategory.profit:
        cardGradient = AppColors.profitGradient;
        break;
      case CardCategory.risk:
        cardGradient = AppColors.riskGradient;
        break;
      case CardCategory.community:
        cardGradient = AppColors.communityGradient;
        break;
      case CardCategory.neutral:
        cardGradient = AppColors.cardGradient;
        break;
    }
    
    final Widget content = Container(
      decoration: BoxDecoration(
        gradient: gradient ?? cardGradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppElevation.softShadow(),
      ),
      child: Stack(
        children: [
          if (showGrainOverlay) const GrainOverlay(),
          Container(
            width: double.infinity,
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ],
      ),
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    
    return content;
  }
}

enum CardCategory { profit, risk, community, neutral }

/// Primary Gradient Button
class PremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final bool isLoading;
  final IconData? icon;
  final Size? size;
  
  const PremiumButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
    this.isLoading = false,
    this.icon,
    this.size,
  });
  
  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }
  
  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }
  
  void _handleTapCancel() {
    _controller.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onPressed,
            child: Container(
              height: widget.size?.height ?? 48,
              width: widget.size?.width,
              decoration: BoxDecoration(
                gradient: widget.isSecondary ? null : AppColors.primaryButtonGradient,
                border: widget.isSecondary ? Border.all(color: AppColors.border) : null,
                borderRadius: BorderRadius.circular(AppRadius.button),
                boxShadow: widget.isSecondary ? null : AppElevation.glowShadow(AppColors.primaryAccent),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.isSecondary ? Colors.transparent : null,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.isSecondary ? AppColors.primaryAccent : Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  color: widget.isSecondary ? AppColors.textPrimary : Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.text,
                                style: AppTypography.bodyLarge.copyWith(
                                  color: widget.isSecondary ? AppColors.textPrimary : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Status Pill/Chip Component
class StatusPill extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isOutlined;
  
  const StatusPill({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isOutlined = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : (backgroundColor ?? AppColors.inputFill),
        border: isOutlined ? Border.all(color: backgroundColor ?? AppColors.border) : null,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: textColor ?? AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTypography.caption.copyWith(
              color: textColor ?? AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded Progress Bar with Gradient
class RoundedProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final String? label;
  final bool showPercentage;
  
  const RoundedProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.gradient,
    this.backgroundColor,
    this.label,
    this.showPercentage = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).toInt();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Row(
          children: [
            Expanded(
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.divider,
                  borderRadius: BorderRadius.circular(AppRadius.progressBar),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * value,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: gradient ?? AppColors.primaryButtonGradient,
                        borderRadius: BorderRadius.circular(AppRadius.progressBar),
                        boxShadow: AppElevation.glowShadow(
                          AppColors.primaryAccent,
                          opacity: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showPercentage) ...[
              const SizedBox(width: 8),
              Text(
                '$percentage%',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// Icon with Glow Effect
class GlowIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double glowRadius;
  
  const GlowIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
    this.glowRadius = 8,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + glowRadius * 2,
      height: size + glowRadius * 2,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: glowRadius,
            spreadRadius: 2,
          ),
        ],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}

/// Premium Toggle/Switch
class PremiumToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  
  const PremiumToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          color: value 
              ? (activeColor ?? AppColors.primaryAccent)
              : AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedAlign(
          duration: AppDurations.fast,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppElevation.softShadow(opacity: 0.2),
            ),
          ),
        ),
      ),
    );
  }
}

/// Avatar with Status Ring
class StatusAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? statusColor;
  final bool showStatus;
  
  const StatusAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
    this.statusColor,
    this.showStatus = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: imageUrl == null ? AppColors.communityGradient : null,
          ),
          child: imageUrl != null
              ? CircleAvatar(
                  radius: size / 2,
                  backgroundImage: NetworkImage(imageUrl!),
                )
              : Center(
                  child: Text(
                    initials ?? '?',
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
        if (showStatus && statusColor != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.backgroundBase,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Notification Badge
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int count;
  final bool show;
  
  const NotificationBadge({
    super.key,
    required this.child,
    required this.count,
    this.show = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (show && count > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              height: 16,
              constraints: const BoxConstraints(minWidth: 16),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(8),
                boxShadow: AppElevation.glowShadow(AppColors.danger),
              ),
              child: Center(
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Segmented Control Pills
class SegmentedPills extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelectionChanged;
  
  const SegmentedPills({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelectionChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = index == selectedIndex;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged(index),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryAccent : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.pill - 4),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: AppTypography.caption.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Empty State with Illustration
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onAction;
  final bool isDotted;
  
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
    this.isDotted = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        border: isDotted ? Border.all(
          color: AppColors.border,
          style: BorderStyle.solid,
          width: 1,
        ) : null,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlowIcon(
            icon: icon,
            color: AppColors.textSecondary,
            size: 32,
            glowRadius: 6,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.h3.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            StatusPill(
              text: actionText!,
              backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.1),
              textColor: AppColors.primaryAccent,
            ),
          ],
        ],
      ),
    );
  }
}