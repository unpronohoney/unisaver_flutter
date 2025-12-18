import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/alerts.dart';
import 'package:unisaver_flutter/constants/background3.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/constants/list_constants.dart';
import 'package:unisaver_flutter/database/grade_system_manager.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/textfields/modern_text_field.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class CreateEditArray extends StatefulWidget {
  const CreateEditArray({super.key});

  @override
  State<StatefulWidget> createState() => _StateCreateEditArray();
}

class _StateCreateEditArray extends State<CreateEditArray> {
  late BannerAd _banner;
  bool _isBannerLoaded = false;

  String oldName = '';
  int? newEditDef;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController letterCtrl = TextEditingController();
  TextEditingController effectCtrl = TextEditingController();
  Map<String, double> letterArray = {};
  List<String> letters = [];
  ValueNotifier<bool> nameError = ValueNotifier(false);
  ValueNotifier<int> letterError = ValueNotifier(
    0,
  ); //0-no error, 1-letter err, 2-value err, 3- both

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
    final system = GradeSystemManager.editingSystem;
    if (system != null) {
      oldName = system['name'];
      letterArray = Map<String, double>.from(system['letters']);
      letters = letterArray.keys.toList();
    }
    nameCtrl.text = oldName.toString();
    if (oldName == 'Default') {
      newEditDef = 3;
    } else if (oldName == '') {
      newEditDef = 1;
    } else {
      newEditDef = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          BlobBackground3(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.arrow_back_ios_new_sharp,
                  onHomePressed: () async {
                    await GradeSystemManager.resetEditingSystem();
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {},
                  isrightbuttonappear: false,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        HeadText(
                          text: newEditDef != 3
                              ? newEditDef == 1
                                    ? t(context).new_array
                                    : t(context).edit_array(oldName)
                              : t(context).default_array,
                        ),

                        const SizedBox(height: 24),

                        if (newEditDef != 3)
                          ValueListenableBuilder(
                            valueListenable: nameError,
                            builder: (context, value, child) {
                              return ModernTextField(
                                controller: nameCtrl,
                                label: t(context).array_name,
                                hasError: value,
                                onErrorReset: () {
                                  nameError.value = false;
                                },
                              );
                            },
                          ),

                        if (newEditDef != 3) const SizedBox(height: 24),
                        if (newEditDef != 3)
                          ValueListenableBuilder(
                            valueListenable: letterError,
                            builder: (context, value, child) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ModernTextField(
                                    controller: letterCtrl,
                                    label: t(context).letter,
                                    autoWidth: true,
                                    hasError: value == 1 || value == 3,
                                    onErrorReset: () {
                                      if (value == 1) {
                                        letterError.value = 0;
                                      } else {
                                        letterError.value = 2;
                                      }
                                    },
                                  ),
                                  ModernTextField(
                                    controller: effectCtrl,
                                    label: t(context).effect,
                                    keyboardType: TextInputType.number,
                                    maxLength: 5,
                                    autoWidth: true,
                                    hasError: value == 2 || value == 3,
                                    onErrorReset: () {
                                      if (value == 2) {
                                        letterError.value = 0;
                                      } else {
                                        letterError.value = 1;
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        if (newEditDef != 3) const SizedBox(height: 16),
                        if (newEditDef != 3)
                          Center(
                            child: PurpleButton(
                              text: t(context).add_letter_grade,
                              onPressed: () {
                                bool leterr =
                                    letterCtrl.text.isEmpty ||
                                    letters.contains(letterCtrl.text);
                                bool efferr =
                                    effectCtrl.text.isEmpty ||
                                    double.tryParse(effectCtrl.text) == null;
                                if (leterr && efferr) {
                                  letterError.value = 3;
                                } else if (leterr) {
                                  letterError.value = 1;
                                } else if (efferr) {
                                  letterError.value = 2;
                                } else {
                                  setState(() {
                                    letterArray[letterCtrl.text] = double.parse(
                                      effectCtrl.text,
                                    );
                                    letters.add(letterCtrl.text);
                                  });
                                }
                              },
                            ),
                          ),

                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            shrinkWrap: true,
                            itemCount: letters.length,
                            itemBuilder: (context, index) {
                              final letter = letters[index];
                              final effect = letterArray[letter];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 8,
                                ),
                                child: newEditDef == 3
                                    ? getListContainer(letter, effect!)
                                    : Dismissible(
                                        background: dismissibleBackground(),
                                        key: ValueKey(letter),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (_) {
                                          setState(() {
                                            letters.remove(letter);
                                            letterArray.remove(letter);
                                          });
                                        },
                                        confirmDismiss: (direction) async {
                                          if (letters.length == 1) {
                                            return false;
                                          }
                                          return true;
                                        },
                                        child: getListContainer(
                                          letter,
                                          effect!,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: PurpleButton(
                            text: t(context).ok,
                            onPressed: () async {
                              if (newEditDef == 3) {
                                Navigator.pop(context);
                              } else if (nameCtrl.text.isNotEmpty) {
                                if (newEditDef == 1) {
                                  final uniqueValues = letterArray.values
                                      .toSet();
                                  if (uniqueValues.length > 1) {
                                    await GradeSystemManager.endEditingSystem(
                                      letterArray,
                                      nameCtrl.text,
                                      true,
                                    );
                                  } else {
                                    showAlert(
                                      context,
                                      t(context).range_err,
                                      t(context).range_err_desc,
                                    );
                                    return;
                                  }
                                } else if (newEditDef == 2) {
                                  await GradeSystemManager.endEditingSystem(
                                    letterArray,
                                    nameCtrl.text,
                                    false,
                                  );
                                }
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              } else {
                                nameError.value = true;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
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

  Widget getListContainer(String letter, double effect) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: listCardDecoration(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            letter,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          Text(
            effect.toString(),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
