import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/background3.dart';
import 'package:unisaver_flutter/constants/list_constants.dart';
import 'package:unisaver_flutter/database/term_savers.dart';
import 'package:unisaver_flutter/system/lecture.dart';
import 'package:unisaver_flutter/system/lecture_cubit.dart';
import 'package:unisaver_flutter/widgets/buttons/list_edit_button.dart';
import 'package:unisaver_flutter/widgets/dialogs/lecture_edit_dialog.dart';
import 'package:unisaver_flutter/system/letter_array.dart';
import 'package:unisaver_flutter/system/term.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/drop_down_spinner.dart';
import 'package:unisaver_flutter/widgets/scaffold_message.dart';
import 'package:unisaver_flutter/widgets/textfields/modern_text_field.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/common_text.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/texts/list_texts.dart';
import 'package:unisaver_flutter/widgets/texts/old_info_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class CombinationCourses extends StatefulWidget {
  const CombinationCourses({super.key});
  @override
  State<StatefulWidget> createState() => CombinationCoursesState();
}

class CombinationCoursesState extends State<CombinationCourses>
    with WidgetsBindingObserver {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCredController = TextEditingController();

  ValueNotifier<String?> oldLetterNotifier = ValueNotifier<String?>(null);
  ValueNotifier<bool> isNameOkey = ValueNotifier(false);
  ValueNotifier<bool> isCredOkey = ValueNotifier(false);

  late BannerAd _banner;
  bool _isBannerLoaded = false;

  ValueNotifier<int> coursecounter = ValueNotifier<int>(0);

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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _saveTimer?.cancel();
    _banner.dispose();
    coursecounter.dispose();
    oldLetterNotifier.dispose();
    isNameOkey.dispose();
    isCredOkey.dispose();
    _courseCredController.dispose();
    _courseNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letters = LetterArray.letters;
    final oldInfo = t(context).agno_cred(
      Term.instance.oldcred,
      ((Term.instance.oldgpa * 100).round() / 100),
    );
    context.read<LectureCubit>().syncFromTerm();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground3(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.arrow_back_ios_new_sharp,
                  onHomePressed: () {
                    context.read<LectureCubit>().clearLectures();
                    coursecounter.value = 0;
                    _saveTimer?.cancel();
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {
                    context.read<LectureCubit>().clearLectures();
                    coursecounter.value = 0;
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
                              OldInfoText(text: oldInfo),
                              const SizedBox(height: 8),
                              HeadText(text: t(context).dersEkleyebilirsin),
                              const SizedBox(height: 24),
                              ValueListenableBuilder(
                                valueListenable: isNameOkey,
                                builder: (context, value, child) {
                                  return ModernTextField(
                                    controller: _courseNameController,
                                    label: t(context).manuel_5,
                                    hasError: value,
                                    onErrorReset: () {
                                      isNameOkey.value = false;
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 16),
                              ValueListenableBuilder(
                                valueListenable: isCredOkey,
                                builder: (context, value, child) {
                                  return ModernTextField(
                                    controller: _courseCredController,
                                    label: t(context).lecCred,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    hasError: value,
                                    onErrorReset: () {
                                      isCredOkey.value = false;
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonText(text: t(context).oldletterinfo),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 200,
                                    child: DropDownSpinner(
                                      notifier: oldLetterNotifier,
                                      items: [t(context).yok, ...letters],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PurpleButton(
                                    text: t(context).butAddLec,
                                    onPressed: () {
                                      if (_courseNameController.text.isEmpty) {
                                        isNameOkey.value = true;
                                      }
                                      if (_courseCredController.text.isEmpty ||
                                          double.tryParse(
                                                _courseCredController.text
                                                    .replaceAll(',', '.'),
                                              ) ==
                                              null) {
                                        isCredOkey.value = true;
                                      }
                                      if (oldLetterNotifier.value == null) {
                                        showScaffoldMessage(
                                          context,
                                          t(context).select_letters,
                                        );
                                      }
                                      if (_courseNameController.text.isEmpty ||
                                          _courseCredController.text.isEmpty ||
                                          double.tryParse(
                                                _courseCredController.text
                                                    .replaceAll(',', '.'),
                                              ) ==
                                              null ||
                                          oldLetterNotifier.value == null) {
                                        return;
                                      }

                                      double cred = double.parse(
                                        _courseCredController.text.replaceAll(
                                          ',',
                                          '.',
                                        ),
                                      );
                                      if (cred >= 0) {
                                        if (context
                                            .read<LectureCubit>()
                                            .addLectureForCombination(
                                              Lecture(
                                                credit: cred,
                                                name:
                                                    _courseNameController.text,
                                                letterGrade:
                                                    oldLetterNotifier.value ??
                                                    '',
                                              ),
                                            )) {
                                          coursecounter.value++;
                                        }
                                      }
                                      scheduleSave();
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  PurpleButton(
                                    text: t(context).ok,
                                    onPressed: () async {
                                      await saveSemesterToLocalForCombination();
                                      if (Term.instance.lectures.isNotEmpty &&
                                          context.mounted) {
                                        Navigator.pushNamed(
                                          context,
                                          '/combination/courses/difficulties',
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              ValueListenableBuilder(
                                valueListenable: coursecounter,
                                builder: (context, value, child) {
                                  return value > 0
                                      ? SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            t(context).derssayar(value),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Monospace',
                                              fontSize: 16,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondaryFixed,
                                            ),
                                          ),
                                        )
                                      : SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),

                        BlocBuilder<LectureCubit, LectureState>(
                          builder: (context, state) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.lectures.length,
                              itemBuilder: (context, index) {
                                final lec = state.lectures[index];
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
                                      context
                                          .read<LectureCubit>()
                                          .deleteLectureForCombination(lec);
                                      coursecounter.value--;
                                      scheduleSave();
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
                                        subtitle: listSubtitle(
                                          context,
                                          t(context).lecture_subtitle_com(
                                            lec.credit,
                                            lec.letterGrade,
                                          ),
                                        ),
                                        trailing: ListEditButton(
                                          onPressed: () {
                                            showEditDialog(
                                              context,
                                              lec,
                                              2,
                                              LetterArray.letters,
                                              null,
                                              0,
                                              () {
                                                scheduleSave();
                                              },
                                            );
                                          },
                                        ),
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
