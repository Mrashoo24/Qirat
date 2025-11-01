import 'package:flutter/material.dart';

/// Responsive helper for handling different screen sizes
/// Follows Material Design breakpoints
class ResponsiveHelper {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMaxWidth = 1440;

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMaxWidth;
  }

  /// Get responsive value based on screen size
  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return responsive(
      context: context,
      mobile: const EdgeInsets.all(16.0),
      tablet: const EdgeInsets.all(24.0),
      desktop: const EdgeInsets.all(32.0),
    );
  }

  /// Get responsive max width for content
  static double getContentMaxWidth(BuildContext context) {
    return responsive(
      context: context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
    );
  }

  /// Get responsive column count for grid
  static int getGridColumns(BuildContext context) {
    return responsive(
      context: context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }
}

/// Widget that provides responsive layout building
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
          BuildContext context, bool isMobile, bool isTablet, bool isDesktop)
      builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return builder(context, isMobile, isTablet, isDesktop);
  }
}

/// Widget that switches between mobile and desktop layouts
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? tabletLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({
    Key? key,
    required this.mobileLayout,
    this.tabletLayout,
    required this.desktopLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, isMobile, isTablet, isDesktop) {
        if (isDesktop) {
          return desktopLayout;
        } else if (isTablet) {
          return tabletLayout ?? mobileLayout;
        } else {
          return mobileLayout;
        }
      },
    );
  }
}
