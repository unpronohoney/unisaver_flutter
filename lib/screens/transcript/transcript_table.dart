import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/background3.dart';
import 'package:unisaver_flutter/constants/colors.dart';
import 'package:unisaver_flutter/constants/list_constants.dart';
import 'package:unisaver_flutter/utils/usage_tracker.dart';
import 'package:unisaver_flutter/widgets/buttons/list_edit_button.dart';
import 'package:unisaver_flutter/widgets/dialogs/info_and_bottom_sheet.dart';
import 'package:unisaver_flutter/widgets/dialogs/lecture_edit_dialog.dart';
import 'package:unisaver_flutter/system/transcript_reader.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/change_shower.dart';
import 'package:unisaver_flutter/widgets/texts/list_texts.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar_two_blue.dart';

class TranscriptTable extends StatefulWidget {
  const TranscriptTable({super.key});
  @override
  State<TranscriptTable> createState() => _TranscriptTableState();
}

class _TranscriptTableState extends State<TranscriptTable> {
  late BannerAd _banner;
  bool _isBannerLoaded = false;

  TextEditingController lecName = TextEditingController();
  TextEditingController lecCred = TextEditingController();
  TranscriptReader? reader;
  bool _shown = false;

  ValueNotifier<String?> letterNotifier = ValueNotifier<String?>(null);

