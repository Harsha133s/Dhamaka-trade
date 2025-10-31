# 🎨 TradeVerse AI - Complete Theme Configuration Guide

> **Premium Dark Theme with Glassmorphism & Material 3**

---

## 📋 Table of Contents
1. [Color Palette](#-color-palette)
2. [Typography](#-typography)
3. [Spacing & Layout](#-spacing--layout)
4. [Border Radius](#-border-radius)
5. [Shadows & Elevation](#-shadows--elevation)
6. [Glassmorphism Effects](#-glassmorphism-effects)
7. [Animation Timings](#-animation-timings)
8. [Component Styles](#-component-styles)
9. [Usage Examples](#-usage-examples)

---

## 🎨 Color Palette

### Base Backgrounds
```dart
backgroundBase        = #0F1419   // Main app background
cardBackground        = #151B24   // Default card background
cardBackgroundTop     = #1A2330   // Card gradient top (8% lighter)
```

### Primary & Accent
```dart
primaryAccent         = #5B7CFF   // Main brand color (blue)
primaryAccentLight    = #6A8BFF   // Lighter variant for gradients/hover
```

### Status Colors
```dart
success               = #00D97E   // Green for profit/wins
warning               = #FFB020   // Orange for warnings/risk
danger                = #FF5C5C   // Red for losses/errors
```

### Text Colors
```dart
textPrimary           = #E6EDF3   // Main text (high contrast)
textSecondary         = #9AA6B2   // Secondary text (70% opacity)
```

### UI Elements
```dart
divider               = #1F2632   // Lines between sections
border                = #2A3542   // Input/card borders
inputFill             = #213045   // Input field background
```

### Glassmorphism Colors
```dart
glassWhite            = #1AFFFFFF (10% white)
glassBorder           = #33FFFFFF (20% white)
glassHighlight        = #0AFFFFFF (4% white for subtle highlights)
```

---

## 📐 Typography

**Font Family**: `Inter` (via Google Fonts)

### Headlines
```dart
h1:
  fontSize: 28px
  lineHeight: 36px (1.286)
  fontWeight: 700 (Bold)
  letterSpacing: -0.4px

h2:
  fontSize: 22px
  lineHeight: 30px (1.364)
  fontWeight: 700 (Bold)
  letterSpacing: -0.4px

h3:
  fontSize: 18px
  lineHeight: 26px (1.444)
  fontWeight: 600 (Semi-bold)
  letterSpacing: -0.4px
```

### Body Text
```dart
bodyLarge:
  fontSize: 15px
  lineHeight: 22px (1.467)
  fontWeight: 400 (Regular)

bodySmall:
  fontSize: 13px
  lineHeight: 20px (1.538)
  fontWeight: 400 (Regular)
```

### Special Purpose
```dart
numbers:
  fontSize: 15px
  lineHeight: 22px
  fontWeight: 600 (Semi-bold)
  fontFeatures: tabularFigures() // Monospaced numbers

caption:
  fontSize: 12px
  lineHeight: 18px (1.5)
  fontWeight: 500 (Medium)
```

---

## 📏 Spacing & Layout

```dart
xs   = 4px    // Tight spacing
sm   = 8px    // Small gaps
md   = 12px   // Default spacing
lg   = 16px   // Section spacing
xl   = 24px   // Large sections
xxl  = 32px   // Page margins
```

**Usage:**
- Use `lg (16px)` for padding inside cards
- Use `xl (24px)` for padding between major sections
- Use `md (12px)` for gaps between list items

---

## ⚪ Border Radius

```dart
card         = 14px   // All card containers
input        = 10px   // Text fields, search bars
button       = 12px   // Primary/secondary buttons
pill         = 16px   // Tag chips, small badges
actionBar    = 18px   // Bottom navigation, floating bars
progressBar  = 6px    // Linear progress indicators
```

---

## 🌗 Shadows & Elevation

### Elevation Values
```dart
none    = 0.0
low     = 4.0
medium  = 8.0
high    = 12.0
```

### Shadow Types

#### Soft Shadow (for elevated cards)
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.3),
  blurRadius: 12,
  offset: Offset(0, 4),
)
```

#### Glow Shadow (for buttons/highlights)
```dart
BoxShadow(
  color: AppColors.primaryAccent.withOpacity(0.4),
  blurRadius: 16,
  spreadRadius: 2,
)
```

#### Inner Shadow (for input fields)
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.2),
  blurRadius: 8,
  offset: Offset(0, 2),
  spreadRadius: -2,
)
```

---

## 🔮 Glassmorphism Effects

### Blur Strength
```dart
appBar   = 20.0    // Navigation bar blur
card     = 15.0    // Card backdrop blur
button   = 10.0    // Button glassmorphism
modal    = 30.0    // Overlay/modal blur
overlay  = 25.0    // General overlay blur
```

### Opacity Values
```dart
disabled  = 0.38   // Disabled elements
inactive  = 0.6    // Inactive tabs/buttons
divider   = 0.08   // Subtle dividers
overlay   = 0.06   // Background overlays
appBar    = 0.7    // App bar transparency
```

### Glassmorphism Card Template
```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.cardGlassGradient,
    borderRadius: BorderRadius.circular(AppRadius.card),
    border: Border.all(
      color: AppColors.glassBorder,
      width: 1,
    ),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(AppRadius.card),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: AppBlur.card,
        sigmaY: AppBlur.card,
      ),
      child: YourContent(),
    ),
  ),
)
```

---

## ⏱️ Animation Timings

```dart
fast     = 180ms    // Quick feedback (button presses)
normal   = 220ms    // Standard transitions (page slides)
slow     = 300ms    // Smooth animations (modals, drawers)
```

### Recommended Curves
- **Standard**: `Curves.easeInOut`
- **Entry**: `Curves.easeOut`
- **Exit**: `Curves.easeIn`
- **Bounce**: `Curves.elasticOut`

---

## 🧩 Component Styles

### 1️⃣ Cards

#### Standard Card
```dart
Container(
  decoration: BoxDecoration(
    gradient: AppColors.cardGradient,
    borderRadius: BorderRadius.circular(AppRadius.card),
    border: Border.all(color: AppColors.border, width: 1),
  ),
  padding: EdgeInsets.all(AppSpacing.lg),
  child: YourContent(),
)
```

#### Glassmorphism Card
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0x1AFFFFFF), // 10% white
        Color(0x0AFFFFFF), // 4% white
      ],
    ),
    borderRadius: BorderRadius.circular(AppRadius.card),
    border: Border.all(color: AppColors.glassBorder, width: 1),
    boxShadow: AppElevation.softShadow(opacity: 0.2),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(AppRadius.card),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: YourContent(),
      ),
    ),
  ),
)
```

---

### 2️⃣ Buttons

#### Primary Button (Gradient)
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryAccent,
    foregroundColor: Colors.white,
    elevation: 0,
    shadowColor: AppColors.primaryAccent.withOpacity(0.4),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.button),
    ),
  ),
  onPressed: () {},
  child: Text('Primary Button'),
)
```

