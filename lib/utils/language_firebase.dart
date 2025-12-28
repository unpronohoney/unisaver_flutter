import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:unisaver_flutter/database/local_database_helper.dart';

Future<void> initLanguageSubscription(String lang) async {
  final subscribedLang = LocalStorageService.subscribedLang;

  if (subscribedLang != null && subscribedLang != lang && lang == 'tr') {
    await FirebaseMessaging.instance.subscribeToTopic('all_tr');
    await FirebaseMessaging.instance.unsubscribeFromTopic('all_en');
    LocalStorageService.subscribeLanguage('tr');
  } else if (subscribedLang != lang) {
    await FirebaseMessaging.instance.subscribeToTopic('all_en');
    await FirebaseMessaging.instance.unsubscribeFromTopic('all_tr');
    LocalStorageService.subscribeLanguage('en');
  }
}
