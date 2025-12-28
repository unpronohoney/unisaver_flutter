import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unisaver_flutter/database/grade_system_manager.dart';
import 'package:unisaver_flutter/database/local_database_helper.dart';
import 'package:unisaver_flutter/screens/combination_calculation/combination_calculation.dart';
import 'package:unisaver_flutter/screens/combination_calculation/combination_courses.dart';
import 'package:unisaver_flutter/screens/combination_calculation/combination_difficulty_matrix.dart';
import 'package:unisaver_flutter/screens/combination_calculation/combination_number.dart';
import 'package:unisaver_flutter/screens/combination_calculation/combinations_shower.dart';
import 'package:unisaver_flutter/screens/contact_us.dart';
import 'package:unisaver_flutter/screens/customize_letters/create_edit_array.dart';
import 'package:unisaver_flutter/screens/customize_letters/letter_arrays.dart';
import 'package:unisaver_flutter/screens/info_page.dart';
import 'package:unisaver_flutter/screens/main_screen.dart';
import 'package:unisaver_flutter/screens/manuel_calculation/manuel_calculation.dart';
import 'package:unisaver_flutter/screens/manuel_calculation/manuel_step2.dart';
import 'package:unisaver_flutter/screens/splash_screen.dart';
import 'package:unisaver_flutter/screens/transcript/select_transcript.dart';
import 'package:unisaver_flutter/screens/transcript/transcript_table.dart';
import 'package:unisaver_flutter/screens/user_type_screen.dart';
import 'package:unisaver_flutter/system/lecture_cubit.dart';
import 'package:unisaver_flutter/system/transcript_reader.dart';
import 'package:unisaver_flutter/utils/app_theme.dart';
import 'package:unisaver_flutter/utils/internet_gate.dart';
import 'package:unisaver_flutter/utils/language_provider.dart';
import 'package:unisaver_flutter/utils/theme_controller.dart';
import 'l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('gradeSystems');
  await GradeSystemManager.init();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await MobileAds.instance.initialize();
  await LocalStorageService.init();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LectureCubit())],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TranscriptReader()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => ThemeController()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final themeController = context.watch<ThemeController>();
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'UniSaver',
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: themeController.themeMode,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: lang.locale,
          supportedLocales: const [Locale('en'), Locale('tr')],
          home: InternetGate(child: const SplashScreen()),
          routes: {
            '/home': (context) => MainScreen(),
            '/manuel': (context) => ManuelCalcPage(),
            '/manuel/courses': (context) => ManuelStep2(),
            '/combination': (context) => CombinationCalcPage(),
            '/combination/courses': (context) => CombinationCourses(),
            '/combination/courses/difficulties': (context) =>
                CombinationDifficultyMatrix(),
            '/combination/courses/constraints': (context) =>
                CombinationNumber(),
            '/combination/courses/combinations': (context) =>
                CombinationsShower(),
            '/transcript': (context) => SelectTranscript(),
            '/transcript/table': (context) => TranscriptTable(),
            '/letters': (context) => LetterArrays(),
            '/letters/show': (context) => CreateEditArray(),
            '/contact': (context) => ContactUs(),
            '/info': (context) => InfoPage(),
            '/user_type': (context) => UserTypeScreen(),
            //...
          },
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (lang.locale == null) {
              if (deviceLocale == null) return const Locale('en');

              for (var locale in supportedLocales) {
                if (locale.languageCode == deviceLocale.languageCode) {
                  return locale;
                }
              }

              return const Locale('en');
            }
            return lang.locale;
          },
        );
      },
    );
  }
}
