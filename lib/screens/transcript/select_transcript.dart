import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/alerts.dart';
import 'package:unisaver_flutter/constants/background2.dart';
import 'package:unisaver_flutter/system/transcript_reader.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/dialogs/alert_template.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/loading.dart';
import 'package:unisaver_flutter/widgets/texts/description_text.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';

class SelectTranscript extends StatefulWidget {
  const SelectTranscript({super.key});
  @override
  State<SelectTranscript> createState() => _SelectTranscriptState();
}

const Map<String, String> pdfCharMap = {
  'Odieresis': 'Ö',
  'odieresis': 'ö',
  'Idotaccent': 'İ',
  'Ccedilla': 'Ç',
  'ccedilla': 'ç',
  'Scedilla': 'Ş',
  'scedilla': 'ş',
  'gbreve': 'ğ',
  'Gbreve': 'Ğ',
};

Future<void> rateMyApp(BuildContext context) async {
  final InAppReview inAppReview = InAppReview.instance;

  try {
    if (await inAppReview.isAvailable()) {
      // Uygulama içi değerlendirme açılır (iOS + Android)
      await inAppReview.requestReview();
    } else {
      // Uygulama içi popup açılmıyorsa App Store / Play Store sayfası açılır
      await inAppReview.openStoreListing(
        appStoreId: "1234567890", // iOS App Store ID (numara)
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    showAlert(context, t(context).error_occured, 'Rate error: $e');
  }
}

class _SelectTranscriptState extends State<SelectTranscript> {
  String? pdfText;
  bool _loading = false;
  late BannerAd _banner;
  bool _isBannerLoaded = false;

  InterstitialAd? _interstitialAd;
  String errorExp = "";
  bool _iserror = false;

  Future<void> pickAndReadPdf(TranscriptReader reader) async {
    setState(() => _loading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        setState(() => _loading = false);
        return;
      }

      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final doc = PdfDocument(inputBytes: bytes);
      var text = PdfTextExtractor(doc).extractText();
      if (text.trim().isEmpty) {
        setState(() {
          errorExp = t(context).doc_cannot_read;
          _loading = false;
          _iserror = true;
        });
        return;
      }
      pdfCharMap.forEach((key, value) {
        text = text.replaceAll(key, value);
      });

      String cont =
          "yükleyeceğiniz e-Devlet Kapısına ait Barkodlu Belge Doğrulama veya YÖK Mobil uygulaması vasıtası ile yandaki karekod";
      if (!text.contains(cont)) {
        setState(() {
          errorExp = t(context).doc_not_from_egov;
          _loading = false;
          _iserror = true;
        });
        return;
      }
      //log(text, name: 'Transcript Text');
      reader.extractAll(text);
      setState(() {
        _loading = false;
      });
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            _interstitialAd = null;
            _loadInterstitialAd();
            Navigator.pushNamed(context, '/transcript/table');
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            _interstitialAd = null;
            Navigator.pushNamed(context, '/transcript/table');
          },
        );
        if (!mounted) return;
        _interstitialAd!.show();
      } else {
        if (!mounted) return;
        Navigator.pushNamed(context, '/transcript/table');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorExp = t(context).doc_cannot_read;
        _iserror = true;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobIds.interstitial,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

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
  void initState() {
    super.initState();
    _loadBanner();
    //_loadInterstitialAd();
    pdfText = null;
  }

  @override
  Widget build(BuildContext context) {
    final TranscriptReader reader = context.watch<TranscriptReader>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          BlobBackground2(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.home,
                  onHomePressed: () {
                    Navigator.pop(context);
                  },
                  onRefreshPressed: () {},
                  isrightbuttonappear: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        HeadText(text: t(context).trans_title),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: DescriptionText(
                            text: t(context).attention_edevlet,
                          ),
                        ),

                        const SizedBox(height: 24),
                        PurpleButton(
                          text: t(context).trans_btn,
                          onPressed: () {
                            pickAndReadPdf(reader);
                          },
                        ),
                        const SizedBox(height: 64),
                        HeadText(text: t(context).playPuanla),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: DescriptionText(text: t(context).degermi),
                        ),
                        const SizedBox(height: 24),
                        PurpleButton(
                          text: t(context).degerlendirButton,
                          onPressed: () async {
                            await rateMyApp(context);
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
          if (_loading) Loading(),
          if (_iserror)
            AlertTemplate(
              title: t(context).error_occured,
              exp: errorExp,
              onDismiss: () {
                setState(() {
                  _iserror = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
