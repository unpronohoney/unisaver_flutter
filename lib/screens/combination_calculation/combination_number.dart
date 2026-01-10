import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/background5.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/system/combination_constraints.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/letter_array.dart';
import 'package:unisaver_flutter/system/term.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/drop_down_spinner.dart';
import 'package:unisaver_flutter/widgets/dialogs/info_and_bottom_sheet.dart';
import 'package:unisaver_flutter/widgets/textfields/modern_text_field.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/change_int_shower.dart';
import 'package:unisaver_flutter/widgets/texts/common_text.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/texts/old_info_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class CombinationNumber extends StatefulWidget {
  const CombinationNumber({super.key});

  @override
  State<StatefulWidget> createState() => CombinationNumberState();
}

class CombinationNumberState extends State<CombinationNumber> {
  Map<double, List<int>> combinationswithgpas = {};
  List<List<int>> combinations = [];
  late BannerAd _banner;
  bool _isBannerLoaded = false;

  int totalCount = -1;
  int previousCount = -1;
  double? minGpa;
  double? maxGpa;
  bool isLoading = true;
  bool isApplying = false;
  String noneLetter = "";
  List<Lecture> sortedLectures = [];
  String minlett = "";
  String maxlett = "";
  ValueNotifier<String?> minLetter = ValueNotifier<String?>(null);
  ValueNotifier<String?> maxLetter = ValueNotifier<String?>(null);
  double mingpaconst = 0;
  double maxgpaconst = 0;
  TextEditingController minGpaController = TextEditingController();
  TextEditingController maxGpaController = TextEditingController();
  List<String> forbiddenLetters = [];
  TextEditingController combwidthcontroller = TextEditingController();
  TextEditingController margincontroller = TextEditingController();
  int maxCombCountWithSameGpa = 0;
  int realMaxComCountWithSameGpa = 0;
  double marginBetweenGpas = 0.01;

