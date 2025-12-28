import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/background4.dart';
import 'package:unisaver_flutter/database/term_savers.dart';
import 'package:unisaver_flutter/system/term.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/utils/usage_tracker.dart';
import 'package:unisaver_flutter/widgets/difficulty_matrix.dart';
import 'package:unisaver_flutter/widgets/dialogs/info_and_bottom_sheet.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class CombinationDifficultyMatrix extends StatefulWidget {
  const CombinationDifficultyMatrix({super.key});
  @override
  State<StatefulWidget> createState() => CombinationDifficultyMatrixState();
}

class CombinationDifficultyMatrixState
    extends State<CombinationDifficultyMatrix>
    with WidgetsBindingObserver {
  late BannerAd _banner;
  bool _isBannerLoaded = false;

  Timer? _saveTimer;

  void scheduleSave() async {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 5), () async {
      await saveSemesterToLocalForCombination();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      await saveSemesterToLocalForManuel();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _banner = BannerAd(
      adUnitId: AdMobIds.combinationBanner,
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
    UsageTracker.combination();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveTimer?.cancel();
    _banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Term.instance.lectures.length != Term.instance.difficulties.length) {
      Term.instance.initializeDifficulties();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground4(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.arrow_back_ios_new_sharp,
                  onHomePressed: () {
                    _saveTimer?.cancel();
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {
                    if (!Term.instance.difficulties.values.every(
                      (v) => v == 0,
                    )) {
                      setState(() {
                        Term.instance.initializeDifficulties();
                      });
                    }
                  },
                  isrightbuttonappear: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              HeadText(text: t(context).difficulties),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  infoButton(context, () {
                                    showDescriptionBottomSheet(
                                      context,
                                      t(context).whats_difficulties,
                                      t(context).how_use_diffs,
                                      Column(
                                        children: [
                                          difficultyInfoRow(
                                            "+2",
                                            t(context).hardest_info,
                                            const Color(0xff7B1FA2),
                                          ),
                                          difficultyInfoRow(
                                            "+1",
                                            t(context).hard_info,
                                            const Color(0xffD32F2F),
                                          ),
                                          difficultyInfoRow(
                                            "0",
                                            t(context).medium_info,
                                            const Color(0xffFBC02D),
                                          ),
                                          difficultyInfoRow(
                                            "-1",
                                            t(context).easy_info,
                                            const Color(0xff66BB6A),
                                          ),
                                          difficultyInfoRow(
                                            "-2",
                                            t(context).easiest_info,
                                            const Color(0xff1B5E20),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  PurpleButton(
                                    text: t(context).ok,
                                    onPressed: () async {
                                      await saveSemesterToLocalForCombination();
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          '/combination/courses/constraints',
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 8),
                        DifficultyMatrix(draggedAction: scheduleSave),
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

  Widget difficultyInfoRow(String value, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(
            "$value  ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiaryFixed,
              fontFamily: 'Roboto',
            ),
          ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryFixed,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
