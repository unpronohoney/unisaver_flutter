// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get main_welcome => 'Welcome';

  @override
  String get main_btns1 => 'Manually';

  @override
  String get main_btns2 => 'By Combinations';

  @override
  String get main_btns3 => 'With Transcript';

  @override
  String get manuel_desc =>
      'First, give GPA and total credits.\nThen enter your lessons with old grade and your new grade.\nUniSaver calculates GPA every step.';

  @override
  String get combination_desc =>
      'First, GPA and total credits;\nThen enter lessons you want with old grades.\nList lessons by difficulties.\nReduce total combination count by constraints.\nView results.';

  @override
  String get transcript_desc =>
      'Select your e-Devlet transcript.\nWait a little bit.\nAnd, UniSaver scanned whole transcript and created table with your lessons.\nYou can make every changes with this table.';

  @override
  String get person => 'Calculation Preference';

  @override
  String get user_type_head => 'Hello 👋\nYour GPA assistant wonders;';

  @override
  String get user_type_question =>
      'Which word best describes you in terms of average and score?';

  @override
  String get description_question =>
      'I need this information to measure the performance of different types of computations. 😇';

  @override
  String get curious => 'Curious';

  @override
  String get careful => 'Careful';

  @override
  String get decisive => 'Decisive';

  @override
  String get selected => 'Selected';

  @override
  String get curious_desc =>
      'Instead of playing out the scenarios in your head, you can find out how they all end with me.';

  @override
  String get careful_desc =>
      'You can obtain your E-Devlet transcript and perform calculations using all your courses.';

  @override
  String get decisive_desc =>
      'If you stick to traditional methods, you can easily calculate it with me.';

  @override
  String get recommend_manual => 'To get decisive results';

  @override
  String get recommend_comb => 'To explore every possibility';

  @override
  String get recommend_trans => 'To perform thorough calculation';

  @override
  String get req_timeout => 'Request Time Out';

  @override
  String get req_exp => 'Something went wrong. Please try again later.';

  @override
  String get suggest_manual => 'For decisive people';

  @override
  String get suggest_comb => 'For curious people';

  @override
  String get suggest_trans => 'For careful people';

  @override
  String get required_net => 'Internet connection required';

  @override
  String get net_desc => 'You need an internet connection to use UniSaver.';

  @override
  String get retry => 'Retry';

  @override
  String get main_head1 => 'Calculate your GPA:';

  @override
  String get main_head2 => 'Privacy Policy';

  @override
  String get main_head3 => 'Feedback Deletion Request';

  @override
  String get menu1 => 'Customize Letter Grades';

  @override
  String get menu2 => 'Language - English';

  @override
  String get menu3 => 'Contact Us';

  @override
  String lecture_subtitle(Object cred, Object newletter, Object oldletter) {
    return 'Credit: $cred\nGrade: $oldletter → $newletter';
  }

  @override
  String lecture_subtitle_com(Object cred, Object oldletter) {
    return 'Credit: $cred Grade: $oldletter';
  }

  @override
  String get edit_lecture => 'Edit Lesson';

  @override
  String get save => 'Save';

  @override
  String get new_letter => 'New Letter Grade';

  @override
  String get old_letter => 'Old Letter Grade';

  @override
  String get credit => 'Credit';

  @override
  String get letter_grade => 'Letter Grade';

  @override
  String lecture_card(Object cred, Object letter) {
    return 'Credit/Grade: $cred/$letter';
  }

  @override
  String lecture_info(Object cred, Object letter, Object name, Object no) {
    return '$no. $name\nCr/Gr: $cred/$letter';
  }

  @override
  String get hardest => 'Hardest';

  @override
  String get hard => 'Hard';

  @override
  String get medium => 'Medium';

  @override
  String get easy => 'Easy';

  @override
  String get easiest => 'Easiest';

  @override
  String get whats_difficulties => 'What Do Difficulty Levels Mean?';

  @override
  String get hardest_info => 'Hardest lessons: Intensive, high effort';

  @override
  String get hard_info => 'Hard lessons: Challenging';

  @override
  String get medium_info => 'Medium lessons: Balanced';

  @override
  String get easy_info => 'Easy lessons: Comfortable';

  @override
  String get easiest_info => 'Easiest lessons: Light subjects';

  @override
  String get how_use_diffs =>
      'Change the difficulty levels of the lessons by long pressing and dragging.';

  @override
  String get min_gpa => 'Min GPA';

  @override
  String get max_gpa => 'Max GPA';

  @override
  String get constraints_title => 'What Does Constraints Do?';

  @override
  String get constraints_description =>
      'You can decrease the count of all possible combinations with these constraints:';

  @override
  String get first_constraint => 'Min/Max GPAs';

  @override
  String get first_const_desc =>
      'Set a range of GPA values that combinations must fit.';

  @override
  String get second_constraint => 'Min/Max Letter Grade';

  @override
  String get second_const_desc =>
      'Set a range of grades that lessons of combinations must fit.';

  @override
  String get third_constraint => 'Combination Width Limit';

  @override
  String get third_const_desc =>
      'This variable defines how many combinations can have same GPAs.';

  @override
  String get fourt_constraint => 'GPA Divider';

  @override
  String get fourth_const_desc =>
      'Default value is 0.01. Combinations are eliminated if they have GPAs that are divisible by this variable.';

  @override
  String get min_letter => 'Min Letter';

  @override
  String get max_letter => 'Max Letter';

  @override
  String get select => 'Select';

  @override
  String get apply_constraints => 'Apply Constraints';

  @override
  String get show_combs => 'Show Combinations';

  @override
  String get tot_cred => 'Total Credits';

  @override
  String get details => 'Show Details';

  @override
  String get select_gpa => 'Select a GPA from above';

  @override
  String get selected_gpa => 'Selected GPA';

  @override
  String get oldl => 'Old';

  @override
  String get newl => 'New';

  @override
  String get effect => 'Effect';

  @override
  String get comb_count => 'Combination Count';

  @override
  String get lesson => 'Lesson';

  @override
  String get initial => 'Init';

  @override
  String get diff => 'Change';

  @override
  String get result => 'Result';

  @override
  String get term => 'Term';

  @override
  String get gpa_column => 'GPA';

  @override
  String get currentAgno => 'Current GPA grade';

  @override
  String get totalCred2 => 'Current total credits';

  @override
  String get butPassAdding => 'Go to Lesson Entry';

  @override
  String agno_cred(Object credits, Object gpa) {
    return 'GPA: $gpa Credits: $credits';
  }

  @override
  String get manuel_5 => 'Lesson name';

  @override
  String get lecCred => 'Lesson credit';

  @override
  String get oldletterinfo => 'Previous letter:';

  @override
  String get newletterinfo => 'New letter:';

  @override
  String get butAddLec => 'Add Lesson';

  @override
  String get yok => 'None';

  @override
  String get ok => 'Done';

  @override
  String derssayar(Object count) {
    return 'You have entered $count lessons.';
  }

  @override
  String get kisitlar => 'Calculation Constraints';

  @override
  String get refresh => 'Refresh';

  @override
  String get doc_cannot_read => 'The document could not be read.';

  @override
  String get doc_not_from_egov =>
      'The document is not a transcript from E-Devlet.';

  @override
  String get trans_btn => 'Select Transcript';

  @override
  String get error_occured => 'An error has occured.';

  @override
  String get select_letters => 'Select Letter Grades!';

  @override
  String get gpa_overflow => 'GPA Overflowed!';

  @override
  String gpa_overflow_desc(Object range) {
    return 'Your GPA must fit that range: $range';
  }

  @override
  String get attention_edevlet =>
      'Be careful to select the E-Devlet transcript, I cannot read the other transcripts yet. 😇';

  @override
  String credits(Object totcred) {
    return 'Credits: $totcred';
  }

  @override
  String get uni_grades_head => 'Grades and Equivalents';

  @override
  String get uni_grades =>
      'Your GPA calculated with these note map. You can delete by sliding to left unnecessary letter grades that not used in your transcript (by your lessons) at beginning.';

  @override
  String get trans_mismatch => 'There is a Mismatch! 🤥';

  @override
  String written_trans(Object temp) {
    return '$temp written on transcript: ';
  }

  @override
  String i_calculated(Object temp) {
    return '$temp I calculated: ';
  }

  @override
  String get changes_will_calc => 'Changes will calculate on: ';

  @override
  String get and => 'ALSO';

  @override
  String get degermi =>
      'Your opinions about UniSaver are very valuable to us. Please share your reviews, good or bad.';

  @override
  String get degerlendirButton => 'Rate';

  @override
  String get basaAl => 'Reset';

  @override
  String get silmeyiGeriAl => 'Undo Deletion';

  @override
  String get no_internet => 'No internet connection.';

  @override
  String get timeout_error => 'The request has expired.';

  @override
  String get light_mode => 'Light Mode';

  @override
  String get dark_mode => 'Night Mode';

  @override
  String get noti_permission => 'Notification Permission';

  @override
  String get noti_permission_desc =>
      'To turn on notifications, you need to go to the app settings.';

  @override
  String get settings => 'Settings';

  @override
  String get hi => 'Hi';

  @override
  String get add_letter_grade => 'Add Letter Grade';

  @override
  String get range_err => 'Narrow range!';

  @override
  String get range_err_desc =>
      'Array must have at least 2 different letter values.';

  @override
  String get array_name => 'Letter Array Name';

  @override
  String get letter => 'Letter';

  @override
  String get arrays_desc =>
      'You cannot edit the default array. If you want custom array, create new one.';

  @override
  String get new_lett_array => 'New Letter Array';

  @override
  String get delete_warn => 'Delete the array?';

  @override
  String delete_warn_desc(Object arr_name) {
    return 'Do you want to delete $arr_name array?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get link_not_opened => 'The link could not be opened...';

  @override
  String get link_n_opened_desc =>
      'The email address for feedback has not been created.';

  @override
  String get act_3_head3 =>
      'If you have experienced an error while calculating with your transcript, please provide your transcript as well. We cannot fix the error without seeing it…';

  @override
  String get fb_subject => 'Subject';

  @override
  String get fb_desc => 'Description';

  @override
  String get send => 'Send';

  @override
  String get feedback_info => 'Your feedback has been sent to us successfully.';

  @override
  String get feedback_error => 'Your feedback has not been sent…';

  @override
  String get aimOfProject =>
      'UniSaver is designed to be a quick and easy way to calculate your GPA.\nThe operations you can perform in this application:';

  @override
  String get info_head1 => '1 - Manual GPA Calculator:';

  @override
  String get info_head2 => '2 - GPA Calculator with Combinations:';

  @override
  String get info_head3 => '3 - GPA Calculator with Transcript:';

  @override
  String get info_head4 => '4 - Letter grade customization:';

  @override
  String get head1_exp => 'Manually enter your courses and calculate your GPA.';

  @override
  String get head2_exp =>
      'Enter all your courses for the semester, then sort them by difficulty, set restrictions, and then you can view all possible combinations.';

  @override
  String get head3_exp =>
      'You can easily complete your transactions with your transcript (.pdf extension) obtained from e-Government.\nYour private information is never shared with us during this process.';

  @override
  String get head4_exp =>
      'You can access the screen where you can customize the letter grade series you can use in transactions number 1 and 2 from the top right menu on the home page.';

  @override
  String get tmm => 'Okay';

  @override
  String get comb_copied => 'Combination copied.';

  @override
  String get giveAdvise => 'How to use UniSaver?';

  @override
  String get first_step => 'May I get?..';

  @override
  String get difficulties => 'List difficulties of lessons:';

  @override
  String get tot_comb_title => 'Total combinations count:';

  @override
  String get dersEkleyebilirsin => 'and the lessons';

  @override
  String get trans_title => 'First, I need to read the transcript...';

  @override
  String get playPuanla => 'Could you rate me? 👉👈';

  @override
  String get custom_arrays => 'Customize the letter arrays:';

  @override
  String get new_array => 'Create your own array;';

  @override
  String edit_array(Object oldName) {
    return 'Edit the $oldName;';
  }

  @override
  String get default_array => 'Review the default array;';

  @override
  String get act_3_head2 => 'Report errors and your thoughts to us';
}