#### Outlined Button
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: AppColors.textPrimary,
    side: BorderSide(color: AppColors.border, width: 1),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.button),
    ),
  ),
  onPressed: () {},
  child: Text('Secondary Button'),
)
```

#### Text Button
```dart
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: AppColors.primaryAccent,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  onPressed: () {},
  child: Text('Text Button'),
)
```

---

### 3️⃣ Text Fields

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
    filled: true,
    fillColor: AppColors.inputFill,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide(color: AppColors.border, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide(color: AppColors.primaryAccent, width: 2),
    ),
  ),
)
```

---

### 4️⃣ Bottom Navigation Bar

```dart
BottomNavigationBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: AppColors.primaryAccent,
  unselectedItemColor: AppColors.textSecondary,
  selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
    BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ],
)
```

---

### 5️⃣ AppBar (Glassmorphism)

```dart
AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  flexibleSpace: ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        color: AppColors.backgroundBase.withOpacity(0.7),
      ),
    ),
  ),
  title: Text(
    'TradeVerse AI',
    style: TextStyle(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w700,
      fontSize: 20,
    ),
  ),
)
```

---

### 6️⃣ Status Badge (Profit/Loss)

```dart
// Profit Badge
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: AppColors.success.withOpacity(0.15),
    borderRadius: BorderRadius.circular(AppRadius.pill),
    border: Border.all(color: AppColors.success.withOpacity(0.3), width: 1),
  ),
  child: Text(
    '+15.4%',
    style: TextStyle(
      color: AppColors.success,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
)

// Loss Badge
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: AppColors.danger.withOpacity(0.15),
    borderRadius: BorderRadius.circular(AppRadius.pill),
    border: Border.all(color: AppColors.danger.withOpacity(0.3), width: 1),
  ),
  child: Text(
    '-8.2%',
    style: TextStyle(
      color: AppColors.danger,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

---

### 7️⃣ Gradient Backgrounds

```dart
// Page Background with Gradient
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0F1419),
        Color(0xFF1A2333),
        Color(0xFF151B24),
      ],
      stops: [0.0, 0.5, 1.0],
    ),
  ),
)

