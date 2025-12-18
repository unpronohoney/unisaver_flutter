import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:unisaver_flutter/constants/admob_ids.dart';
import 'package:unisaver_flutter/constants/background2.dart';
import 'package:unisaver_flutter/utils/loc.dart';
import 'package:unisaver_flutter/widgets/dialogs/alert_template.dart';
import 'package:unisaver_flutter/widgets/loading.dart';
import 'package:unisaver_flutter/widgets/textfields/modern_multiline_field.dart';
import 'package:unisaver_flutter/widgets/textfields/modern_text_field.dart';
import 'package:unisaver_flutter/widgets/buttons/purple_button.dart';
import 'package:unisaver_flutter/widgets/texts/common_text.dart';
import 'package:unisaver_flutter/widgets/texts/description_text.dart';
import 'package:unisaver_flutter/widgets/texts/head_text.dart';
import 'package:unisaver_flutter/widgets/unisaver_upside_bar.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});
  @override
  State<StatefulWidget> createState() => _StateContactUs();
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

class _StateContactUs extends State<ContactUs> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();

  bool _loading = false;
  bool _iserror = false;
  String errorExp = "";
  Uint8List? pdfBytes;
  String? pdfFilename;
  ValueNotifier<bool> titleErr = ValueNotifier(false);
  bool _fbinfo = false;
  late BannerAd _banner;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _banner = BannerAd(
      adUnitId: AdMobIds.infoContactBanner,
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

  Future<void> pickPdf() async {
    setState(() {
      _loading = true;
      _iserror = false;
      errorExp = "";
      pdfFilename = null;
      pdfBytes = null;
    });
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      setState(() => _loading = false);
      return;
    }

    try {
      // PDF bytes
      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();

      // PDF objesi
      final doc = PdfDocument(inputBytes: bytes);

      // PDF içeriğinden text çek
      var text = PdfTextExtractor(doc).extractText();

      // karakter map replace (pdfCharMap kullanıyorsun)
      pdfCharMap.forEach((key, value) {
        text = text.replaceAll(key, value);
      });

      // e-Devlet kontrol texti
      const cont =
          "yükleyeceğiniz e-Devlet Kapısına ait Barkodlu Belge Doğrulama veya YÖK Mobil uygulaması vasıtası ile yandaki karekod";

      if (!text.contains(cont)) {
        setState(() {
          errorExp = t(context).doc_not_from_egov;
          _loading = false;
          _iserror = true;
        });
        return;
      }

      // Her şey yolunda → PDF bilgilerini kaydet
      setState(() {
        pdfBytes = bytes;
        pdfFilename = result.files.single.name;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _iserror = true;
        errorExp = "PDF okunurken hata oluştu: $e";
        _loading = false;
      });
    }
  }

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> sendEmail({
    required String subject,
    required String description,
  }) async {
    setState(() {
      _loading = true;
    });
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      setState(() {
        _loading = false;
        _iserror = true;
        errorExp = t(context).no_internet;
      });
      return;
    }
    final callable = FirebaseFunctions.instance.httpsCallable('sendMail');

    try {
      final result = await callable
          .call({
            'subject': subject,
            'description': description,
            'fileBase64': pdfBytes != null ? base64Encode(pdfBytes!) : null,
            'filename': pdfFilename,
          })
          .timeout(const Duration(seconds: 10));

      if (result.data['success'] != true) {
        setState(() {
          _iserror = true;
          errorExp = t(context).feedback_error;
        });
      } else {
        setState(() {
          _fbinfo = true;
          errorExp = t(context).feedback_info;
        });
      }
    } on TimeoutException {
      setState(() {
        _iserror = true;
        errorExp = t(context).timeout_error;
      });
    } catch (e) {
      setState(() {
        _iserror = true;
        errorExp = t(context).feedback_error;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          BlobBackground2(),
          SafeArea(
            child: Column(
              children: [
                UnisaverUpsideBar(
                  icon: Icons.home_filled,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        HeadText(text: t(context).act_3_head2),
                        const SizedBox(height: 24),
                        ValueListenableBuilder(
                          valueListenable: titleErr,
                          builder: (context, value, child) {
                            return ModernTextField(
                              controller: titleCtrl,
                              label: t(context).fb_subject,
                              hasError: value,
                              onErrorReset: () {
                                titleErr.value = false;
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 16),
                        DescriptionText(text: t(context).act_3_head3),

                        const SizedBox(height: 12),
                        PurpleButton(
                          text: t(context).trans_btn,
                          onPressed: () {
                            pickPdf();
                          },
                        ),
                        if (pdfFilename != null) const SizedBox(height: 8),
                        if (pdfFilename != null)
                          DescriptionText(text: pdfFilename!),
                        const SizedBox(height: 16),
                        CommonText(text: '   ${t(context).fb_desc}'),
                        const SizedBox(height: 4),
                        ModernMultilineField(controller: descCtrl),
                        const SizedBox(height: 16),
                        PurpleButton(
                          text: t(context).send,
                          onPressed: () {
                            if (titleCtrl.text.isEmpty) {
                              titleErr.value = true;
                            } else {
                              sendEmail(
                                subject: titleCtrl.text.trim(),
                                description: descCtrl.text.trim(),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 32),
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
          if (_fbinfo)
            AlertTemplate(
              title: t(context).result,
              exp: errorExp,
              onDismiss: () {
                setState(() {
                  _fbinfo = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
