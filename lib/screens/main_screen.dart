import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:unisaver_flutter/constants/alerts.dart';
import 'package:unisaver_flutter/database/local_database_helper.dart';
import 'package:unisaver_flutter/l10n/app_localizations.dart';
import 'package:unisaver_flutter/utils/language_provider.dart';
import 'package:unisaver_flutter/utils/theme_controller.dart';
import 'package:unisaver_flutter/utils/usage_tracker.dart';
import 'package:unisaver_flutter/widgets/buttons/main_page_button.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/dialogs/recommend_button_wrapper.dart';
import 'package:unisaver_flutter/widgets/texts/list_texts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/constants/background.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? type;
  bool? shown;
  bool isBubbleOpen = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!LocalStorageService.shownNotificationIntro) {
        await bildirimIzniIste();
        LocalStorageService.setShownNotificationIntro();
      }
      await Future.delayed(const Duration(milliseconds: 500));
      await _initAdMobWithPrivacy();
    });
    type = LocalStorageService.userType;
    shown = LocalStorageService.shownUserSuggestion;
  }

  Future<void> _initAdMobWithPrivacy() async {
    if (Platform.isIOS) {
      await Future.delayed(const Duration(seconds: 2));

      TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;

      if (status == TrackingStatus.notDetermined) {
        status = await AppTrackingTransparency.requestTrackingAuthorization();
      }
      print("Takip İzni Durumu: $status");
    }
    await MobileAds.instance.initialize();
  }

  int getRecommendedFunction(String userType) {
    switch (userType) {
      case "decisive":
        return 1; // Manuel
      case "curious":
        return 2; // Kombinasyon
      case "careful":
        return 3; // Transkript
      default:
        return 0;
    }
  }

  Future<void> bildirimIzniIste() async {
    if (Platform.isIOS) {
      await _requestIOSNotification();
      return;
    }

    // ANDROID
    final status = await Permission.notification.status;

    if (status.isGranted) return;

    if (status.isDenied) {
      final result = await Permission.notification.request();
      if (result.isPermanentlyDenied) {
        _showSettingsDialog();
      }
    }

    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    }
  }

  Future<void> _requestIOSNotification() async {
    final messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      _showSettingsDialog();
    }
  }

  void _showSettingsDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.whiteish,
        title: Text(
          t(context).noti_permission,
          style: const TextStyle(
            fontFamily: 'MontserratAlternates',
            color: AppColors.blue,
            fontSize: 24,
          ),
        ),
        content: Text(
          t(context).noti_permission_desc,
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: AppColors.niceBlack,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t(context).cancel,
              style: const TextStyle(
                color: AppColors.niceBlack,
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          PurpleButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            text: t(context).settings,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recommended = getRecommendedFunction(type ?? "");
    final showCursor = shown != null && !shown! && recommended != 0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          isBubbleOpen = false;
        });
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: Stack(
          children: [
            const BlobBackground(),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/info');
                        },
                        icon: Icon(
                          Icons.question_mark_rounded,
                          size: 32,
                          color: Theme.of(context).colorScheme.secondaryFixed,
                        ),
                      ),
                      const Spacer(),
                      MenuAnchor(
                        builder: (context, controller, child) {
                          return IconButton(
                            onPressed: () {
                              controller.isOpen
                                  ? controller.close()
                                  : controller.open();
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryFixed,
                              size: 32,
                            ),
                          );
                        },

                        style: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          elevation: WidgetStateProperty.all(0),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),

                        menuChildren: [
                          Align(
                            alignment: Alignment.topRight,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 75.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 14,
                                    sigmaY: 14,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.18,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 20,
                                          offset: Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _glassMenuItem(
                                          icon: Icons.grading_outlined,
                                          text: t(context).menu1,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/letters',
                                            );
                                          },
                                        ),
                                        _glassMenuItem(
                                          icon: Icons.language,
                                          text: t(context).menu2,
                                          onPressed: () async {
                                            final provider = context
                                                .read<LanguageProvider>();
                                            provider.toggleLanguage(
                                              AppLocalizations.of(
                                                        context,
                                                      )?.localeName ==
                                                      'tr'
                                                  ? const Locale('tr')
                                                  : const Locale('en'),
                                            );
                                          },
                                        ),
                                        _glassMenuItem(
                                          icon:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Icons.light_mode
                                              : Icons.dark_mode,
                                          text:
                                              Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? t(context).light_mode
                                              : t(context).dark_mode,
                                          onPressed: () {
                                            context
                                                .read<ThemeController>()
                                                .toggleTheme();
                                          },
                                        ),
                                        _glassMenuItem(
                                          icon: Icons.call_made_rounded,
                                          text: t(context).menu3,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/contact',
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 6.h),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 0,
                              maxWidth: 90.w,
                            ),
                            child: FittedBox(
                              child: Text(
                                'UniSaver',
                                style: TextStyle(
                                  fontFamily: 'MontserratAlternates',
                                  fontSize: 72,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryFixed,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.niceBlack.withValues(
                                        alpha: 0.65,
                                      ),
                                      blurRadius: 8,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            t(context).main_head1,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.italic,
                              fontSize: 20,
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryFixed,
                              shadows: [
                                Shadow(
                                  color: AppColors.niceBlack.withValues(
                                    alpha: 0.65,
                                  ),
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: !showCursor && recommended == 1
                                ? 4.h - 18
                                : 4.h,
                          ),
                          if (!showCursor && recommended == 1)
                            _recommendationText(
                              text: t(context).recommend_manual,
                            ),
                          RecommendedButtonWrapper(
                            showCursor:
                                showCursor && recommended == 1 && isBubbleOpen,
                            message: t(context).suggest_manual,
                            child: MainPageButton(
                              function: 1,
                              onComeBack: () {
                                setState(() {
                                  type = LocalStorageService.userType;
                                  shown =
                                      LocalStorageService.shownUserSuggestion;
                                });
                                UsageTracker.manual();
                              },
                            ),
                          ),

                          SizedBox(
                            height: !showCursor && recommended == 2
                                ? 4.h - 18
                                : 4.h,
                          ),
                          if (!showCursor && recommended == 2)
                            _recommendationText(
                              text: t(context).recommend_comb,
                            ),
                          RecommendedButtonWrapper(
                            showCursor:
                                showCursor && recommended == 2 && isBubbleOpen,
                            message: t(context).suggest_comb,
                            child: MainPageButton(
                              function: 2,
                              onComeBack: () {
                                setState(() {
                                  type = LocalStorageService.userType;
                                  shown =
                                      LocalStorageService.shownUserSuggestion;
                                });
                                UsageTracker.combination();
                              },
                            ),
                          ),

                          SizedBox(
                            height: !showCursor && recommended == 3
                                ? 4.h - 18
                                : 4.h,
                          ),
                          if (!showCursor && recommended == 3)
                            _recommendationText(
                              text: t(context).recommend_trans,
                            ),
                          RecommendedButtonWrapper(
                            showCursor:
                                showCursor && recommended == 3 && isBubbleOpen,
                            message: t(context).suggest_trans,
                            child: MainPageButton(
                              function: 3,
                              onComeBack: () {
                                setState(() {
                                  type = LocalStorageService.userType;
                                  shown =
                                      LocalStorageService.shownUserSuggestion;
                                });
                                UsageTracker.transcript();
                              },
                            ),
                          ),
                          SizedBox(height: 6.h),
                        ],
                      ),
                    ),
                  ),

                  // ALT METİNLER
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 2.h,
                      left: 4.w,
                      right: 4.w,
                      top: 2.h,
                    ),
                    child: Wrap(
                      children: [
                        _bottomText(t(context).main_head2, () async {
                          final Uri uri = Uri.parse(
                            'https://sites.google.com/view/unisaverapp/ana-sayfa',
                          );

                          if (!await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          )) {
                            if (!context.mounted) return;
                            showAlert(
                              context,
                              t(context).link_not_opened,
                              '${t(context).link_n_opened_desc}\nLink: https://sites.google.com/view/unisaverapp/ana-sayfa',
                            );
                          }
                        }),
                        Text(
                          '  ●  ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondaryFixed,
                          ),
                        ),
                        _bottomText(t(context).main_head3, () async {
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: 'bamisamu@hotmail.com',
                          );

                          if (!await launchUrl(emailUri)) {
                            if (!context.mounted) return;
                            showAlert(
                              context,
                              t(context).link_not_opened,
                              t(context).link_n_opened_desc,
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendationText({required String text}) {
    return Container(
      margin: EdgeInsets.only(left: 32, right: 100),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: listSubtitle(context, text),
    );
  }

  Widget _glassMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return MenuItemButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(
          AppColors.white.withValues(alpha: 0.1),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        ),
      ),
      leadingIcon: Icon(
        icon,
        size: 24,
        color: Theme.of(context).colorScheme.secondaryFixed,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: Theme.of(context).colorScheme.secondaryFixed,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _bottomText(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'MontserratAlternates',
          fontSize: 14,

          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
      ),
    );
  }
}
