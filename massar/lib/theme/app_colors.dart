import 'package:flutter/material.dart';

abstract final class AppColors {
  // Splash screen
  static const Color splashBg = Color(0xffF8F8F3);

  // Onboarding gradient
  static const Color onboardingGrad1 = Color(0xFF0B63D6);
  static const Color onboardingGrad2 = Color(0xFF0A58BE);
  static const Color onboardingGrad3 = Color(0xFF00355F);
  static const Color onboardingGrad4 = Color(0xFF001F33);
  static const Color onboardingText = Color(0xffF5F5F5);

  // Shared screen background gradient (home, notifications, travel detail)
  static const Color screenBgGrad1 = Color(0xFF00287C);
  static const Color screenBgGrad2 = Color(0xFF01253D);
  static const Color screenBgGrad3 = Color(0xFF00133F);

  // Bottom-left glow overlay
  static const Color glowHigh = Color(0x47BAD1FF); // ~28% opacity
  static const Color glowLow = Color(0x14BAD1FF);  // ~8% opacity

  // Glass surface defaults
  static const Color glassFill = Color(0x1FFFFFFF);   // white 12%
  static const Color glassBorder = Color(0x2EFFFFFF); // white 18%

  // Profile avatar background
  static const Color avatarBg = Color(0x33FFFFFF); // white 20%

  // Notification card glass states
  static const Color notifUnreadFill = Color(0x29FFFFFF);   // white 16%
  static const Color notifReadFill = Color(0x14FFFFFF);     // white 8%
  static const Color notifUnreadBorder = Color(0x4DFFFFFF); // white 30%
  static const Color notifReadBorder = Color(0x1FFFFFFF);   // white 12%
  static const Color notifIconBg = Color(0x26FFFFFF);       // white 15%
  static const Color notifIconBorder = Color(0x40FFFFFF);   // white 25%

  // White with opacity — text variants
  static const Color whiteSubtle = Color(0xB3FFFFFF); // white 70%
  static const Color whiteDim = Color(0x99FFFFFF);    // white 60%
  static const Color whiteMuted = Color(0xBFFFFFFF);  // white 75%

  // Travel card
  static const Color cardDark = Color(0xFF002B45);
  static const Color cardBorderPaint = Color(0x8CFFFFFF); // white 55%

  // Bottom nav icons
  static const Color navIcon = Color(0xff01103a);

  // Notification unread indicator dot
  static const Color unreadDot = Color(0xFF7EB3FF);

  // Reserve button
  static const Color reserveBtnBg = Color.fromARGB(221, 222, 247, 255);
  static const Color reserveBtnText = Color.fromARGB(255, 0, 9, 46);

  // Flight glow circles & airplane icon (dark navy shared value)
  static const Color flightGlow = Color.fromARGB(69, 92, 0, 28);
  static const Color planeGlow = Color.fromARGB(69, 255, 216, 228);
  static const Color planeIcon = Color.fromARGB(255, 0, 9, 46);

  // Image card placeholders (non-const shades)
  static final Color imageFailed = Colors.grey.shade600;
  static final Color imageLoading = Colors.grey.shade700;

  // Base
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
}
