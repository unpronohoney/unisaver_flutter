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
import 'package:unisaver_flutter/system/letter_array.dart';
import 'package:unisaver_flutter/system/term.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/list_edit_button.dart';
import 'package:unisaver_flutter/widgets/drop_down_spinner.dart';
import 'package:unisaver_flutter/widgets/scaffold_message.dart';
import 'package:unisaver_flutter/widgets/textfields/modern_text_field.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/change_shower.dart';
import 'package:unisaver_flutter/widgets/texts/common_text.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/texts/list_texts.dart';
import 'package:unisaver_flutter/widgets/texts/old_info_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';
import 'package:unisaver_flutter/widgets/dialogs/lecture_edit_dialog.dart';

class ManuelStep2 extends StatefulWidget {
  const ManuelStep2({super.key});

  @override
  State<ManuelStep2> createState() => ManuelStepState();
}

class ManuelStepState extends State<ManuelStep2> with WidgetsBindingObserver {
  final _courseNameController = TextEditingController();
  final _courseCredController = TextEditingController();
  double gpa = Term.instance.oldgpa;
  late BannerAd _banner;
  bool _isBannerLoaded = false;

  ValueNotifier<String?> oldLetterNotifier = ValueNotifier<String?>(null);
  ValueNotifier<String?> newLetterNotifier = ValueNotifier<String?>(null);
  ValueNotifier<String> gpaNotifier = ValueNotifier<String>('');
  ValueNotifier<String> credNotifier = ValueNotifier<String>('');
  ValueNotifier<bool> isNameOkey = ValueNotifier(false);
  ValueNotifier<bool> isCredOkey = ValueNotifier(false);

  Timer? _saveTimer;

  void scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 5), () async {
      await saveSemesterToLocalForManuel();
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
      adUnitId: AdMobIds.manuelBanner,
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
    oldLetterNotifier.dispose();
    newLetterNotifier.dispose();
    gpaNotifier.dispose();
    credNotifier.dispose();
    isNameOkey.dispose();
    isCredOkey.dispose();
    _courseNameController.dispose();
    _courseCredController.dispose();
    _banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letters = LetterArray.letters;
    final oldInfo = t(context).agno_cred(
      ((Term.instance.oldcred * 100).round() / 100),
      ((Term.instance.oldgpa * 100).round() / 100),
    );
    context.read<LectureCubit>().syncFromTerm();

    if (Term.instance.lectures.isNotEmpty) {
      gpaNotifier.value =
          '${t(context).gpa_column}: ${(Term.instance.gpa.currentGPA * 100).round() / 100}';
      credNotifier.value = t(context).credits((Term.instance.gpa.totCred * 100).round() / 100);
    }

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
                    _saveTimer?.cancel();
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {
                    context.read<LectureCubit>().clearLectures();
                    gpaNotifier.value = '';
                    credNotifier.value = '';
                    gpa = Term.instance.oldgpa;
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
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonText(text: t(context).newletterinfo),
                                  SizedBox(
                                    width: 200,
                                    child: DropDownSpinner(
                                      notifier: newLetterNotifier,
                                      items: letters,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              PurpleButton(
                                text: t(context).butAddLec,
                                onPressed: () {
                                  if (_courseCredController.text.isEmpty) {
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
                                  if (oldLetterNotifier.value == null ||
                                      newLetterNotifier.value == null) {
                                    showScaffoldMessage(
                                      context,
                                      t(context).select_letters,
                                    );
                                  }
                                  if (_courseCredController.text.isEmpty ||
                                      _courseCredController.text.isEmpty ||
                                      oldLetterNotifier.value == null ||
                                      newLetterNotifier.value == null ||
                                      double.tryParse(
                                            _courseCredController.text
                                                .replaceAll(',', '.'),
                                          ) ==
                                          null) {
                                    return;
                                  }
                                  gpa = Term.instance.gpa.currentGPA;
                                  if (context.read<LectureCubit>().addLecture(
                                    Lecture(
                                      name: _courseNameController.text,
                                      credit: double.parse(
                                        _courseCredController.text.replaceAll(
                                          ',',
                                          '.',
                                        ),
                                      ),
                                      letterGrade: oldLetterNotifier.value!,
                                      newLetterGrade: newLetterNotifier.value!,
                                    ),
                                  )) {
                                    gpaNotifier.value =
                                        '${t(context).gpa_column}: ${(Term.instance.gpa.currentGPA * 100).round() / 100}';
                                    credNotifier.value = t(
                                      context,
                                    ).credits((Term.instance.gpa.totCred * 100).round() / 100);
                                  }
                                  scheduleSave();
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: gpaNotifier,
                                    builder: (context, value, child) {
                                      double diff =
                                          ((Term.instance.gpa.currentGPA -
                                                      gpa) *
                                                  100)
                                              .round() /
                                          100;
                                      return value.isEmpty
                                          ? SizedBox()
                                          : Expanded(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    value,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondaryFixed,
                                                      fontSize: 20,
                                                      fontFamily: 'Monospace',
                                                    ),
                                                  ),
                                                  if (diff != 0.0)
                                                    ChangeShower(diff: diff),
                                                ],
                                              ),
                                            );
                                    },
                                  ),
                                  ValueListenableBuilder(
                                    valueListenable: credNotifier,
                                    builder: (context, value, child) {
                                      return Text(
                                        value,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondaryFixed,
                                          fontSize: 20,
                                          fontFamily: 'Monospace',
                                        ),
                                      );
                                    },
                                  ),
                                ],
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
                                      gpa = Term.instance.gpa.currentGPA;
                                      context
                                          .read<LectureCubit>()
                                          .deleteLecture(lec);

                                      if ((Term.instance.gpa.currentGPA * 100)
                                                  .round() /
                                              100 ==
                                          (Term.instance.oldgpa * 100).round() /
                                              100) {
                                        gpaNotifier.value = '';
                                        credNotifier.value = '';
                                      } else {
                                        gpaNotifier.value =
                                            '${t(context).gpa_column}: ${(Term.instance.gpa.currentGPA * 100).round() / 100}';
                                        credNotifier.value = t(
                                          context,
                                        ).credits((Term.instance.gpa.totCred * 100).round() / 100);
                                      }
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
                                          t(context).lecture_subtitle(
                                            lec.credit,
                                            lec.newLetterGrade,
                                            lec.letterGrade,
                                          ),
                                        ),
                                        trailing: ListEditButton(
                                          onPressed: () async {
                                            gpa = Term.instance.gpa.currentGPA;
                                            showEditDialog(
                                              context,
                                              lec,
                                              1,
                                              LetterArray.letters,
                                              null,
                                              0,
                                              () {
                                                gpaNotifier.value =
                                                    '${t(context).gpa_column}: ${(Term.instance.gpa.currentGPA * 100).round() / 100}';
                                                credNotifier.value = t(context)
                                                    .credits((Term.instance.gpa.totCred * 100).round() / 100,
                                                    );
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