// Profit Category Gradient
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0BAF7B), Color(0xFF152836)],
    ),
  ),
)

// Risk Category Gradient
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFB020), Color(0xFF371B1B)],
    ),
  ),
)

// Community Category Gradient
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF5B7CFF), Color(0xFF1A2333)],
    ),
  ),
)
```

---

### 8️⃣ Progress Bars

```dart
LinearProgressIndicator(
  value: 0.65,
  backgroundColor: AppColors.border,
  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
  borderRadius: BorderRadius.circular(AppRadius.progressBar),
  minHeight: 6,
)
```

---

### 9️⃣ Dividers

```dart
// Horizontal Divider
Divider(
  color: AppColors.divider,
  thickness: 1,
  height: 1,
)

// Vertical Divider
VerticalDivider(
  color: AppColors.divider,
  thickness: 1,
  width: 1,
)
```

---

### 🔟 Modal Bottom Sheet

```dart
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    decoration: BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.actionBar)),
      border: Border(top: BorderSide(color: AppColors.border, width: 1)),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.actionBar)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: YourContent(),
        ),
      ),
    ),
  ),
)
```

---

## 🚀 Usage Examples

### Complete Page Template with Glassmorphism

```dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:tradeverse_ai/core/theme/app_tokens.dart';

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient Background
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: CustomScrollView(
          slivers: [
            // Glassmorphism AppBar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: AppColors.backgroundBase.withOpacity(0.7),
                  ),
                ),
              ),
              title: Text(
                'Analytics',
                style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
              ),
            ),
            
            // Content
            SliverPadding(
              padding: EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Glassmorphism Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.cardGlassGradient,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.glassBorder, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total P&L', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                              SizedBox(height: AppSpacing.sm),
                              Text('\$12,450.50', style: AppTypography.h1.copyWith(color: AppColors.success)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Quick Reference

| Element | Color | Radius | Padding |
|---------|-------|--------|---------|
| **Card** | `#151B24` | `14px` | `16px` |
| **Button** | `#5B7CFF` | `12px` | `24px H × 14px V` |
| **Input** | `#213045` | `10px` | `16px H × 14px V` |
| **Badge** | Varies | `16px` | `10px H × 4px V` |
| **AppBar** | Transparent + Blur | `0px` | `16px` |

---

## 📝 Notes

- Always use `AppColors`, `AppRadius`, `AppSpacing` constants instead of hardcoded values
- Apply `BackdropFilter` with blur for glassmorphism effects
- Use gradient overlays sparingly for visual hierarchy
- Maintain 4.5:1 contrast ratio for text accessibility
- Test on both light and dark system themes

---

**Theme Version**: 1.0  
**Last Updated**: January 2025  
**Framework**: Flutter 3.x + Material 3
