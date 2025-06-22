// lib/views/main_navigation_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:setuapp/View/profile_view.dart';
import '../Constants/color_constant.dart';
import '../Controller/buttom_nevigation_controller.dart';
import '../Utils/double_tap_to_exit.dart';
import 'dashboard_view.dart';

class MainNavigationView extends StatelessWidget {
  final MainNavigationController controller =
      Get.put(MainNavigationController());

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      child: Scaffold(
        body: Obx(() => IndexedStack(
              index: controller.currentIndex.value,
              children: [
                DashboardView(
                    scrollController: controller.dashboardScrollController),
                ProfileView(
                    scrollController: controller.profileScrollController),
              ],
            )),
        bottomNavigationBar: Obx(() => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: controller.isBottomNavVisible.value ? null : 0,
              child: SlideTransition(
                position: controller.bottomNavAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    color: SetuColors.cardBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: SetuColors.primaryGreen.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, -10),
                      ),
                      BoxShadow(
                        color: SetuColors.accent.withOpacity(0.05),
                        blurRadius: 40,
                        offset: Offset(0, -20),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Container(
                      height: 80.h,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            icon:
                                PhosphorIcons.house(PhosphorIconsStyle.regular),
                            label: 'Dashboard',
                            index: 0,
                            isActive: controller.currentIndex.value == 0,
                          ),
                          _buildNavItem(
                            icon:
                                PhosphorIcons.user(PhosphorIconsStyle.regular),
                            label: 'Profile',
                            index: 1,
                            isActive: controller.currentIndex.value == 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 1.0, end: 0.0)),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20.w : 16.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? SetuColors.lightGreen.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive
                ? SetuColors.lightGreen.withOpacity(0.3)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isActive ? SetuColors.primaryGreen : SetuColors.textSecondary,
              size: 24.w,
            ),
            if (isActive) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: SetuColors.primaryGreen,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate(target: isActive ? 1 : 0)
        .scale(begin: Offset(0.9, 0.9), end: Offset(1.0, 1.0));
  }
}
