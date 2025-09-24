import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gap/gap.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:setuapp/Route%20Manager/app_routes.dart';
import '../Constants/color_constant.dart';

class DashboardView extends StatelessWidget {
  final ScrollController scrollController;
  const DashboardView({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: SetuColors.background,
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w * 0.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard()
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: -0.2, end: 0),
                    Gap(20.h * 0.85),
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20.sp * 0.85,
                        fontWeight: FontWeight.bold,
                        color: SetuColors.textPrimary,
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                    Gap(16.h * 0.85),
                    _buildQuickActions()
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 400.ms),
                    Gap(24.h * 0.85),
                    Text(
                      'Register For Government Schemes',
                      style: TextStyle(
                        fontSize: 20.sp * 0.85,
                        fontWeight: FontWeight.bold,
                        color: SetuColors.textPrimary,
                      ),
                    ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                    Gap(16.h * 0.85),
                    _buildGovernmentSchemes(context)
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 800.ms),
                    Gap(24.h * 0.85),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w * 0.85),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            SetuColors.primaryGreen,
            SetuColors.lightGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r * 0.85),
        boxShadow: [
          BoxShadow(
            color: SetuColors.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                PhosphorIcons.leaf(PhosphorIconsStyle.regular),
                color: Colors.white,
                size: 32.w * 0.85,
              ),
              Gap(12.w * 0.85),
              Text(
                'Welcome to Setu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp * 0.85,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gap(12.h * 0.85),
          Text(
            'Your rural registration companion',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16.sp * 0.85,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': PhosphorIcons.fileText, // Represents a document or form
        'title': 'My Application',
        'color': SetuColors.success,
      },
      {
        'icon': PhosphorIcons
            .clockCountdown, // Represents something pending or waiting
        'title': 'Pending Application',
        'color': SetuColors.warning,
      },
      {
        'icon': PhosphorIcons.headset, // Better suited for support
        'title': 'Contact Support',
        'color': SetuColors.skyBlue,
      },
      {
        'icon': PhosphorIcons.checkCircle, // Represents something verified
        'title': 'Verified Applications',
        'color': SetuColors.earthBrown,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w * 0.85,
        mainAxisSpacing: 16.h * 0.85,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        final iconBuilder =
            action['icon'] as PhosphorIconData Function(PhosphorIconsStyle);
        final color = action['color'] as Color;

        return Container(
          decoration: BoxDecoration(
            color: SetuColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r * 0.85),
            boxShadow: [
              BoxShadow(
                color: SetuColors.primaryGreen.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r * 0.85),
              onTap: () {
                _handleQuickActionTap(context, action['title'] as String);
              },
              child: Padding(
                padding: EdgeInsets.all(20.w * 0.85),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w * 0.85),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r * 0.85),
                      ),
                      child: Icon(
                        iconBuilder(PhosphorIconsStyle.regular),
                        color: color,
                        size: 28.w * 0.85,
                      ),
                    ),
                    Gap(12.h * 0.85),
                    Text(
                      action['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp * 0.85,
                        fontWeight: FontWeight.w600,
                        color: SetuColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGovernmentSchemes(BuildContext context) {
    final schemes = [
      {
        'icon': PhosphorIcons.calculator,
        'title': 'New Calculation\nApplication',
        'color': SetuColors.success,
        'description':
            'Permanent, Sub-share, Non-farm, Gunthewari & Integration'
      },
      {
        'icon': PhosphorIcons.mapPin,
        'title': 'Land Acquisition\nCalculation',
        'color': SetuColors.earthBrown,
        'description': 'Land Acquisition Calculation Application'
      },
      {
        'icon': PhosphorIcons.scales,
        'title': 'Court Commission\nCase',
        'color': SetuColors.error,
        'description': 'Court Commission Case Management'
      },
      {
        'icon': PhosphorIcons.gavel,
        'title': 'Court Allocation\nCase',
        'color': SetuColors.lightGreen,
        'description': 'Court Allocation Case Processing'
      },
      {
        'icon': PhosphorIcons.clipboardText,
        'title': 'Government\nCensus',
        'color': SetuColors.warning,
        'description': 'Government Census Data Management'
      },
    ];

    return Column(
      children: schemes.asMap().entries.map((entry) {
        final index = entry.key;
        final scheme = entry.value;
        final iconBuilder =
            scheme['icon'] as PhosphorIconData Function(PhosphorIconsStyle);
        final color = scheme['color'] as Color;

        return Container(
          margin: EdgeInsets.only(
            bottom: index < schemes.length - 1 ? 12.h * 0.85 : 0,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w * 0.85),
            decoration: BoxDecoration(
              color: SetuColors.cardBackground,
              borderRadius: BorderRadius.circular(16.r * 0.85),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r * 0.85),
                onTap: () {
                  _handleSchemeTap(context, scheme['title'] as String);
                },
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w * 0.85),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r * 0.85),
                      ),
                      child: Icon(
                        iconBuilder(PhosphorIconsStyle.regular),
                        color: color,
                        size: 28.w * 0.85,
                      ),
                    ),
                    Gap(16.w * 0.85),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme['title'] as String,
                            style: TextStyle(
                              fontSize: 16.sp * 0.85,
                              fontWeight: FontWeight.w600,
                              color: SetuColors.textPrimary,
                            ),
                          ),
                          Gap(4.h * 0.85),
                          Text(
                            scheme['description'] as String,
                            style: TextStyle(
                              fontSize: 13.sp * 0.85,
                              color: SetuColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      PhosphorIcons.caretRight(PhosphorIconsStyle.regular),
                      color: SetuColors.textSecondary,
                      size: 20.w * 0.85,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

// Replace your _handleQuickActionTap method with this:
  void _handleQuickActionTap(BuildContext context, String actionTitle) {
    // Add error handling and debugging
    try {
      print('Attempting to navigate to: $actionTitle');

      switch (actionTitle) {
        case 'My Application':  // Fixed: This should match your actual action title
          Get.toNamed(AppRoutes.dashboardMyApplication);
          print('Navigated to: My Application Page');
          break;
        case 'Pending Application':
        // Add your route here
          print('Navigate to: Pending Application Page');
          break;
        case 'Contact Support':
        // Add your route here
          print('Navigate to: Contact Support Page');
          break;
        case 'Verified Applications':
        // Add your route here
          print('Navigate to: Verified Applications Page');
          break;
        default:
          print('Unknown action: $actionTitle');
          // Show snackbar for debugging
          Get.snackbar(
            'Navigation Error',
            'Route not found for: $actionTitle',
            snackPosition: SnackPosition.BOTTOM,
          );
      }
    } catch (e) {
      print('Navigation error: $e');
      Get.snackbar(
        'Error',
        'Failed to navigate: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// Navigation handlers for Government Schemes
  void _handleSchemeTap(BuildContext context, String schemeTitle) {
    // Remove line breaks from title for cleaner routing
    String cleanTitle = schemeTitle.replaceAll('\n', ' ');

    switch (cleanTitle) {
      case 'New Calculation Application':
        Get.toNamed(AppRoutes.newCalculationApplication);
        break;
      case 'Land Acquisition Calculation':
        Get.toNamed(AppRoutes.landAcquisitionCalculationApplication);
        break;
      case 'Court Commission Case':
        Get.toNamed(AppRoutes.courtCommissionCase);

        break;
      case 'Court Allocation Case':
        Get.toNamed(AppRoutes.courtAllocationCase);

        break;
      case 'Government Census':
        Get.toNamed(AppRoutes.governmentCensus);

        break;
      default:
        print('Unknown scheme: $cleanTitle');
    }
  }
}
