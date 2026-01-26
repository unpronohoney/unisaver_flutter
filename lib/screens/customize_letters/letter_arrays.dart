import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/background2.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/constants/list_constants.dart';
import 'package:unisaver_flutter/database/grade_system_manager.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/list_edit_button.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/description_text.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class LetterArrays extends StatefulWidget {
  const LetterArrays({super.key});

  @override
  State<StatefulWidget> createState() => _StateLetterArrays();
}

class _StateLetterArrays extends State<LetterArrays> {
  late BannerAd _banner;
  bool _isBannerLoaded = false;
  @override
  void initState() {
    super.initState();
    _banner = BannerAd(
      adUnitId: AdMobIds.letterArrayBanner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isBannerLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
    GradeSystemManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground2(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.home_filled,
                  onHomePressed: () => Navigator.pop(context),
                  onRefreshPressed: () {},
                  isrightbuttonappear: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        HeadText(text: t(context).custom_arrays),
                        const SizedBox(height: 16),
                        if (GradeSystemManager.userSystems.isEmpty)
                          DescriptionText(text: t(context).arrays_desc),
                        if (GradeSystemManager.userSystems.isEmpty)
                          const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: PurpleButton(
                            text: t(context).new_lett_array,
                            onPressed: () {
                              Navigator.pushNamed(context, '/letters/show');
                            },
                          ),
                        ),
                        SizedBox(height: 16),

                        ValueListenableBuilder(
                          valueListenable: Hive.box(
                            'gradeSystems',
                          ).listenable(),
                          builder: (context, box, _) {
                            final selected =
                                GradeSystemManager.selectedSystemMap;
                            final defaultSystem =
                                GradeSystemManager.defaultSystemMap;
                            final systems = [
                              defaultSystem,
                              ...GradeSystemManager.userSystems,
                            ];

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: systems.length,
                              itemBuilder: (context, index) {
                                final system = systems[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Dismissible(
                                    key: ValueKey(system['name']),
                                    direction: DismissDirection.endToStart,
                                    background: dismissibleBackground(),
                                    onDismissed: (_) {
                                      GradeSystemManager.deleteSystem(system);
                                    },
                                    confirmDismiss: (direction) async {
                                      if (system['name'] ==
                                          defaultSystem['name']) {
                                        return false;
                                      }
                                      final shouldDelete =
                                          await showDialog<bool>(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    AppColors.whiteish,
                                                title: Text(
                                                  t(context).delete_warn,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'MontserratAlternates',
                                                    color: AppColors.blue,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                content: Text(
                                                  t(context).delete_warn_desc(
                                                    system['name'],
                                                  ),
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto',
                                                    color: AppColors.niceBlack,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                actions: [
                                                  PurpleButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    text: t(context).cancel,
                                                  ),
                                                  PurpleButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    text: t(context).delete,
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                      return shouldDelete ?? false;
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                        right: 8,
                                      ),
                                      decoration: listCardDecoration(context),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                await GradeSystemManager.selectSystem(
                                                  system,
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  RadioGroup<String>(
                                                    groupValue:
                                                        selected!['name'],
                                                    onChanged: (value) async {
                                                      if (value != null) {
                                                        await GradeSystemManager.selectSystem(
                                                          system,
                                                        );
                                                      }
                                                    },
                                                    child: Radio<String>(
                                                      value: system['name'],
                                                      toggleable: false,
                                                      activeColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .secondaryFixed,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      system['name'],
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondaryFixed,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ListEditButton(
                                            onPressed: () async {
                                              await GradeSystemManager.startEditingSystem(
                                                system,
                                              );
                                              if (!context.mounted) return;
                                              Navigator.pushNamed(
                                                context,
                                                '/letters/show',
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                if (_isBannerLoaded)
                  SizedBox(
                    width: _banner.size.width.toDouble(),
                    height: _banner.size.height.toDouble(),
                    child: AdWidget(ad: _banner),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
