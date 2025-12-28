import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/alerts.dart';
import 'package:unisaver_flutter/constants/background2.dart';
import 'package:unisaver_flutter/database/grade_system_manager.dart';
import 'package:unisaver_flutter/database/term_savers.dart';
import 'package:unisaver_flutter/system/grade_point_average.dart';
import 'package:unisaver_flutter/system/letter_array.dart';
import 'package:unisaver_flutter/system/term.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/loading.dart';
import 'package:unisaver_flutter/widgets/textfields/modern_text_field.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class CombinationCalcPage extends StatefulWidget {
  const CombinationCalcPage({super.key});

  @override
  State<CombinationCalcPage> createState() => _CombinationCalcPageState();
}

class _CombinationCalcPageState extends State<CombinationCalcPage> {
  final _gpaController = TextEditingController();
  final _credController = TextEditingController();
  bool _isBannerLoaded = false;
  bool _isLoading = false;
  bool _isTermLocal = false;

  late BannerAd _banner;

  @override
  void initState() {
    super.initState();
    _gpaController.text = Term.instance.oldgpa == 0
        ? ''
        : Term.instance.oldgpa.toString();
    _credController.text = Term.instance.oldcred == 0
        ? ''
        : Term.instance.oldcred.toString();
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
    GradeSystemManager.initLetterArray();
    initCombination();
  }

  void initCombination() async {
    setState(() {
      _isLoading = true;
    });
    _isTermLocal = await readSemesterForCombination();
    _gpaController.text = Term.instance.oldgpa == 0
        ? ''
        : Term.instance.oldgpa.toString();
    _credController.text = Term.instance.oldcred == 0
        ? ''
        : Term.instance.oldcred.toString();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _gpaController.dispose();
    _credController.dispose();
    _banner.dispose();
    super.dispose();
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
                  onHomePressed: () {
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {},
                  isrightbuttonappear: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        HeadText(text: t(context).first_step),
                        const SizedBox(height: 24),
                        ModernTextField(
                          controller: _gpaController,
                          label: t(context).currentAgno,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        ModernTextField(
                          controller: _credController,
                          label: t(context).totalCred2,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 32),
                        PurpleButton(
                          text: t(context).butPassAdding,
                          onPressed: () {
                            if (_isTermLocal) {
                              Navigator.pushNamed(
                                context,
                                '/combination/courses',
                              );
                              return;
                            }
                            if (_gpaController.text.isNotEmpty &&
                                double.tryParse(
                                      _gpaController.text.replaceAll(',', '.'),
                                    ) !=
                                    null &&
                                _credController.text.isNotEmpty &&
                                int.tryParse(_credController.text) != null) {
                              double gpa = double.parse(
                                _gpaController.text.replaceAll(',', '.'),
                              );
                              if (LetterArray.checkGpaValid(gpa)) {
                                int cred = int.parse(_credController.text);
                                if (cred >= 0) {
                                  Term.instance.initialize(
                                    GradePointAverage(
                                      totCred: cred,
                                      currentGPA: gpa,
                                    ),
                                  );
                                  Navigator.pushNamed(
                                    context,
                                    '/combination/courses',
                                  );
                                }
                              } else {
                                showAlert(
                                  context,
                                  t(context).gpa_overflow,
                                  t(context).gpa_overflow_desc(
                                    '${LetterArray.lettermap[LetterArray.letters.first]} - ${LetterArray.lettermap[LetterArray.letters.last]}',
                                  ),
                                );
                              }
                            }
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
          if (_isLoading) Loading(),
        ],
      ),
    );
  }
}
