import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @main_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get main_welcome;

  /// No description provided for @main_btns1.
  ///
  /// In en, this message translates to:
  /// **'Manually'**
  String get main_btns1;

  /// No description provided for @main_btns2.
  ///
  /// In en, this message translates to:
  /// **'By Combinations'**
  String get main_btns2;

  /// No description provided for @main_btns3.
  ///
  /// In en, this message translates to:
  /// **'With Transcript'**
  String get main_btns3;

  /// No description provided for @manuel_desc.
  ///
  /// In en, this message translates to:
  /// **'First, give GPA and total credits.\nThen enter your lessons with old grade and your new grade.\nUniSaver calculates GPA every step.'**
  String get manuel_desc;

  /// No description provided for @combination_desc.
  ///
  /// In en, this message translates to:
  /// **'First, GPA and total credits;\nThen enter lessons you want with old grades.\nList lessons by difficulties.\nReduce total combination count by constraints.\nView results.'**
  String get combination_desc;

  /// No description provided for @transcript_desc.
  ///
  /// In en, this message translates to:
  /// **'Select your e-Devlet transcript.\nWait a little bit.\nAnd, UniSaver scanned whole transcript and created table with your lessons.\nYou can make every changes with this table.'**
  String get transcript_desc;

  /// No description provided for @user_type_head.
  ///
  /// In en, this message translates to:
  /// **'Hello 👋\nYour GPA assistant wonders;'**
  String get user_type_head;

  /// No description provided for @user_type_question.
  ///
  /// In en, this message translates to:
  /// **'Which word best describes you in terms of average and score?'**
  String get user_type_question;

  /// No description provided for @description_question.
  ///
  /// In en, this message translates to:
  /// **'I need this information to measure the performance of different types of computations. 😇'**
  String get description_question;

  /// No description provided for @curious.
  ///
  /// In en, this message translates to:
  /// **'Curious'**
  String get curious;

  /// No description provided for @careful.
  ///
  /// In en, this message translates to:
  /// **'Careful'**
  String get careful;

  /// No description provided for @decisive.
  ///
  /// In en, this message translates to:
  /// **'Decisive'**
  String get decisive;

  /// No description provided for @curious_desc.
  ///
  /// In en, this message translates to:
  /// **'Instead of playing out the scenarios in your head, you can find out how they all end with me.'**
  String get curious_desc;

  /// No description provided for @careful_desc.
  ///
  /// In en, this message translates to:
  /// **'You can obtain your E-Devlet transcript and perform calculations using all your courses.'**
  String get careful_desc;

  /// No description provided for @decisive_desc.
  ///
  /// In en, this message translates to:
  /// **'If you stick to traditional methods, you can easily calculate it with me.'**
  String get decisive_desc;

  /// No description provided for @recommend_manual.
  ///
  /// In en, this message translates to:
  /// **'If you prefer clear and decisive results'**
  String get recommend_manual;

  /// No description provided for @recommend_comb.
  ///
  /// In en, this message translates to:
  /// **'If you\'re curious to explore every possibility'**
  String get recommend_comb;

  /// No description provided for @recommend_trans.
  ///
  /// In en, this message translates to:
  /// **'If you want a thorough calculation of all your courses'**
  String get recommend_trans;

  /// No description provided for @required_net.
  ///
  /// In en, this message translates to:
  /// **'Internet connection required'**
  String get required_net;

  /// No description provided for @net_desc.
  ///
  /// In en, this message translates to:
  /// **'You need an internet connection to use UniSaver.'**
  String get net_desc;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @main_head1.
  ///
  /// In en, this message translates to:
  /// **'Calculate your GPA:'**
  String get main_head1;

  /// No description provided for @main_head2.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get main_head2;

  /// No description provided for @main_head3.
  ///
  /// In en, this message translates to:
  /// **'Feedback Deletion Request'**
  String get main_head3;

  /// No description provided for @menu1.
  ///
  /// In en, this message translates to:
  /// **'Customize Letter Grades'**
  String get menu1;

  /// No description provided for @menu2.
  ///
  /// In en, this message translates to:
  /// **'Language - English'**
  String get menu2;

  /// No description provided for @menu3.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get menu3;

  /// No description provided for @lecture_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Credit: {cred}\nGrade: {oldletter} → {newletter}'**
  String lecture_subtitle(Object cred, Object newletter, Object oldletter);

  /// No description provided for @lecture_subtitle_com.
  ///
  /// In en, this message translates to:
  /// **'Credit: {cred} Grade: {oldletter}'**
  String lecture_subtitle_com(Object cred, Object oldletter);

  /// No description provided for @edit_lecture.
  ///
  /// In en, this message translates to:
  /// **'Edit Lesson'**
  String get edit_lecture;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @new_letter.
  ///
  /// In en, this message translates to:
  /// **'New Letter Grade'**
  String get new_letter;

  /// No description provided for @old_letter.
  ///
  /// In en, this message translates to:
  /// **'Old Letter Grade'**
  String get old_letter;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @letter_grade.
  ///
  /// In en, this message translates to:
  /// **'Letter Grade'**
  String get letter_grade;

  /// No description provided for @lecture_card.
  ///
  /// In en, this message translates to:
  /// **'Credit/Grade: {cred}/{letter}'**
  String lecture_card(Object cred, Object letter);

  /// No description provided for @lecture_info.
  ///
  /// In en, this message translates to:
  /// **'{no}. {name}\nCr/Gr: {cred}/{letter}'**
  String lecture_info(Object cred, Object letter, Object name, Object no);

  /// No description provided for @hardest.
  ///
  /// In en, this message translates to:
  /// **'Hardest'**
  String get hardest;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @easiest.
  ///
  /// In en, this message translates to:
  /// **'Easiest'**
  String get easiest;

  /// No description provided for @whats_difficulties.
  ///
  /// In en, this message translates to:
  /// **'What Do Difficulty Levels Mean?'**
  String get whats_difficulties;

  /// No description provided for @hardest_info.
  ///
  /// In en, this message translates to:
  /// **'Hardest lessons: Intensive, high effort'**
  String get hardest_info;

  /// No description provided for @hard_info.
  ///
  /// In en, this message translates to:
  /// **'Hard lessons: Challenging'**
  String get hard_info;

  /// No description provided for @medium_info.
  ///
  /// In en, this message translates to:
  /// **'Medium lessons: Balanced'**
  String get medium_info;

  /// No description provided for @easy_info.
  ///
  /// In en, this message translates to:
  /// **'Easy lessons: Comfortable'**
  String get easy_info;

  /// No description provided for @easiest_info.
  ///
  /// In en, this message translates to:
  /// **'Easiest lessons: Light subjects'**
  String get easiest_info;

  /// No description provided for @how_use_diffs.
  ///
  /// In en, this message translates to:
  /// **'Change the difficulty levels of the lessons by long pressing and dragging.'**
  String get how_use_diffs;

  /// No description provided for @min_gpa.
  ///
  /// In en, this message translates to:
  /// **'Min GPA'**
  String get min_gpa;

  /// No description provided for @max_gpa.
  ///
  /// In en, this message translates to:
  /// **'Max GPA'**
  String get max_gpa;

  /// No description provided for @constraints_title.
  ///
  /// In en, this message translates to:
  /// **'What Does Constraints Do?'**
  String get constraints_title;

  /// No description provided for @constraints_description.
  ///
  /// In en, this message translates to:
  /// **'You can decrease the count of all possible combinations with these constraints:'**
  String get constraints_description;

  /// No description provided for @first_constraint.
  ///
  /// In en, this message translates to:
  /// **'Min/Max GPAs'**
  String get first_constraint;

  /// No description provided for @first_const_desc.
  ///
  /// In en, this message translates to:
  /// **'Set a range of GPA values that combinations must fit.'**
  String get first_const_desc;

  /// No description provided for @second_constraint.
  ///
  /// In en, this message translates to:
  /// **'Min/Max Letter Grade'**
  String get second_constraint;

  /// No description provided for @second_const_desc.
  ///
  /// In en, this message translates to:
  /// **'Set a range of grades that lessons of combinations must fit.'**
  String get second_const_desc;

  /// No description provided for @third_constraint.
  ///
  /// In en, this message translates to:
  /// **'Combination Width Limit'**
  String get third_constraint;

  /// No description provided for @third_const_desc.
  ///
  /// In en, this message translates to:
  /// **'This variable defines how many combinations can have same GPAs.'**
  String get third_const_desc;

  /// No description provided for @fourt_constraint.
  ///
  /// In en, this message translates to:
  /// **'GPA Divider'**
  String get fourt_constraint;

  /// No description provided for @fourth_const_desc.
  ///
  /// In en, this message translates to:
  /// **'Default value is 0.01. Combinations are eliminated if they have GPAs that are divisible by this variable.'**
  String get fourth_const_desc;

  /// No description provided for @min_letter.
  ///
  /// In en, this message translates to:
  /// **'Min Letter'**
  String get min_letter;

  /// No description provided for @max_letter.
  ///
  /// In en, this message translates to:
  /// **'Max Letter'**
  String get max_letter;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @apply_constraints.
  ///
  /// In en, this message translates to:
  /// **'Apply Constraints'**
  String get apply_constraints;

  /// No description provided for @show_combs.
  ///
  /// In en, this message translates to:
  /// **'Show Combinations'**
  String get show_combs;

  /// No description provided for @tot_cred.
  ///
  /// In en, this message translates to:
  /// **'Total Credits'**
  String get tot_cred;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Show Details'**
  String get details;

  /// No description provided for @select_gpa.
  ///
  /// In en, this message translates to:
  /// **'Select a GPA from above'**
  String get select_gpa;

  /// No description provided for @selected_gpa.
  ///
  /// In en, this message translates to:
  /// **'Selected GPA'**
  String get selected_gpa;

  /// No description provided for @oldl.
  ///
  /// In en, this message translates to:
  /// **'Old'**
  String get oldl;

  /// No description provided for @newl.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newl;

  /// No description provided for @effect.
  ///
  /// In en, this message translates to:
  /// **'Effect'**
  String get effect;

  /// No description provided for @comb_count.
  ///
  /// In en, this message translates to:
  /// **'Combination Count'**
  String get comb_count;

  /// No description provided for @lesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lesson;

  /// No description provided for @initial.
  ///
  /// In en, this message translates to:
  /// **'Init'**
  String get initial;

  /// No description provided for @diff.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get diff;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @term.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get term;

  /// No description provided for @gpa_column.
  ///
  /// In en, this message translates to:
  /// **'GPA'**
  String get gpa_column;

  /// No description provided for @currentAgno.
  ///
  /// In en, this message translates to:
  /// **'Current GPA grade'**
  String get currentAgno;

  /// No description provided for @totalCred2.
  ///
  /// In en, this message translates to:
  /// **'Current total credits'**
  String get totalCred2;

  /// No description provided for @butPassAdding.
  ///
  /// In en, this message translates to:
  /// **'Go to Lesson Entry'**
  String get butPassAdding;

  /// No description provided for @agno_cred.
  ///
  /// In en, this message translates to:
  /// **'GPA: {gpa} Credits: {credits}'**
  String agno_cred(Object credits, Object gpa);

  /// No description provided for @manuel_5.
  ///
  /// In en, this message translates to:
  /// **'Lesson name'**
  String get manuel_5;

  /// No description provided for @lecCred.
  ///
  /// In en, this message translates to:
  /// **'Lesson credit'**
  String get lecCred;

  /// No description provided for @oldletterinfo.
  ///
  /// In en, this message translates to:
  /// **'Previous letter:'**
  String get oldletterinfo;

  /// No description provided for @newletterinfo.
  ///
  /// In en, this message translates to:
  /// **'New letter:'**
  String get newletterinfo;

  /// No description provided for @butAddLec.
  ///
  /// In en, this message translates to:
  /// **'Add Lesson'**
  String get butAddLec;

  /// No description provided for @yok.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get yok;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get ok;

  /// No description provided for @derssayar.
  ///
  /// In en, this message translates to:
  /// **'You have entered {count} lessons.'**
  String derssayar(Object count);

  /// No description provided for @kisitlar.
  ///
  /// In en, this message translates to:
  /// **'Calculation Constraints'**
  String get kisitlar;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @doc_cannot_read.
  ///
  /// In en, this message translates to:
  /// **'The document could not be read.'**
  String get doc_cannot_read;

  /// No description provided for @doc_not_from_egov.
  ///
  /// In en, this message translates to:
  /// **'The document is not a transcript from E-Devlet.'**
  String get doc_not_from_egov;

  /// No description provided for @trans_btn.
  ///
  /// In en, this message translates to:
  /// **'Select Transcript'**
  String get trans_btn;

  /// No description provided for @error_occured.
  ///
  /// In en, this message translates to:
  /// **'An error has occured.'**
  String get error_occured;

  /// No description provided for @select_letters.
  ///
  /// In en, this message translates to:
  /// **'Select Letter Grades!'**
  String get select_letters;

  /// No description provided for @gpa_overflow.
  ///
  /// In en, this message translates to:
  /// **'GPA Overflowed!'**
  String get gpa_overflow;

  /// No description provided for @gpa_overflow_desc.
  ///
  /// In en, this message translates to:
  /// **'Your GPA must fit that range: {range}'**
  String gpa_overflow_desc(Object range);

  /// No description provided for @attention_edevlet.
  ///
  /// In en, this message translates to:
  /// **'Be careful to select the E-Devlet transcript, I cannot read the other transcripts yet. 😇'**
  String get attention_edevlet;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits: {totcred}'**
  String credits(Object totcred);

  /// No description provided for @uni_grades_head.
  ///
  /// In en, this message translates to:
  /// **'Grades and Equivalents'**
  String get uni_grades_head;

  /// No description provided for @uni_grades.
  ///
  /// In en, this message translates to:
  /// **'Your GPA calculated with these note map. You can delete by sliding to left unnecessary letter grades that not used in your transcript (by your lessons) at beginning.'**
  String get uni_grades;

  /// No description provided for @trans_mismatch.
  ///
  /// In en, this message translates to:
  /// **'There is a Mismatch! 🤥'**
  String get trans_mismatch;

  /// No description provided for @written_trans.
  ///
  /// In en, this message translates to:
  /// **'{temp} written on transcript: '**
  String written_trans(Object temp);

  /// No description provided for @i_calculated.
  ///
  /// In en, this message translates to:
  /// **'{temp} I calculated: '**
  String i_calculated(Object temp);

  /// No description provided for @changes_will_calc.
  ///
  /// In en, this message translates to:
  /// **'Changes will calculate on: '**
  String get changes_will_calc;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'ALSO'**
  String get and;

  /// No description provided for @degermi.
  ///
  /// In en, this message translates to:
  /// **'Your opinions about UniSaver are very valuable to us. Please share your reviews, good or bad.'**
  String get degermi;

  /// No description provided for @degerlendirButton.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get degerlendirButton;

  /// No description provided for @basaAl.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get basaAl;

  /// No description provided for @silmeyiGeriAl.
  ///
  /// In en, this message translates to:
  /// **'Undo Deletion'**
  String get silmeyiGeriAl;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get no_internet;

  /// No description provided for @timeout_error.
  ///
  /// In en, this message translates to:
  /// **'The request has expired.'**
  String get timeout_error;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Ligth Mode'**
  String get light_mode;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Night Mode'**
  String get dark_mode;

  /// No description provided for @noti_permission.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get noti_permission;

  /// No description provided for @noti_permission_desc.
  ///
  /// In en, this message translates to:
  /// **'To turn on notifications, you need to go to the app settings.'**
  String get noti_permission_desc;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get hi;

  /// No description provided for @add_letter_grade.
  ///
  /// In en, this message translates to:
  /// **'Add Letter Grade'**
  String get add_letter_grade;

  /// No description provided for @range_err.
  ///
  /// In en, this message translates to:
  /// **'Narrow range!'**
  String get range_err;

  /// No description provided for @range_err_desc.
  ///
  /// In en, this message translates to:
  /// **'Array must have at least 2 different letter values.'**
  String get range_err_desc;

  /// No description provided for @array_name.
  ///
  /// In en, this message translates to:
  /// **'Letter Array Name'**
  String get array_name;

  /// No description provided for @letter.
  ///
  /// In en, this message translates to:
  /// **'Letter'**
  String get letter;

  /// No description provided for @arrays_desc.
  ///
  /// In en, this message translates to:
  /// **'You cannot edit the default array. If you want custom array, create new one.'**
  String get arrays_desc;

  /// No description provided for @new_lett_array.
  ///
  /// In en, this message translates to:
  /// **'New Letter Array'**
  String get new_lett_array;

  /// No description provided for @delete_warn.
  ///
  /// In en, this message translates to:
  /// **'Delete the array?'**
  String get delete_warn;

  /// No description provided for @delete_warn_desc.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete {arr_name} array?'**
  String delete_warn_desc(Object arr_name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @link_not_opened.
  ///
  /// In en, this message translates to:
  /// **'The link could not be opened...'**
  String get link_not_opened;

  /// No description provided for @link_n_opened_desc.
  ///
  /// In en, this message translates to:
  /// **'The email address for feedback has not been created.'**
  String get link_n_opened_desc;

  /// No description provided for @act_3_head3.
  ///
  /// In en, this message translates to:
  /// **'If you have experienced an error while calculating with your transcript, please provide your transcript as well. We cannot fix the error without seeing it…'**
  String get act_3_head3;

  /// No description provided for @fb_subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get fb_subject;

  /// No description provided for @fb_desc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fb_desc;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @feedback_info.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has been sent to us successfully.'**
  String get feedback_info;

  /// No description provided for @feedback_error.
  ///
  /// In en, this message translates to:
  /// **'Your feedback has not been sent…'**
  String get feedback_error;

  /// No description provided for @aimOfProject.
  ///
  /// In en, this message translates to:
  /// **'UniSaver is designed to be a quick and easy way to calculate your GPA.\nThe operations you can perform in this application:'**
  String get aimOfProject;

  /// No description provided for @info_head1.
  ///
  /// In en, this message translates to:
  /// **'1 - Manual GPA Calculator:'**
  String get info_head1;

  /// No description provided for @info_head2.
  ///
  /// In en, this message translates to:
  /// **'2 - GPA Calculator with Combinations:'**
  String get info_head2;

  /// No description provided for @info_head3.
  ///
  /// In en, this message translates to:
  /// **'3 - GPA Calculator with Transcript:'**
  String get info_head3;

  /// No description provided for @info_head4.
  ///
  /// In en, this message translates to:
  /// **'4 - Letter grade customization:'**
  String get info_head4;

  /// No description provided for @head1_exp.
  ///
  /// In en, this message translates to:
  /// **'Manually enter your courses and calculate your GPA.'**
  String get head1_exp;

  /// No description provided for @head2_exp.
  ///
  /// In en, this message translates to:
  /// **'Enter all your courses for the semester, then sort them by difficulty, set restrictions, and then you can view all possible combinations.'**
  String get head2_exp;

  /// No description provided for @head3_exp.
  ///
  /// In en, this message translates to:
  /// **'You can easily complete your transactions with your transcript (.pdf extension) obtained from e-Government.\nYour private information is never shared with us during this process.'**
  String get head3_exp;

  /// No description provided for @head4_exp.
  ///
  /// In en, this message translates to:
  /// **'You can access the screen where you can customize the letter grade series you can use in transactions number 1 and 2 from the top right menu on the home page.'**
  String get head4_exp;

  /// No description provided for @tmm.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get tmm;

  /// No description provided for @comb_copied.
  ///
  /// In en, this message translates to:
  /// **'Combination copied.'**
  String get comb_copied;

  /// No description provided for @giveAdvise.
  ///
  /// In en, this message translates to:
  /// **'How to use UniSaver?'**
  String get giveAdvise;

  /// No description provided for @first_step.
  ///
  /// In en, this message translates to:
  /// **'May I get?..'**
  String get first_step;

  /// No description provided for @difficulties.
  ///
  /// In en, this message translates to:
  /// **'List difficulties of lessons:'**
  String get difficulties;

  /// No description provided for @tot_comb_title.
  ///
  /// In en, this message translates to:
  /// **'Total combinations count:'**
  String get tot_comb_title;

  /// No description provided for @dersEkleyebilirsin.
  ///
  /// In en, this message translates to:
  /// **'and the lessons'**
  String get dersEkleyebilirsin;

  /// No description provided for @trans_title.
  ///
  /// In en, this message translates to:
  /// **'First, I need to read the transcript...'**
  String get trans_title;

  /// No description provided for @playPuanla.
  ///
  /// In en, this message translates to:
  /// **'Could you rate me? 👉👈'**
  String get playPuanla;

  /// No description provided for @custom_arrays.
  ///
  /// In en, this message translates to:
  /// **'Customize the letter arrays:'**
  String get custom_arrays;

  /// No description provided for @new_array.
  ///
  /// In en, this message translates to:
  /// **'Create your own array;'**
  String get new_array;

  /// No description provided for @edit_array.
  ///
  /// In en, this message translates to:
  /// **'Edit the {oldName};'**
  String edit_array(Object oldName);

  /// No description provided for @default_array.
  ///
  /// In en, this message translates to:
  /// **'Review the default array;'**
  String get default_array;

  /// No description provided for @act_3_head2.
  ///
  /// In en, this message translates to:
  /// **'Report errors and your thoughts to us'**
  String get act_3_head2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
