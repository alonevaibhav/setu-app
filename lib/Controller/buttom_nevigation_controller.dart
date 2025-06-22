// lib/controllers/main_navigation_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavigationController extends GetxController with GetTickerProviderStateMixin {
  final currentIndex = 0.obs;
  final isBottomNavVisible = true.obs;

  late ScrollController dashboardScrollController;
  late ScrollController profileScrollController;
  late AnimationController bottomNavAnimationController;
  late Animation<Offset> bottomNavAnimation;

  double lastScrollOffset = 0.0;

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
    setupScrollListeners();
  }

  void initializeControllers() {
    dashboardScrollController = ScrollController();
    profileScrollController = ScrollController();

    bottomNavAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    bottomNavAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: bottomNavAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void setupScrollListeners() {
    dashboardScrollController.addListener(() => handleScroll(dashboardScrollController));
    profileScrollController.addListener(() => handleScroll(profileScrollController));
  }

  void handleScroll(ScrollController controller) {
    if (controller.hasClients) {
      double currentScrollOffset = controller.offset;
      double delta = currentScrollOffset - lastScrollOffset;

      // Hide bottom nav when scrolling down, show when scrolling up
      if (delta > 5 && isBottomNavVisible.value) {
        hideBottomNav();
      } else if (delta < -5 && !isBottomNavVisible.value) {
        showBottomNav();
      }

      lastScrollOffset = currentScrollOffset;
    }
  }

  void hideBottomNav() {
    isBottomNavVisible.value = false;
    bottomNavAnimationController.forward();
  }

  void showBottomNav() {
    isBottomNavVisible.value = true;
    bottomNavAnimationController.reverse();
  }

  void changeTab(int index) {
    currentIndex.value = index;
    // Reset scroll position when switching tabs
    showBottomNav();
  }

  ScrollController getCurrentScrollController() {
    return currentIndex.value == 0 ? dashboardScrollController : profileScrollController;
  }

  @override
  void onClose() {
    dashboardScrollController.dispose();
    profileScrollController.dispose();
    bottomNavAnimationController.dispose();
    super.onClose();
  }
}