  bool _hasLoadedOnce = false;
  final letters = LetterArray.letters;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedOnce) {
      noneLetter = t(context).yok;

      _hasLoadedOnce = true;
    }
  }

  @override
  void initState() {
    super.initState();
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

    final levelOrder = [2, 1, 0, -1, -2];
    sortedLectures.clear();

    for (int lvl in levelOrder) {
      for (String id in Term.instance.difficulties.keys) {
        if (Term.instance.difficulties[id] == lvl) {
          sortedLectures.add(
            Term.instance.lectures.where((l) => (l.id == id)).first,
          );
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialCombinations();
    });
  }

  Future<void> _loadInitialCombinations() async {
    final result = await compute(
      findAllCombinationsIsolateWrapper,
      FindAllCombinationsPayload(
        sortedLectures: sortedLectures,
        difficulties: Term.instance.difficulties,
        letters: letters,
      ),
    );
    final Map<double, List<int>> groupedByGpa = await compute(
      listByGpasIsolateWrapper,
      ListByGpaPayload(
        gpa: Term.instance.gpa.currentGPA,
        totcred: Term.instance.gpa.totCred,
        combinations: result,
        sortedLectures: sortedLectures,
        noneLetter: noneLetter,
        letterArray: LetterArray.lettermap,
      ),
    );

    maxCombCountWithSameGpa = groupedByGpa.values
        .map((list) => list.length)
        .reduce((a, b) => a > b ? a : b);

    final gpas = groupedByGpa.keys.toList()..sort();

    if (!mounted) return;

    setState(() {
      combinations = result;
      combinationswithgpas = groupedByGpa;
      totalCount = result.length;
      previousCount = result.length;
      minGpa = gpas.isNotEmpty ? gpas.first : null;
      maxGpa = gpas.isNotEmpty ? gpas.last : null;

      minlett = letters.last;
      maxlett = letters.first;
      minLetter.value = minlett;
      maxLetter.value = maxlett;

      mingpaconst = LetterArray.lettermap[letters.last]!;
      maxgpaconst = LetterArray.lettermap[letters.first]!;
      minGpaController.text = mingpaconst.toString();
      maxGpaController.text = maxgpaconst.toString();

      realMaxComCountWithSameGpa = maxCombCountWithSameGpa;
      combwidthcontroller.text = maxCombCountWithSameGpa.toString();

      margincontroller.text = marginBetweenGpas.toString();
      isLoading = false;
    });
  }

  Future<void> _applyConstraints() async {
    setState(() {
      isApplying = true;
    });
    forbiddenLetters.clear();
    int minidx = letters.indexOf(minlett);
    int maxidx = letters.indexOf(maxlett);
    for (int i = 0; i < LetterArray.letters.length; i++) {
      if (i < maxidx || i > minidx) {
        forbiddenLetters.add(LetterArray.letters[i]);
      }
    }

    final applied = await compute(
      applyConstraintsIsolateWrapper,
      ApplyConstraintsPayload(
        gpa: Term.instance.gpa.currentGPA,
        totcred: Term.instance.gpa.totCred,
        combinations: combinations,
        sortedLectures: sortedLectures,
        noneLetter: noneLetter,
        minGpa: mingpaconst,
        maxGpa: maxgpaconst,
        forbiddenLetters: forbiddenLetters,
        maxCombCountWithSameGpa: maxCombCountWithSameGpa,
        marginBetweenGpas: marginBetweenGpas,
        letterArray: LetterArray.lettermap,
      ),
    );

    int width = applied.values
        .map((list) => list.length)
        .reduce((a, b) => a > b ? a : b);

    final gpas = applied.keys.toList()..sort();

    setState(() {
      combinationswithgpas = applied;
      previousCount = totalCount;
      totalCount = combinationswithgpas.values.fold(
        0,
        (sum, list) => sum + list.length,
      );
      minGpa = gpas.isNotEmpty ? gpas.first : null;
      maxGpa = gpas.isNotEmpty ? gpas.last : null;
      if (width < maxCombCountWithSameGpa) {
        maxCombCountWithSameGpa = width;
        combwidthcontroller.text = maxCombCountWithSameGpa.toString();
      }
      isApplying = false;
    });
  }

  static Map<double, List<int>> listByGpasIsolateWrapper(ListByGpaPayload p) {
    return CombinationConstraints.listByGpas(
      p.gpa,
      p.totcred,
      p.combinations,
      p.sortedLectures,
      p.noneLetter,
      p.letterArray,
    );
  }

  static Map<double, List<int>> applyConstraintsIsolateWrapper(
    ApplyConstraintsPayload p,
  ) {
    return CombinationConstraints.applyConstraints(
      p.combinations,
      p.gpa,
      p.totcred,
      p.sortedLectures,
      p.noneLetter,
      p.minGpa,
      p.maxGpa,
      p.forbiddenLetters,
      p.maxCombCountWithSameGpa,
      p.marginBetweenGpas,
      p.letterArray,
    );
  }

  static List<List<int>> findAllCombinationsIsolateWrapper(
    FindAllCombinationsPayload p,
  ) {
    return CombinationConstraints.findAllCombinations(
      p.sortedLectures,
      p.difficulties,
      p.letters,
    );
  }

  @override
  void dispose() {
    _banner.dispose();
    super.dispose();
    combwidthcontroller.dispose();
    margincontroller.dispose();
    maxLetter.dispose();
    minLetter.dispose();
    minGpaController.dispose();
    maxGpaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oldInfo = t(context).agno_cred(
      Term.instance.oldcred,
      ((Term.instance.oldgpa * 100).round() / 100),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground5(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.arrow_back_ios_new_sharp,
                  onHomePressed: () {
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {
                    if (!isLoading) {
                      setState(() {
                        mingpaconst = LetterArray.lettermap[letters.last]!;
                        maxgpaconst = LetterArray.lettermap[letters.first]!;
                        minGpaController.text = mingpaconst.toString();
                        maxGpaController.text = maxgpaconst.toString();
                        minlett = letters.last;
                        maxlett = letters.first;
                        minLetter.value = minlett;
                        maxLetter.value = maxlett;
                        maxCombCountWithSameGpa = realMaxComCountWithSameGpa;
                        marginBetweenGpas = 0.01;
                        margincontroller.text = marginBetweenGpas.toString();
                        combwidthcontroller.text = maxCombCountWithSameGpa
                            .toString();
                      });
                      _applyConstraints();
                    }
                  },
                  isrightbuttonappear: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        OldInfoText(text: oldInfo),
                        const SizedBox(height: 8),
                        HeadText(text: t(context).tot_comb_title),
                        SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(24),
                            border: BoxBorder.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryFixed
                                  .withValues(alpha: 0.25),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black,
                                blurRadius: 8,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: isLoading || isApplying
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    loadingTextBar(
                                      height: 32,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondaryFixed,
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            loadingTextBar(
                                              width: 25.w,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primaryFixed,
                                              height: 12,
                                            ),
                                            SizedBox(height: 8),
                                            loadingTextBar(
                                              width: 25.w,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondaryFixed,
                                              height: 18,
                                            ),
                                          ],
                                        ),

                                        Column(
                                          children: [
                                            loadingTextBar(
                                              width: 25.w,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primaryFixed,
                                              height: 12,
                                            ),
                                            SizedBox(height: 8),
                                            loadingTextBar(
                                              width: 25.w,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondaryFixed,
                                              height: 18,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$totalCount',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 32,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondaryFixed,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        if (totalCount != previousCount)
                                          SizedBox(width: 8),
                                        if (totalCount != previousCount)
                                          ChangeIntShower(
                                            diff: (totalCount - previousCount),
                                          ),
                                      ],
                                    ),

                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 40.w - 32,

                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  t(context).min_gpa,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 12,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primaryFixed,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  '$minGpa',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 18,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondaryFixed,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40.w - 32,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  t(context).max_gpa,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 12,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primaryFixed,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: 2),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  '$maxGpa',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 18,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondaryFixed,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                        SizedBox(height: 32),
                        PurpleButton(
                          text: t(context).show_combs,
                          onPressed: () {
                            Term.instance.combinations = combinations;
                            Term.instance.combsGroupedByGpas =
                                combinationswithgpas;
                            Term.instance.sortedLectures = sortedLectures;
                            Navigator.pushNamed(
                              context,
                              '/combination/courses/combinations',
                            );
                          },
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: HeadText(text: t(context).kisitlar),
                              ),
                              infoButton(context, () {
                                showDescriptionBottomSheet(
                                  context,
                                  t(context).constraints_title,
                                  t(context).constraints_description,
                                  Column(
                                    children: [
                                      constraintInfoRow(
                                        "1",
                                        t(context).first_constraint,
                                        t(context).first_const_desc,
                                      ),
                                      constraintInfoRow(
                                        "2",
                                        t(context).second_constraint,
                                        t(context).second_const_desc,
                                      ),
                                      constraintInfoRow(
                                        "3",
                                        t(context).third_constraint,
                                        t(context).third_const_desc,
                                      ),
                                      constraintInfoRow(
                                        "4",
                                        t(context).fourt_constraint,
                                        t(context).fourth_const_desc,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ModernTextField(
                              controller: minGpaController,
                              label: t(context).min_gpa,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              autoWidth: true,
                              maxLength: 4,
                            ),
                            infoButton(context, () {
                              showDescriptionBottomSheet(
                                context,
                                t(context).first_constraint,
                                t(context).first_const_desc,
                                null,
                              );
                            }),
                            ModernTextField(
                              controller: maxGpaController,
                              label: t(context).max_gpa,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              autoWidth: true,
                              maxLength: 4,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 40.w - 32,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(left: 8),
                                    child: CommonText(
                                      text: t(context).min_letter,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  DropDownSpinner(
                                    notifier: minLetter,
                                    items: letters,
                                    maxWidth: 40.w - 32,
                                  ),
                                ],
                              ),
                            ),

                            infoButton(context, () {
                              showDescriptionBottomSheet(
                                context,
                                t(context).second_constraint,
                                t(context).second_const_desc,
                                null,
                              );
                            }),
                            SizedBox(
                              width: 40.w - 32,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(right: 8),
                                    child: CommonText(
                                      text: t(context).max_letter,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  DropDownSpinner(
                                    notifier: maxLetter,
                                    items: letters,
                                    maxWidth: 40.w - 32,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 70.w - 48,
                              child: ModernTextField(
                                controller: combwidthcontroller,
                                label: t(context).third_constraint,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            infoButton(context, () {
                              showDescriptionBottomSheet(
                                context,
                                t(context).third_constraint,
                                t(context).third_const_desc,
                                null,
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: 32),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 70.w - 48,
                              child: ModernTextField(
                                controller: margincontroller,
                                label: t(context).fourt_constraint,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                              ),
                            ),
                            infoButton(context, () {
                              showDescriptionBottomSheet(
                                context,
                                t(context).fourt_constraint,
                                t(context).fourth_const_desc,
                                null,
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: 32),
                        PurpleButton(
                          text: 'Apply Constraints',
                          onPressed: () {
                            if (totalCount == -1) {
                              return;
                            }
                            int? width;
                            double? margin;
                            double? min;
                            double? max;
                            String? minletter;
                            String? maxletter;
                            bool changed = false;
                            if (combwidthcontroller.text.isNotEmpty &&
                                int.tryParse(combwidthcontroller.text) !=
                                    null) {
                              width = int.parse(combwidthcontroller.text);
                              if (width > maxCombCountWithSameGpa ||
                                  width < 1) {
                                width = null;
                                combwidthcontroller.text =
                                    maxCombCountWithSameGpa.toString();
                              } else {
                                maxCombCountWithSameGpa = width;
                                changed = true;
                              }
                            }
                            if (margincontroller.text.isNotEmpty &&
                                double.tryParse(
                                      margincontroller.text.replaceAll(
                                        ',',
                                        '.',
                                      ),
                                    ) !=
                                    null) {
                              margin = double.parse(
                                margincontroller.text.replaceAll(',', '.'),
                              );
                              if (margin < 0.01 || margin > maxGpa!) {
                                margin = null;
                                margincontroller.text = marginBetweenGpas
                                    .toString();
                              } else {
                                marginBetweenGpas = margin;
                                changed = true;
                              }
                            }
                            if (minGpaController.text.isNotEmpty &&
                                double.tryParse(
                                      minGpaController.text.replaceAll(
                                        ',',
                                        '.',
                                      ),
                                    ) !=
                                    null) {
                              min = double.parse(
                                minGpaController.text.replaceAll(',', '.'),
                              );
                              if (min < LetterArray.lettermap[letters.last]! ||
                                  min > LetterArray.lettermap[letters.first]!) {
                                min = null;
                                minGpaController.text = mingpaconst.toString();
                              }
                            }
                            if (maxGpaController.text.isNotEmpty &&
                                double.tryParse(
                                      maxGpaController.text.replaceAll(
                                        ',',
                                        '.',
                                      ),
                                    ) !=
                                    null) {
                              max = double.parse(
                                maxGpaController.text.replaceAll(',', '.'),
                              );
                              if (max < LetterArray.lettermap[letters.last]! ||
                                  max > LetterArray.lettermap[letters.first]!) {
                                max = null;
                                maxGpaController.text = maxgpaconst.toString();
                              }
                            }
                            if (max != null && min != null) {
                              if (min > max) {
                                min = null;
                                max = null;
                                minGpaController.text = mingpaconst.toString();
                                maxGpaController.text = maxgpaconst.toString();
                              } else {
                                mingpaconst = min;
                                maxgpaconst = max;
                                changed = true;
                              }
                            } else if (min != null) {
                              if (min > maxgpaconst) {
                                min = null;
                                minGpaController.text = mingpaconst.toString();
                              } else {
                                mingpaconst = min;
                                changed = true;
                              }
                            } else if (max != null) {
                              if (mingpaconst > max) {
                                max = null;
                                maxGpaController.text = maxgpaconst.toString();
                              } else {
                                maxgpaconst = max;
                                changed = true;
                              }
                            }
                            if (minLetter.value != null) {
                              minletter = minLetter.value;
                            }
                            if (maxLetter.value != null) {
                              maxletter = maxLetter.value;
                            }
                            if (minletter != null && maxletter != null) {
                              if (letters.indexOf(minletter) <
                                  letters.indexOf(maxletter)) {
                                minletter = null;
                                maxletter = null;
                              } else {
                                minlett = minletter;
                                maxlett = maxletter;
                                changed = true;
                              }
                            } else if (minletter != null) {
                              if (letters.indexOf(minletter) <
                                  letters.indexOf(maxlett)) {
                                minletter = null;
                              } else {
                                minlett = minletter;
                                changed = true;
                              }
                            } else if (maxletter != null) {
                              if (letters.indexOf(minlett) <
                                  letters.indexOf(maxletter)) {
                                maxletter = null;
                              } else {
                                maxlett = maxletter;
                                changed = true;
                              }
                            }
                            if (changed) {
                              _applyConstraints();
                            }
                          },
                        ),
                        const SizedBox(height: 32),
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

  Widget constraintInfoRow(String counter, String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "$counter. $value  ",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiaryFixed,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
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

  Widget loadingTextBar({
    double width = double.infinity,
    double height = 18,
    Color color = AppColors.gray,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColors.grayishBlue,
      highlightColor: AppColors.whiteish,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
