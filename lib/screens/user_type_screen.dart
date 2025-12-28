import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:unisaver_flutter/constants/alerts.dart';
import 'package:unisaver_flutter/constants/background.dart';
import 'package:unisaver_flutter/database/local_database_helper.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/buttons/user_type_button.dart';
import 'package:unisaver_flutter/widgets/loading.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/texts/list_texts.dart';
import 'package:unisaver_flutter/widgets/texts/second_head_text.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<StatefulWidget> createState() => UserTypeScreenState();
}

class UserTypeScreenState extends State<UserTypeScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> processUserType(String type) async {
    Timer(Duration(seconds: 20), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    });

    setState(() {
      _loading = true;
    });
    try {
      final auth = FirebaseAuth.instance;
      await FirebaseFirestore.instance.collection("sanity_check").doc("ok").set(
        {"alive": true},
      );

      final firestore = FirebaseFirestore.instance;

      if (auth.currentUser == null) {
        await auth.signInAnonymously();

        final uid = auth.currentUser!.uid;

        await firestore.collection("users").doc(uid).set({
          "usedManual": 0,
          "usedCombination": 0,
          "usedTranscript": 0,
          "createdAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      final uid = auth.currentUser!.uid;
      LocalStorageService.setUserType(type);

      await firestore.collection("users").doc(uid).set({
        "userType": type,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      LocalStorageService.setFirstRun();
      setState(() {
        _loading = false;
      });
      if (!mounted) return;
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      showAlert(context, t(context).error_occured, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          const BlobBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  HeadText(text: t(context).user_type_head),
                  SizedBox(height: 20.w),
                  listTitle(context, t(context).user_type_question),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          UserTypeButton(
                            imagePath: "assets/question.png",
                            title: t(context).curious,
                            description: t(context).curious_desc,
                            onPressed: () async {
                              await processUserType("curious");
                            },
                          ),

                          const SizedBox(height: 24),
                          UserTypeButton(
                            imagePath: "assets/mental-health.png",
                            title: t(context).careful,
                            description: t(context).careful_desc,
                            onPressed: () async {
                              await processUserType("careful");
                            },
                          ),

                          const SizedBox(height: 24),

                          UserTypeButton(
                            imagePath: "assets/umpire.png",
                            title: t(context).decisive,
                            description: t(context).decisive_desc,
                            onPressed: () async {
                              await processUserType("decisive");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  listSubtitle(context, t(context).description_question),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (_loading) Loading(),
        ],
      ),
    );
  }
}