  void _loadBanner() {
    _banner = BannerAd(
      adUnitId: AdMobIds.transcriptBanner,
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
  }

  @override
  void dispose() {
    letterNotifier.dispose();
    lecName.dispose();
    lecCred.dispose();
    _shown = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadBanner();
    UsageTracker.transcript();
  }

  @override
  Widget build(BuildContext context) {
    reader = context.watch<TranscriptReader>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_shown && reader!.diffLevel != 0) {
        _shown = true;
        showDescriptionBottomSheet(
          context,
          t(context).trans_mismatch,
          null,
          getMismatchDescription(),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground3(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBarTwoBlue(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onHomePressed: () {
                    reader!.reset();
                    _shown = false;
                    Navigator.pop(context);
                  },
                  onBackUpPressed: () {
                    reader!.backUp();
                  },
                  onTakeBackDeletePressed: () {
                    reader!.undoLastDeleted();
                  },
                ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            '${t(context).hi} ${reader!.studentName}',
                            style: TextStyle(
                              fontFamily: 'MontserratAlternates',
                              fontSize: 18,
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryFixed,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryFixed,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    Text(
                                      '${t(context).gpa_column}: ${(reader!.computedGpa * 100).round() / 100}',
                                      style: TextStyle(
                                        fontFamily: 'Monospace',
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (reader!.getDiffirence != 0)
                                      ChangeShower(diff: reader!.getDiffirence),
                                  ],
                                ),
                              ),

                              Text(
                                t(context).credits(reader!.computedCred),
                                style: TextStyle(
                                  fontFamily: 'Monospace',
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        Expanded(
                          child: ShaderMask(
                            shaderCallback: (Rect rect) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.white,
                                  Colors.white,
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.08, 0.92, 1.0],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstIn,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              itemCount: reader!.lessons.length,
                              itemBuilder: (context, index) {
                                final lec = reader!.lessons[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  child: Dismissible(
                                    key: ValueKey(lec.id),
                                    direction: DismissDirection.endToStart,
                                    background: dismissibleBackground(),
                                    onDismissed: (_) {
                                      reader!.removeLesson(index);
                                    },
                                    child: Container(
                                      decoration: listCardDecoration(context),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 4,
                                            ),
                                        title: listTitle(
                                          context,
                                          '${lec.no}. ${lec.name}',
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 2),
                                                Text(
                                                  t(context).credit,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12,
                                                    color:
                                                        Theme.brightnessOf(
                                                              context,
                                                            ) ==
                                                            Brightness.light
                                                        ? AppColors.blue
                                                        : AppColors.grayishBlue,
                                                  ),
                                                ),
                                                Text(
                                                  lec.credit.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primaryFixed,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 2),
                                                Text(
                                                  t(context).letter_grade,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12,
                                                    color:
                                                        Theme.brightnessOf(
                                                              context,
                                                            ) ==
                                                            Brightness.light
                                                        ? AppColors.blue
                                                        : AppColors.grayishBlue,
                                                  ),
                                                ),
                                                Text(
                                                  lec.letterGrade.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primaryFixed,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: ListEditButton(
                                          onPressed: () {
                                            showEditDialog(
                                              context,
                                              lec,
                                              3,
                                              reader!.notes.keys.toList(),
                                              reader,
                                              index,
                                              () {},
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PurpleButton(
                              width: 100.w - 96,
                              text: t(context).butAddLec,
                              onPressed: () {
                                showEditDialog(
                                  context,
                                  null,
                                  4,
                                  reader!.notes.keys.toList(),
                                  reader,
                                  0,
                                  () {},
                                );
                              },
                            ),
                            infoButton(context, () {
                              showDescriptionBottomSheet(
                                context,
                                t(context).uni_grades_head,
                                t(context).uni_grades,
                                getLetterGradesList(),
                              );
                            }, icon: Icons.grading_outlined),
                          ],
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

  Widget getLetterGradesList() {
    final lettersWithUsages = reader!.initUsedNotes;
    final List<String> letters = [
      ...lettersWithUsages.entries
          .where((e) => e.value)
          .map((e) => e.key), // true olanlar
      ...lettersWithUsages.entries
          .where((e) => !e.value)
          .map((e) => e.key), // false olanlar
    ];
    final notes = reader!.notes;
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, 0.08, 0.92, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        itemCount: letters.length,
        padding: EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) {
          final grade = letters[index];
          final isUsed = lettersWithUsages[grade]!;
          final effect = notes[grade]!;

          return isUsed
              ? getLetterGradeCard(grade, effect, isUsed)
              : Dismissible(
                  direction: DismissDirection.endToStart,
                  background: dismissibleBackground(),
                  onDismissed: (_) {
                    letters.remove(grade);
                    notes.remove(grade);
                    lettersWithUsages.remove(grade);
                    setState(() {});
                  },
                  key: ValueKey('$grade$index$effect'),
                  child: getLetterGradeCard(grade, effect, isUsed),
                );
        },
      ),
    );
  }

  Widget getLetterGradeCard(String letter, double effect, bool isUsed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        border: BoxBorder.all(
          color: isUsed
              ? AppColors.white.withValues(alpha: 0.2)
              : AppColors.white.withValues(alpha: 0.1),
          width: 2,
        ),
        color: isUsed
            ? AppColors.grayishBlue
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            letter,
            style: TextStyle(
              color: isUsed ? AppColors.blue : Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'Monospace',
            ),
          ),
          Text(
            effect.toString(),
            style: TextStyle(
              color: isUsed ? AppColors.blue : Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'Monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget getMismatchDescription() {
    final mismatch = reader!.diffLevel;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        if (mismatch == 1 || mismatch == 3)
          Column(
            children: [
              Row(
                children: [
                  Text(
                    t(context).written_trans(t(context).gpa_column),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondaryFixed,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      reader!.gpa.toString(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.tertiaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    t(context).i_calculated(t(context).gpa_column),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondaryFixed,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      reader!.computedGpa.toString(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.tertiaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    t(context).changes_will_calc,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondaryFixed,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      reader!.computedGpa.toString(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.tertiaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

        if (mismatch == 3) const SizedBox(height: 16),
        if (mismatch == 3)
          Text(
            t(context).and,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              color: AppColors.grayishBlue,
            ),
          ),
        if (mismatch == 3) const SizedBox(height: 16),
        if (mismatch == 3 || mismatch == 2)
          Column(
            children: [
              Row(
                children: [
                  Text(
                    t(context).written_trans(t(context).credit),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondaryFixed,
                    ),
                  ),
                  Text(
                    reader!.cred.toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.tertiaryFixed,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    t(context).i_calculated(t(context).credit),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondaryFixed,
                    ),
                  ),
                  Text(
                    reader!.computedCred.toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.tertiaryFixed,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    t(context).changes_will_calc,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondaryFixed,
                    ),
                  ),
                  Text(
                    reader!.computedCred.toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.tertiaryFixed,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
