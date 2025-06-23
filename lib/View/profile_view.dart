import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gap/gap.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../Constants/color_constant.dart';
import '../../Controller/get_translation_controller/get_translation_controller.dart';
import '../../Utils/TranslationManager/translation_service.dart';
import '../Controller/get_translation_controller/get_text_form.dart';

class ProfileView extends StatelessWidget {
  final ScrollController scrollController;
   ProfileView({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translationController = Get.put(TranslationController());

    return Scaffold(
      backgroundColor: SetuColors.background,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h * 0.85,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: SetuColors.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      SetuColors.primaryGreen,
                      SetuColors.lightGreen,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.w * 0.85,
                        height: 80.h * 0.85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10 * 0.85,
                              offset: Offset(0, 5 * 0.85),
                            ),
                          ],
                        ),
                        child: Icon(
                          PhosphorIcons.user(PhosphorIconsStyle.regular),
                          size: 40.w * 0.85,
                          color: SetuColors.primaryGreen,
                        ),
                      ).animate().scale(duration: 800.ms, delay: 200.ms),
                      Gap(16.h * 0.85),
                      GetTranslatableText(
                        'Farmer Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp * 0.85,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                      Gap(4.h * 0.85),
                      GetTranslatableText(
                        'Village, District',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16.sp * 0.85,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16.w * 0.85),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r * 0.85),
                ),
                child: IconButton(
                  icon: Icon(
                    PhosphorIcons.gear(PhosphorIconsStyle.regular),
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _navigateToAppSettings(context);
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w * 0.85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10.h * 0.85),
                  GetTranslatableText(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 20.sp * 0.85,
                      fontWeight: FontWeight.bold,
                      color: SetuColors.textPrimary,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),
                  Gap(16.h * 0.85),
                  ...List.generate(
                    10,
                        (index) => _buildSettingsItem(index, context, translationController).animate().fadeIn(
                      duration: 600.ms,
                      delay: (1400 + (index * 100)).ms,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(int index, BuildContext context, TranslationController translationController) {
    final settings = [
      {
        'title': 'Edit Profile',
        'subtitle': 'Update your personal information',
        'icon': PhosphorIcons.userCircle(PhosphorIconsStyle.regular)
      },
      {
        'title': 'Notifications',
        'subtitle': 'Manage your notification preferences',
        'icon': PhosphorIcons.bell(PhosphorIconsStyle.regular),
      },
      {
        'title': 'Privacy & Security',
        'subtitle': 'Control your privacy settings',
        'icon': PhosphorIcons.shield(PhosphorIconsStyle.regular)
      },
      {
        'title': 'Language',
        'subtitle': 'Change app language',
        'icon': PhosphorIcons.translate(PhosphorIconsStyle.regular)
      },
      {
        'title': 'Help & Support',
        'subtitle': 'Get help or contact support',
        'icon': PhosphorIcons.question(PhosphorIconsStyle.regular)
      },
      {
        'title': 'Terms & Conditions',
        'subtitle': 'Read our terms and conditions',
        'icon': PhosphorIcons.fileText(PhosphorIconsStyle.regular)
      },
      {
        'title': 'Privacy Policy',
        'subtitle': 'Read our privacy policy',
        'icon': PhosphorIcons.file(PhosphorIconsStyle.regular)
      },
      {
        'title': 'Rate App',
        'subtitle': 'Rate us on the app store',
        'icon': PhosphorIcons.star(PhosphorIconsStyle.regular)
      },
      {
        'title': 'Share App',
        'subtitle': 'Share this app with friends',
        'icon': PhosphorIcons.shareNetwork(PhosphorIconsStyle.regular)
      },
      {
        'title': 'Logout',
        'subtitle': 'Sign out from your account',
        'icon': PhosphorIcons.signOut(PhosphorIconsStyle.regular)
      },
    ];

    final setting = settings[index % settings.length];
    final isLogout = setting['title'] == 'Logout';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h * 0.85),
      decoration: BoxDecoration(
        color: SetuColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r * 0.85),
        boxShadow: [
          BoxShadow(
            color: SetuColors.primaryGreen.withOpacity(0.05),
            blurRadius: 10 * 0.85,
            offset: Offset(0, 2 * 0.85),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w * 0.85,
          vertical: 8.h * 0.85,
        ),
        leading: Container(
          padding: EdgeInsets.all(8.w * 0.85),
          decoration: BoxDecoration(
            color: isLogout
                ? SetuColors.error.withOpacity(0.1)
                : SetuColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r * 0.85),
          ),
          child: Icon(
            setting['icon'] as IconData?,
            color: isLogout ? SetuColors.error : SetuColors.primaryGreen,
            size: 20.w * 0.85,
          ),
        ),
        title: GetTranslatableText(
          setting['title'] as String,
          style: TextStyle(
            fontSize: 16.sp * 0.85,
            fontWeight: FontWeight.w600,
            color: isLogout ? SetuColors.error : SetuColors.textPrimary,
          ),
        ),
        subtitle: GetTranslatableText(
          setting['subtitle'] as String,
          style: TextStyle(
            fontSize: 12.sp * 0.85,
            color: SetuColors.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (setting['title'] == 'Language')
              Obx(() {
                final currentLang = translationController.currentLanguage;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w * 0.85,
                    vertical: 4.h * 0.85,
                  ),
                  decoration: BoxDecoration(
                    color: SetuColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r * 0.85),
                  ),
                  child: Text(
                    '${currentLang?.flag ?? '🇺🇸'} ${currentLang?.nativeName ?? 'English'}',
                    style: TextStyle(
                      fontSize: 10.sp * 0.85,
                      color: SetuColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            Gap(8.w * 0.85),
            Icon(
              PhosphorIcons.caretRight(PhosphorIconsStyle.regular),
              color: SetuColors.textSecondary,
              size: 16.w * 0.85,
            ),
          ],
        ),
        onTap: () => _handleSettingsTap(context, setting['title'] as String),
      ),
    );
  }

  void _handleSettingsTap(BuildContext context, String settingTitle) {
    switch (settingTitle) {
      case 'Edit Profile':
        _navigateToEditProfile(context);
        break;
      case 'Notifications':
        _navigateToNotificationSettings(context);
        break;
      case 'Privacy & Security':
        _navigateToPrivacySettings(context);
        break;
      case 'Language':
        _showLanguageSelectionDialog(context);
        break;
      case 'Help & Support':
        _navigateToHelpSupport(context);
        break;
      case 'Terms & Conditions':
        _navigateToTermsConditions(context);
        break;
      case 'Privacy Policy':
        _navigateToPrivacyPolicy(context);
        break;
      case 'Rate App':
        _rateApp(context);
        break;
      case 'Share App':
        _shareApp();
        break;
      case 'Logout':
        _showLogoutDialog(context);
        break;
      default:
        _showComingSoonDialog(context, settingTitle);
    }
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    final translationController = Get.find<TranslationController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SetuColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r * 0.85),
          ),
          title: Row(
            children: [
              Icon(
                PhosphorIcons.translate(PhosphorIconsStyle.regular),
                color: SetuColors.primaryGreen,
                size: 24.w * 0.85,
              ),
              Gap(12.w * 0.85),
              GetTranslatableText(
                'Select Language',
                style: TextStyle(
                  fontSize: 20.sp * 0.85,
                  fontWeight: FontWeight.bold,
                  color: SetuColors.textPrimary,
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w * 0.85,
            vertical: 16.h * 0.85,
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: SupportedLanguages.all.map((language) {
                return Obx(() {
                  final isSelected = translationController.currentLanguage?.code == language.code;
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h * 0.85),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? SetuColors.primaryGreen.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r * 0.85),
                      border: Border.all(
                        color: isSelected
                            ? SetuColors.primaryGreen
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w * 0.85,
                        vertical: 4.h * 0.85,
                      ),
                      leading: Container(
                        width: 40.w * 0.85,
                        height: 40.h * 0.85,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? SetuColors.primaryGreen.withOpacity(0.2)
                              : SetuColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r * 0.85),
                        ),
                        child: Center(
                          child: Text(
                            language.flag,
                            style: TextStyle(fontSize: 20.sp * 0.85),
                          ),
                        ),
                      ),
                      title: Text(
                        language.name,
                        style: TextStyle(
                          fontSize: 16.sp * 0.85,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? SetuColors.primaryGreen
                              : SetuColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        language.nativeName,
                        style: TextStyle(
                          fontSize: 13.sp * 0.85,
                          color: isSelected
                              ? SetuColors.primaryGreen.withOpacity(0.8)
                              : SetuColors.textSecondary,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                        PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                        color: SetuColors.primaryGreen,
                        size: 20.w * 0.85,
                      )
                          : null,
                      onTap: () async {
                        if (!isSelected) {
                          Navigator.of(context).pop();


                          try {
                            _showLanguageChangeLoading(context);

                            await translationController.changeLanguage(
                              language,
                              showProgress: false,
                            );
                            Navigator.of(context).pop();
                            _showLanguageChangeSuccess(context, language);
                          } catch (e) {
                            Navigator.of(context).pop();
                            _showError('Failed to change language: $e');
                          }
                        }
                      },
                    ),
                  );
                });
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: GetTranslatableText(
                'Cancel',
                style: TextStyle(
                  color: SetuColors.textSecondary,
                  fontSize: 16.sp * 0.85,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Replace your _showLanguageChangeLoading method with this enhanced version:

  void _showLanguageChangeLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Automatically close the dialog after 5 seconds
        Future.delayed(Duration(milliseconds: 3500), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });


        return AlertDialog(
          backgroundColor: SetuColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r * 0.85),
          ),
          content: Container(
            padding: EdgeInsets.all(24.w * 0.85),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Your existing loading content
                Container(
                  width: 80.w * 0.85,
                  height: 80.h * 0.85,
                  decoration: BoxDecoration(
                    color: SetuColors.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PhosphorIcons.translate(PhosphorIconsStyle.regular),
                    color: SetuColors.primaryGreen,
                    size: 40.w * 0.85,
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(duration: 2000.ms)
                    .shimmer(
                    duration: 1500.ms,
                    color: SetuColors.primaryGreen.withOpacity(0.3)),
                Gap(24.h * 0.85),
                GetTranslatableText(
                  'Changing language...',
                  style: TextStyle(
                    fontSize: 16.sp * 0.85,
                    fontWeight: FontWeight.w600,
                    color: SetuColors.textPrimary,
                  ),
                ).animate(),
                Gap(16.h * 0.85),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w * 0.85),
                      width: 8.w * 0.85,
                      height: 8.h * 0.85,
                      decoration: BoxDecoration(
                        color: SetuColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .scale(
                        duration: 600.ms,
                        delay: (index * 200).ms,
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.2, 1.2))
                        .then()
                        .scale(
                        duration: 600.ms,
                        begin: const Offset(1.2, 1.2),
                        end: const Offset(0.5, 0.5));
                  }),
                ),
                Gap(16.h * 0.85),
                Container(
                  width: double.infinity,
                  height: 4.h * 0.85,
                  decoration: BoxDecoration(
                    color: SetuColors.primaryGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.r * 0.85),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: SetuColors.primaryGreen,
                      borderRadius: BorderRadius.circular(2.r * 0.85),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scaleX(
                      duration: 2000.ms,
                      alignment: Alignment.centerLeft,
                      begin: 0.0,
                      end: 1.0)
                      .then()
                      .scaleX(
                      duration: 1000.ms,
                      alignment: Alignment.centerLeft,
                      begin: 1.0,
                      end: 0.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showLanguageChangeSuccess(BuildContext context, Language language) {
    Get.snackbar(
      'Success',
      'Language changed to ${language.nativeName}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: SetuColors.primaryGreen.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w * 0.85),
      borderRadius: 12.r * 0.85,
      icon: Icon(
        PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
        color: Colors.white,
      ),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'OK',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _navigateToAppSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppSettingsPage(),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(),
      ),
    );
  }

  void _navigateToNotificationSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationSettingsPage(),
      ),
    );
  }

  void _navigateToPrivacySettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacySettingsPage(),
      ),
    );
  }

  void _navigateToHelpSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpSupportPage(),
      ),
    );
  }

  void _navigateToTermsConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsConditionsPage(),
      ),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyPolicyPage(),
      ),
    );
  }

  void _rateApp(BuildContext context) async {
    try {
      const String androidUrl = 'https://play.google.com/store/apps/details?id=com.yourapp.package';
      const String iosUrl = 'https://apps.apple.com/app/your-app-id';
      final Uri url = Uri.parse(androidUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorDialog(context, 'Could not open app store');
      }
    } catch (e) {
      _showErrorDialog(context, 'Error opening app store: $e');
    }
  }

  void _shareApp() {
    Share.share(
      'Check out this amazing farming app! 🌾\n\nDownload it now: https://yourapp.com/download',
      subject: 'Check out this farming app!',
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SetuColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r * 0.85),
          ),
          title: GetTranslatableText(
            'Error',
            style: TextStyle(
              fontSize: 20.sp * 0.85,
              fontWeight: FontWeight.bold,
              color: SetuColors.error,
            ),
          ),
          content: GetTranslatableText(
            message,
            style: TextStyle(
              fontSize: 16.sp * 0.85,
              color: SetuColors.textSecondary,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: SetuColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r * 0.85),
                ),
              ),
              child: GetTranslatableText(
                'OK',
                style: TextStyle(
                  fontSize: 16.sp * 0.85,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SetuColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r * 0.85),
          ),
          title: GetTranslatableText(
            'Coming Soon',
            style: TextStyle(
              fontSize: 20.sp * 0.85,
              fontWeight: FontWeight.bold,
              color: SetuColors.textPrimary,
            ),
          ),
          content: GetTranslatableText(
            '$feature feature is coming soon! Stay tuned for updates.',
            style: TextStyle(
              fontSize: 16.sp * 0.85,
              color: SetuColors.textSecondary,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: SetuColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r * 0.85),
                ),
              ),
              child: GetTranslatableText(
                'OK',
                style: TextStyle(
                  fontSize: 16.sp * 0.85,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SetuColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r * 0.85),
          ),
          title: GetTranslatableText(
            'Logout',
            style: TextStyle(
              fontSize: 20.sp * 0.85,
              fontWeight: FontWeight.bold,
              color: SetuColors.textPrimary,
            ),
          ),
          content: GetTranslatableText(
            'Are you sure you want to logout from your account?',
            style: TextStyle(
              fontSize: 16.sp * 0.85,
              color: SetuColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: GetTranslatableText(
                'Cancel',
                style: TextStyle(
                  color: SetuColors.textSecondary,
                  fontSize: 16.sp * 0.85,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SetuColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r * 0.85),
                ),
              ),
              child: GetTranslatableText(
                'Logout',
                style: TextStyle(
                  fontSize: 16.sp * 0.85,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
    );
  }

  void _showError(String message) {
    if (Get.context != null) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.all(8.w * 0.85),
      );
    }
  }
}

class AppSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetTranslatableText('App Settings'),
        backgroundColor: SetuColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GetTranslatableText(
          'App Settings Page',
          style: TextStyle(fontSize: 18.sp * 0.85),
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetTranslatableText('Edit Profile'),
        backgroundColor: SetuColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GetTranslatableText(
          'Edit Profile Page',
          style: TextStyle(fontSize: 18.sp * 0.85),
        ),
      ),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetTranslatableText('Notification Settings'),
        backgroundColor: SetuColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GetTranslatableText(
          'Notification Settings Page',
          style: TextStyle(fontSize: 18.sp * 0.85),
        ),
      ),
    );
  }
}

class PrivacySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetTranslatableText('Privacy & Security'),
        backgroundColor: SetuColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GetTranslatableText(
          'Privacy & Security Page',
          style: TextStyle(fontSize: 18.sp * 0.85),
        ),
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetTranslatableText('Help & Support'),
        backgroundColor: SetuColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GetTranslatableText(
          'Help & Support Page',
          style: TextStyle(fontSize: 18.sp * 0.85),
        ),
      ),
    );
  }
}

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetTranslatableText('Terms & Conditions'),
        backgroundColor: SetuColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GetTranslatableText(
          'Terms & Conditions Page',
          style: TextStyle(fontSize: 18.sp * 0.85),
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetTranslatableText('Privacy Policy'),
        backgroundColor: SetuColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: GetTranslatableText(
          'Privacy Policy Page',
          style: TextStyle(fontSize: 18.sp * 0.85),
        ),
      ),
    );
  }
}
