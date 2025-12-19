import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:unisaver_flutter/constants/alerts.dart';
import 'package:unisaver_flutter/l10n/app_localizations.dart';
import 'package:unisaver_flutter/utils/language_firebase.dart';
import 'package:unisaver_flutter/utils/language_provider.dart';
import 'package:unisaver_flutter/utils/theme_controller.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/constants/background.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bildirimIzniIste();
    });
  }

  Future<void> bildirimIzniIste() async {
    // Android 12 ve altı için otomatik izin
    if (Platform.isAndroid) {
      final androidInfo = await Permission.notification.status;
      if (androidInfo.isGranted) return;
    }

    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied || status.isRestricted) {
      status = await Permission.notification.request();
    }

    if (status.isPermanentlyDenied) {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/info');
                      },
                      icon: Icon(
                        Icons.question_mark_rounded,
                        size: 32,
                        color: Theme.of(context).colorScheme.secondaryFixed,
                        shadows: [
                          Shadow(
                            color: AppColors.niceBlack.withValues(alpha: 0.65),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
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
                            color: Theme.of(context).colorScheme.secondaryFixed,
                            size: 34,
                            shadows: [
                              Shadow(
                                color: AppColors.niceBlack.withValues(
                                  alpha: 0.65,
                                ),
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
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
                                    color: Colors.white.withValues(alpha: 0.08),
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
                                          final prefs =
                                              await SharedPreferences.getInstance();
                                          await prefs.setBool(
                                            'lang_subscribed',
                                            false,
                                          );

                                          await initLanguageSubscription();
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

                // SCROLL VIEW
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Text(
                          'UniSaver',
                          style: TextStyle(
                            fontFamily: 'MontserratAlternates',
                            fontSize: 72,
                            color: Theme.of(context).colorScheme.secondaryFixed,
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
                        SizedBox(height: 2.h),
                        Text(
                          t(context).main_welcome,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondaryFixed,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          t(context).main_head1,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondaryFixed,
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
                        SizedBox(height: 4.h),
                        // Butonlar
                        _buildButton(context, t(context).main_btns1, () {
                          Navigator.pushNamed(context, '/manuel');
                        }),
                        SizedBox(height: 3.h),
                        _buildButton(context, t(context).main_btns2, () {
                          Navigator.pushNamed(context, '/combination');
                        }),
                        SizedBox(height: 3.h),
                        _buildButton(context, t(context).main_btns3, () {
                          Navigator.pushNamed(context, '/transcript');
                        }),
                        SizedBox(height: 6.h),
                      ],
                    ),
                  ),
                ),

                // ALT METİNLER
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          path: 'destek@seninsite.com',
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

  Widget _buildButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 0, // minimum genişlik kaldır
        maxWidth: double.infinity, // isteğe bağlı, gerekiyorsa sınır koy
      ),
      child: IntrinsicWidth(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 3,
              ),
            ),
          ),
          onPressed: onPressed,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'MontserratAlternates',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
          fontSize: 15,
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
      ),
    );
  }
}
