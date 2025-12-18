import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initLanguageSubscription() async {
  final prefs = await SharedPreferences.getInstance();

  final alreadySubscribed = prefs.getBool('lang_subscribed') ?? false;
  if (alreadySubscribed) return;

  final lang = PlatformDispatcher.instance.locale.languageCode;

  if (lang == 'tr') {
    await FirebaseMessaging.instance.subscribeToTopic('all_tr');
    await FirebaseMessaging.instance.unsubscribeFromTopic('all_en');
  } else {
    await FirebaseMessaging.instance.subscribeToTopic('all_en');
    await FirebaseMessaging.instance.unsubscribeFromTopic('all_tr');
  }

  await prefs.setBool('lang_subscribed', true);
}
