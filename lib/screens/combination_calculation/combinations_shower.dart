import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/background6.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/constants/list_constants.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/letter_array.dart';
import 'package:unisaver_flutter/system/term.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/scaffold_message.dart';
import 'package:unisaver_flutter/widgets/texts/change_shower.dart';
import 'package:unisaver_flutter/widgets/texts/common_text.dart';
import 'package:unisaver_flutter/widgets/texts/old_info_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class CombinationsShower extends StatefulWidget {
  const CombinationsShower({super.key});

  @override
  State<StatefulWidget> createState() => _CombinationsShowerState();
}

class _CombinationsShowerState extends State<CombinationsShower> {
  List<List<int>> combinations = Term.instance.combinations;
  Map<double, List<int>> combsGroupByGpa = Term.instance.combsGroupedByGpas;
  List<double> gpas = [];
  List<String> letters = LetterArray.letters;
  List<Lecture> sortedLectures = Term.instance.sortedLectures;
  double? selectedGpa;
  List<int> indexes = [];
  double totCred = 0;
  List<List<double>> effects = [];
  bool showDetails = true;

  late BannerAd _banner;
  bool _isBannerLoaded = false;

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
    gpas = combsGroupByGpa.keys.toList();
    gpas.sort();
  }

  @override
  void dispose() {
    _banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totWidth = sortedLectures.length * 80 + 106;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isLessonsFit = screenWidth > totWidth;
    double lessonCardWidth = isLessonsFit
        ? (screenWidth - 106) / sortedLectures.length
        : 80;
    totCred = Term.instance.oldcred;
    final noneletter = t(context).yok;
    for (Lecture l in sortedLectures) {
      if (l.letterGrade == noneletter) {
        totCred += l.credit;
      }
    }

    final oldInfo = t(context).agno_cred(
      Term.instance.oldcred,
      ((Term.instance.oldgpa * 100).round() / 100),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground6(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.arrow_back_ios_new_sharp,
                  onHomePressed: () {
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {},
                  isrightbuttonappear: false,
                ),
                Expanded(
                  child: Column(
                    children: [
                      OldInfoText(text: oldInfo),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 56, // kartların yüksekliği
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: gpas.length,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemBuilder: (context, index) {
                            final gpa = gpas[index];
                            return GestureDetector(
                              onTap: () {
                                if (selectedGpa == gpa) {
                                  return;
                                }
                                setState(() {
                                  selectedGpa = gpa;
                                  indexes = combsGroupByGpa[selectedGpa]!;
                                  final actcred = Term.instance.oldcred;
                                  final actgpa = Term.instance.oldgpa;
                                  effects.clear();
                                  for (int i = 0; i < indexes.length; i++) {
                                    final comb = combinations[indexes[i]];

                                    double cred = actcred;
                                    double smp = actgpa * actcred;
                                    effects.add([]);
                                    for (
                                      int j = 0;
                                      j < sortedLectures.length;
                                      j++
                                    ) {
                                      final lec = sortedLectures[j];
                                      final prevgpa = smp / cred;

                                      if (lec.letterGrade == noneletter) {
                                        smp +=
                                            LetterArray.calculateLecturePoint(
                                              letters[comb[j]],
                                              lec.credit,
                                            );
                                        cred += lec.credit;
                                        double diff =
                                            (((smp / cred) - prevgpa) * 100)
                                                .round() /
                                            100;
                                        effects[i].add(diff);
                                      } else {
                                        smp =
                                            smp +
                                            LetterArray.calculateLecturePoint(
                                              letters[comb[j]],
                                              lec.credit,
                                            ) -
                                            LetterArray.calculateLecturePoint(
                                              lec.letterGrade,
                                              lec.credit,
                                            );
                                        double diff =
                                            (((smp / cred) - prevgpa) * 100)
                                                .round() /
                                            100;
                                        effects[i].add(diff);
                                      }
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: 80,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: selectedGpa == gpa
                                      ? AppColors.koyuYesil
                                      : Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  gpa.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondaryFixed,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      t(context).tot_cred,
                                      style: TextStyle(
                                        fontFamily: 'MontserratAlternates',
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primaryFixed,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      totCred.toString(),
                                      style: TextStyle(
                                        fontFamily: 'MontserratAlternates',
                                        fontSize: 18,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondaryFixed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (selectedGpa != null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: showDetails,
                                    onChanged: (v) {
                                      setState(() {
                                        showDetails = v!;
                                      });
                                    },
                                    activeColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryFixed,
                                    checkColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  Text(
                                    t(context).details,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondaryFixed,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (selectedGpa == null)
                              Text(
                                t(context).select_gpa,
                                style: TextStyle(
                                  fontFamily: 'MontserratAlternates',
                                  fontSize: 18,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryFixed,
                                ),
                              ),
                            if (selectedGpa != null)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t(context).selected_gpa,
                                      style: TextStyle(
                                        fontFamily: 'MontserratAlternates',
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primaryFixed,
                                      ),
                                    ),

                                    Text(
                                      selectedGpa!.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontFamily: 'MontserratAlternates',
                                        fontSize: 18,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondaryFixed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (selectedGpa != null)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      t(context).comb_count,
                                      style: TextStyle(
                                        fontFamily: 'MontserratAlternates',
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primaryFixed,
                                      ),
                                    ),

                                    Text(
                                      combsGroupByGpa[selectedGpa]!.length
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'MontserratAlternates',
                                        fontSize: 18,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondaryFixed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: indexes.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          itemBuilder: (context, index) {
                            final idx = indexes[index];
                            return Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16),

                                  decoration: listCardDecoration(context),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 36,
                                              height: 36,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.red,
                                              ),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    indexes.remove(idx);
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            if (showDetails)
                                              SizedBox(
                                                height: 24,
                                                width: double.infinity,
                                                child: CommonText(
                                                  text: t(context).credit,
                                                ),
                                              ),
                                            if (showDetails)
                                              SizedBox(
                                                height: 24,
                                                width: double.infinity,
                                                child: CommonText(
                                                  text: t(context).oldl,
                                                ),
                                              ),
                                            SizedBox(
                                              height: 24,
                                              width: double.infinity,
                                              child: CommonText(
                                                text: t(context).newl,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 24,
                                              width: double.infinity,
                                              child: CommonText(
                                                text: t(context).effect,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: sortedLectures
                                                .asMap()
                                                .entries
                                                .map((entry) {
                                                  final lect = entry.value;
                                                  final lectIdx = entry.key;

                                                  return SizedBox(
                                                    width: lessonCardWidth,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 44,
                                                          child: CommonText(
                                                            text: lect.name,
                                                          ),
                                                        ),
                                                        if (showDetails)
                                                          SizedBox(
                                                            height: 24,
                                                            child: CommonText(
                                                              text: lect.credit
                                                                  .toString(),
                                                            ),
                                                          ),
                                                        if (showDetails)
                                                          SizedBox(
                                                            height: 24,
                                                            child: CommonText(
                                                              text: lect
                                                                  .letterGrade,
                                                            ),
                                                          ),
                                                        SizedBox(
                                                          height: 24,
                                                          child: CommonText(
                                                            text:
                                                                letters[combinations[idx][lectIdx]],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 24,
                                                          child: ChangeShower(
                                                            diff:
                                                                effects[index][lectIdx],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.koyuYesil,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.copy,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      onPressed: () async {
                                        final text = buildCombinationTableText(
                                          lectures: sortedLectures,
                                          combination: combinations[idx],
                                          effects: effects,
                                          combIndex: index,
                                          showDetails: showDetails,
                                          letters: letters,
                                        );

                                        await Clipboard.setData(
                                          ClipboardData(text: text),
                                        );
                                        if (!context.mounted) return;
                                        showScaffoldMessage(
                                          context,
                                          t(context).comb_copied,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
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

  String buildCombinationTableText({
    required List<Lecture> lectures,
    required List<int> combination,
    required List<List<double>> effects,
    required int combIndex,
    required bool showDetails,
    required List<String> letters,
  }) {
    final buffer = StringBuffer();

    // ✅ BAŞLIK SATIRI
    buffer.write(t(context).lesson);
    buffer.write("\t${t(context).credit}\t${t(context).oldl}");
    buffer.write("\t${t(context).newl}\t${t(context).effect}\n");

    // ✅ SATIRLAR
    for (int i = 0; i < lectures.length; i++) {
      final lect = lectures[i];

      buffer.write(lect.name);

      if (showDetails) {
        buffer.write("\t${lect.credit}");
        buffer.write("\t${lect.letterGrade}");
      }

      buffer.write("\t${letters[combination[i]]}");
      String effect = effects[combIndex][i] < 0
          ? '${effects[combIndex][i]}'
          : '+${effects[combIndex][i]}';
      buffer.write("\t$effect\n");
    }

    buffer.write(
      "${t(context).term}\t${t(context).gpa_column}\t${t(context).credit}\n",
    );
    double oldgpa = Term.instance.oldgpa;
    double oldcred = Term.instance.oldcred;
    double diff = ((selectedGpa! - oldgpa) * 100).round() / 100;
    String diffgpa = diff < 0 ? '$diff' : '+$diff';
    String diffcred = totCred - oldcred < 0
        ? '${totCred - oldcred}'
        : '+${totCred - oldcred}';
    buffer.write("${t(context).initial}\t$oldgpa\t$oldcred\n");
    buffer.write("${t(context).diff}\t$diffgpa\t$diffcred\n");
    buffer.write("${t(context).result}\t$selectedGpa\t$totCred\n");

    return buffer.toString();
  }
}
